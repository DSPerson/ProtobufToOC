//
//  AppDelegate.m
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import "AppDelegate.h"
#import "DSConst.m"
@interface AppDelegate ()

@property (weak) IBOutlet NSMenu *openRecentMenu;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOpenRecent) name:kRecentListNotificationName object:nil];
    [self openRecent:nil];
    
}

- (IBAction)about:(NSMenuItem *)sender {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return false;
}
- (IBAction)openCC:(NSMenuItem *)sender {

//    [self updateOpenRecent];
}
- (IBAction)openRecent:(NSMenuItem *)sender {
    [self updateOpenRecent];
}

- (void)updateOpenRecent {
    NSArray *lists = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentList];
    [_openRecentMenu removeAllItems];
    [lists enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *pathURL = [NSURL fileURLWithPath:obj];
        NSString *name = pathURL.lastPathComponent;
        if (name.length != 0) {
            NSMenuItem *item = [[NSMenuItem alloc] init];;
            item.title = name;
            item.action = @selector(callRecentMenuSub:);
//            item.keyEquivalent = @"c";
            NSImage *image = [NSImage imageNamed:NSImageNameFolder];
            image.size = NSMakeSize(image.size.width * 0.7, image.size.height * 0.7);
            item.image = image;
            [self->_openRecentMenu addItem:item];
        }
    }];
}
- (void)callRecentMenuSub:(NSMenuItem *)select {
    
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    [NSApp activateIgnoringOtherApps:true];
    [_currentController.window makeKeyAndOrderFront:self];
    return true;
}
@end
