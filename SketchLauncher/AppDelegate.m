#import "AppDelegate.h"

static NSString *const kSketchBundleIdentifier = @"com.bohemiancoding.sketch3";

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

-(void)bringToFrontApplicationWithBundleIdentifier:(NSString*)inBundleIdentifier
{
    // Try to bring the application to front
    NSArray* appsArray = [NSRunningApplication runningApplicationsWithBundleIdentifier:inBundleIdentifier];
    if([appsArray count] > 0)
    {
        [[appsArray objectAtIndex:0] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    }
    
    // Quit ourself
    [[NSApplication sharedApplication] terminate:self];
}

-(void)launchApplicationWithPath:(NSString*)inPath andBundleIdentifier:(NSString*)inBundleIdentifier
{
    if(inPath != nil)
    {
        // Run Sketch.app and inject our dynamic library
        NSString *dyldLibrary = [[NSBundle bundleForClass:[self class]] pathForResource:@"SketchOverrides" ofType:@"dylib"];
        NSString *launcherString = [NSString stringWithFormat:@"DYLD_INSERT_LIBRARIES=\"%@\" \"%@\" &", dyldLibrary, inPath];
        
        system([launcherString UTF8String]);
        
        // Bring it to front after a delay
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_main_queue(), ^{
            [self bringToFrontApplicationWithBundleIdentifier:inBundleIdentifier];
        });
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *bundleIdentifier = kSketchBundleIdentifier;
    NSURL *appURL = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:bundleIdentifier];
    NSBundle *bundle = [NSBundle bundleWithURL:appURL];
    NSString *executablePath = [bundle executablePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:executablePath]) {
        [self launchApplicationWithPath:executablePath andBundleIdentifier:bundleIdentifier];
    }
}

@end
