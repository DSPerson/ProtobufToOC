//
//  SelectPopover.m
//  DSpersonProtobuf
//
//  Created by DSperson on 2020/6/16.
//  Copyright © 2020 bat. All rights reserved.
//

#import "SelectPopover.h"

@implementation SelectPopover

- (instancetype)initWithFiles:(NSArray <NSString *> *)files {
    if (self = [super init]) {
        _files = [files mutableCopy];
        SelectViewController *vc = [SelectViewController new];
        vc.files = _files;
        __weak SelectPopover *weakSelf = self;
        vc.action = ^{
            weakSelf.files = vc.files;
            !weakSelf.action ?: weakSelf.action();
        };
        self.contentViewController = vc;
        self.delegate = self;
//        self.behavior = 1;
        
    }
    return self;
}

- (BOOL)popoverShouldClose:(NSPopover *)popover {
    return true;
}
@end
