//
//  OpenView.m
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import "OpenView.h"

@implementation OpenView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    self.wantsLayer = true;
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    // Drawing code here.
}

@end
