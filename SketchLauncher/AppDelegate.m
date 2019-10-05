#import "AppDelegate.h"

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
        [self performSelector:@selector(bringToFrontApplicationWithBundleIdentifier:) withObject:inBundleIdentifier afterDelay:1.0];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *bundleIdentifier = @"com.bohemiancoding.sketch3";
    NSArray<NSURL*>*possibleAppURLs = (NSArray *)LSCopyApplicationURLsForBundleIdentifier((CFStringRef)bundleIdentifier, NULL);
    __block NSString *path;
    [possibleAppURLs enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj path] containsString:@"Sketch.app"]) {
            *stop = YES;
            path = [[obj path] copy];
        }
    }];
    path = [path stringByAppendingString:@"/Contents/MacOS/Sketch"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self launchApplicationWithPath:path andBundleIdentifier:bundleIdentifier];
    } else {
        NSString *sketchPath = @"/Applications/Sketch.app/Contents/MacOS/Sketch";
        if ([[NSFileManager defaultManager] fileExistsAtPath:sketchPath]) {
            [self launchApplicationWithPath:sketchPath andBundleIdentifier:bundleIdentifier];
        }
    }
}

@end
