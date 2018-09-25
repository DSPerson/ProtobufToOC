//
//  AppDelegate.m
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return false;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    [NSApp activateIgnoringOtherApps:true];
    [_currentController.window makeKeyAndOrderFront:self];
    return true;
}
@end
