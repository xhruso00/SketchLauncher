#import "AppDelegate.h"
#import "Application.h"
#import "LaunchWC.h"

static NSString *const kAppToLaunchBundleIdentifier = @"com.bohemiancoding.sketch3";

@interface AppDelegate()
@property (nonatomic) LaunchWC *launchWC;
@property (nonatomic) NSArray<Application*>*applications;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if ([self moreThanOneAppExists] == NO) {
        Application *app = [[self applications] firstObject];
        if (app) {
            [app launch];
        } else {
            NSLog(@"++++++ NO APP FOUND: %@ ++++", kAppToLaunchBundleIdentifier);
            return;
        }
    } else {
        [[self launchWC] showWindow:self];
    }   
}

- (BOOL)moreThanOneAppExists
{
    return [[self applications] count] > 1;
}

- (NSArray<Application*>*)applications
{
    if (_applications == nil) {
        CFErrorRef error;
        CFArrayRef URLs = LSCopyApplicationURLsForBundleIdentifier((CFStringRef)kAppToLaunchBundleIdentifier, &error);
        NSUInteger numberOfURLs = CFArrayGetCount(URLs);
        NSMutableArray<Application*>*apps = [NSMutableArray new];
        for (int idx = 0; idx < numberOfURLs; idx++) {
            NSURL *URL = (NSURL *)CFArrayGetValueAtIndex(URLs, idx);
            Application *app = [[Application alloc] initWithBundleURL:URL];
            [apps addObject:app];
        }
        CFRelease(URLs);
        _applications = apps;
    }
    return _applications;
}

- (LaunchWC *)launchWC
{
    if (_launchWC == nil) {
        _launchWC = [[LaunchWC alloc] init];
        [_launchWC setApplications:[self applications]];
    }
    return _launchWC;
}


@end
