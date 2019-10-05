#import "AppDelegate.h"

static NSString *const kAppToLaunchBundleIdentifier = @"com.bohemiancoding.sketch3";

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSURL *appURL = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:kAppToLaunchBundleIdentifier];
    NSBundle *bundle = [NSBundle bundleWithURL:appURL];
    NSString *executablePath = [bundle executablePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:executablePath] == NO) {
        NSLog(@"++++++ NO EXECUTABLE FOUND: %@ ++++", executablePath);
        return;
    }
    NSString *dyldLibrary = [[[NSBundle mainBundle] pathsForResourcesOfType:@"dylib" inDirectory:nil] firstObject];
    if (dyldLibrary) {
        [self launchApplicationWithInjectionPath:dyldLibrary];
    }
}

-(void)launchApplicationWithInjectionPath:(NSString *)dyldLibraryPath
{
    // Run xxx.app and inject our dynamic library
    NSError *error;
    NSURL *appURL = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:kAppToLaunchBundleIdentifier];
    NSDictionary *env = @{@"DYLD_INSERT_LIBRARIES" : dyldLibraryPath};
    NSRunningApplication *runningApplication = [[NSWorkspace sharedWorkspace] launchApplicationAtURL:appURL options:NSWorkspaceLaunchAsync configuration:@{NSWorkspaceLaunchConfigurationEnvironment : env} error:&error];
    
    // Bring it to front after a delay
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [runningApplication activateWithOptions:NSApplicationActivateIgnoringOtherApps];
        [[NSApplication sharedApplication] terminate:self];
    });
}

@end
