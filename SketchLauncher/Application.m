#import "Application.h"
#import <CoreFoundation/CoreFoundation.h>
#import <Cocoa/Cocoa.h>

static NSString *const kCFBundleShortVersionString = @"CFBundleShortVersionString";
static NSString *const kCFBundleIconFile = @"CFBundleIconFile";

@interface Application() {
    NSBundle *_bundle;
}

@end

@implementation Application

- (instancetype)initWithBundleURL:(NSURL *)bundleURL
{
    self = [super init];
    if (self) {
        _bundle = [NSBundle bundleWithURL:bundleURL];
    }
    return self;
}

- (void)launch
{
    [self launchWithDyldLibraryPath:[self dyldLibraryPath]];
}

- (void)launchWithDyldLibraryPath:(NSString *)dyldLibraryPath
{
    // Run xxx.app and inject our dynamic library
    NSError *error;
    NSURL *appURL = [self bundleURL];
    NSDictionary *env = @{@"DYLD_INSERT_LIBRARIES" : dyldLibraryPath};
    NSRunningApplication *runningApplication = [[NSWorkspace sharedWorkspace] launchApplicationAtURL:appURL options:NSWorkspaceLaunchAsync configuration:@{NSWorkspaceLaunchConfigurationEnvironment : env} error:&error];
    
    // Bring it to front after a delay
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [runningApplication activateWithOptions:NSApplicationActivateIgnoringOtherApps];
        [[NSApplication sharedApplication] terminate:self];
    });
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@", [super description], [self appName] ,[self shortVersion]];
}

- (NSString *)shortVersion
{
    return [_bundle infoDictionary][kCFBundleShortVersionString];
}

- (NSString *)appName
{
    return [_bundle infoDictionary][(id)kCFBundleNameKey];
}

- (NSString *)path
{
    return [[self bundleURL] absoluteString];
}

- (NSURL *)bundleURL
{
    return [_bundle bundleURL];
}

- (NSString *)dyldLibraryPath
{
    return [[[NSBundle mainBundle] pathsForResourcesOfType:@"dylib" inDirectory:nil] firstObject];
}

- (NSImage *)icon
{
    NSString *iconName = [_bundle infoDictionary][kCFBundleIconFile];
    return [NSImage imageNamed:iconName];
}

@end
