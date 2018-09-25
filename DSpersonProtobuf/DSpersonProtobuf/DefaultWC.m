//
//  DefaultWC.m
//  DSpersonProtobuf
//
//  Created by 帅杜 on 2018/9/25.
//  Copyright © 2018年 bat. All rights reserved.
//

#import "DefaultWC.h"
#import "AppDelegate.h"
@interface DefaultWC ()

@end

@implementation DefaultWC

- (void)windowDidLoad {
    [super windowDidLoad];
    AppDelegate *d = (AppDelegate *)NSApp.delegate;
    d.currentController = self;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
