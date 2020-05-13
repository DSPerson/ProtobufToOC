//
//  FinderSync.m
//  FinderSync
//
//  Created by DSperson on 2019/10/24.
//  Copyright © 2019 bat. All rights reserved.
//

#import "FinderSync.h"
#import "UserDefault.h"
@interface FinderSync ()

@property NSURL *myFolderURL;
@property NSString *pathss;
@end

@implementation FinderSync

- (instancetype)init {
    self = [super init];

    NSLog(@"%s launched from %@ ; compiled at %s", __PRETTY_FUNCTION__, [[NSBundle mainBundle] bundlePath], __TIME__);
    _pathss = @"未开始呢";
    // Set up the directory we are syncing.
    self.myFolderURL = [NSURL fileURLWithPath:@"/Applications"];
    [FIFinderSyncController defaultController].directoryURLs = [NSSet setWithObject:self.myFolderURL];

    // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf images.
    [[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameColorPanel] label:@"Status One" forBadgeIdentifier:@"One"];
    [[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameCaution] label:@"Status Two" forBadgeIdentifier:@"Two"];
    
    return self;
}

#pragma mark - Primary Finder Sync protocol methods

- (void)beginObservingDirectoryAtURL:(NSURL *)url {
    // The user is now seeing the container's contents.
    // If they see it in more than one view at a time, we're only told once.
    NSLog(@"beginObservingDirectoryAtURL:%@", url.filePathURL);
}


- (void)endObservingDirectoryAtURL:(NSURL *)url {
    // The user is no longer seeing the container's contents.
    NSLog(@"endObservingDirectoryAtURL:%@", url.filePathURL);
}

- (void)requestBadgeIdentifierForURL:(NSURL *)url {
    NSLog(@"requestBadgeIdentifierForURL:%@", url.filePathURL);
    
    // For demonstration purposes, this picks one of our two badges, or no badge at all, based on the filename.
//    NSInteger whichBadge = [url.filePathURL hash] % 3;
//    NSString* badgeIdentifier = @[@"", @"One", @"Two"][whichBadge];
//    [[FIFinderSyncController defaultController] setBadgeIdentifier:badgeIdentifier forURL:url];
}

#pragma mark - Menu and toolbar item support

- (NSString *)toolbarItemName {
    return @"FinderSync";
}

- (NSString *)toolbarItemToolTip {
    return _pathss;
}

- (NSImage *)toolbarItemImage {
//    return [NSImage imageNamed:NSImageNameCaution];
    return [NSImage imageNamed:@"capti.png"];
}

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu
{
    NSURL* target = [[FIFinderSyncController defaultController] targetedURL];
    NSArray* items = [[FIFinderSyncController defaultController] selectedItemURLs];
    NSLog(@"");
    NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:@"testTitle" action:@selector(sampleAction:) keyEquivalent:@""];
    menuItem.tag = 1;
    NSLog(@"p---->");
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"123"];
    [menu addItem:menuItem];

    return menu;
}


- (IBAction)sampleAction:(id)sender {
    
//    NSOpenPanel *open = [NSOpenPanel openPanel];
    
    NSURL* target = [[FIFinderSyncController defaultController] targetedURL];
    NSArray* items = [[FIFinderSyncController defaultController] selectedItemURLs];

    [items enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"    %@", [obj filePathURL]);
    }];

    NSURL *path = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSUserDomainMask].firstObject;
    NSString *file = path.path;
    NSArray <NSString *>*v = [file componentsSeparatedByString:@"/"];
    NSMutableString *value = [NSMutableString stringWithCapacity:3];
    for (NSInteger i = 1; i < 3; i++) {
        [value appendFormat:@"%@/",v[i]];
    }
    [value appendString:@"Applications/DSpersonProtobuf.app"];
    _pathss = path.path;
    self.myFolderURL = [self.myFolderURL URLByAppendingPathComponent:@"DSpersonProtobuf.app" isDirectory:false];
    [UserDefault setselectPath:[NSURL URLWithString:@"123"]];
    
    if (@available(macOS 10.15, *)) {
        NSWorkspaceOpenConfiguration *config = [NSWorkspaceOpenConfiguration configuration];
        [config setArguments:@[target.path]];
        [[NSWorkspace sharedWorkspace] openApplicationAtURL:self.myFolderURL configuration:config completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {

        }];
    } else {

        [[NSWorkspace sharedWorkspace] openURL:self.myFolderURL options:NSWorkspaceLaunchDefault configuration:@{
            NSWorkspaceLaunchConfigurationArguments: @[target.path]
        }  error:nil];
    }
}

@end

