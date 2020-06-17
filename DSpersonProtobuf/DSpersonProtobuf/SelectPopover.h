//
//  SelectPopover.h
//  DSpersonProtobuf
//
//  Created by DSperson on 2020/6/16.
//  Copyright © 2020 bat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SelectViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectPopover : NSPopover <NSPopoverDelegate>
@property (nonatomic, strong) NSMutableArray <NSString *> *files;

- (instancetype)initWithFiles:(NSArray <NSString *> *)files;
@property (nonatomic, copy) kAction action;
@end

NS_ASSUME_NONNULL_END
