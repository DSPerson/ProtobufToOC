//
//  OpenView.h
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^kDragFilePath)(NSString *file);
typedef void(^kDragEnterAndExit)(BOOL enter);

@interface OpenView : NSView

@property (nonatomic, copy) kDragFilePath dragFile;
@property (nonatomic, copy) kDragEnterAndExit dragEX;

@end

