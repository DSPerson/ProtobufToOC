//
//  SelectViewController.h
//  DSpersonProtobuf
//
//  Created by DSperson on 2020/6/16.
//  Copyright © 2020 bat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^kAction)(void);
@interface SelectViewController : NSViewController
@property (nonatomic, strong) NSMutableArray <NSString *>* files;
@property (nonatomic, copy) kAction action;
@end

NS_ASSUME_NONNULL_END
