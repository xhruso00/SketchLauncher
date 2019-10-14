#import <Foundation/Foundation.h>

@interface Application : NSObject

- (instancetype)initWithBundleURL:(NSURL *)bundleURL;
- (NSURL *)bundleURL;
- (NSString *)shortVersion;
- (NSString *)appName;
- (NSString *)path;
- (NSString *)dyldLibraryPath;
- (NSImage *)icon;
- (void)launch;

@end
