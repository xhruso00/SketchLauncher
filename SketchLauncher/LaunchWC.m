#import "LaunchWC.h"
#import "Application.h"
static NSNibName kLaunchWindowName = @"Launch";

@interface LaunchWC ()

@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSArrayController *arrayController;

@end

@implementation LaunchWC

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self arrayController] setContent:[self applications]];
}

- (NSNibName)windowNibName
{
    return kLaunchWindowName;
}

- (IBAction)launchButtonClicked:(id)sender
{
    [self launchSelectedApplication];
}

- (Application *)selectedApplication
{
    return [[[self arrayController] selectedObjects] firstObject];
}

- (IBAction)tableViewDoubleAction:(NSArray<Application*>*)applications
{
    [self launchApplication:[applications firstObject]];
}

- (void)launchSelectedApplication
{
    [self launchApplication:[self selectedApplication]];
}

- (void)launchApplication:(Application *)application
{
    [application launch];
}

#pragma mark NSTableViewDelegate
- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors
{
    
}

@end
