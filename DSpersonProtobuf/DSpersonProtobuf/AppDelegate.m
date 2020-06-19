//
//  AppDelegate.m
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import "AppDelegate.h"
#import "DSConst.m"
#import "UserDefault.h"
@interface AppDelegate () <NSMenuDelegate>

@property (weak) IBOutlet NSMenu *openRecentMenu;

@property (nonatomic, strong) NSMutableDictionary *dic;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _openRecentMenu.delegate = self;
    NSURL *url = [UserDefault getselectPath];
    if (url) {
        NSAlert *aler = [[NSAlert alloc] init];
        aler.messageText = url.path;
        [aler beginSheetModalForWindow:self.currentController.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
    } else {
//        NSAlert *aler = [[NSAlert alloc] init];
//        aler.messageText = @"煤头纸";
//        [aler beginSheetModalForWindow:self.currentController.window completionHandler:^(NSModalResponse returnCode) {
//            
//        }];
    }
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOpenRecent) name:kUpdateRecentListNotificationName object:nil];
    [self updateOpenRecent];

    
}
- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
    
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
    
}

- (void)updateOpenRecent {
    [_openRecentMenu update];
//    image.size = NSMakeSize(image.size.width * 0.7, image.size.height * 0.7);
//    NSMenu *menu = [[NSMenu alloc] init];


//    [_openRecentMenu addItem:menu];
//    _openRecentMenu.
}
- (void)callRecentMenuSub:(NSMenuItem *)select {
    NSInteger index = [_openRecentMenu.itemArray indexOfObject:select];
    NSArray *lists = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentList];
    if (lists.count > index) {
        NSString *path = lists[index];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRecentListNotificationName object:path];
    }
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    [NSApp activateIgnoringOtherApps:true];
    [_currentController.window makeKeyAndOrderFront:self];
    return true;
}
- (void)menuNeedsUpdate:(NSMenu*)menu {
    NSArray *lists = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentList];
    [_openRecentMenu removeAllItems];
    NSImage *image = [NSImage imageNamed:NSImageNameFolder];
    
    [lists enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *pathURL = [NSURL fileURLWithPath:obj];
        NSString *name = pathURL.lastPathComponent;
        if (name.length != 0) {
            NSMenuItem *item = [[NSMenuItem alloc] init];;
            item.title = name;
            item.action = @selector(callRecentMenuSub:);
            item.target = self;
            //            item.keyEquivalent = @"c";
            item.image = [image copy];
            item.image.size = CGSizeMake(image.size.width * 0.5, image.size.height * 0.5);
                        [self->_openRecentMenu addItem:item];
            
        }
        
    }];
}

@end
