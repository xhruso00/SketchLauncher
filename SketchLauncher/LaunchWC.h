#import <Cocoa/Cocoa.h>
@class Application;

@interface LaunchWC : NSWindowController

@property (nonatomic, copy) NSArray<Application *>*applications;

@end
