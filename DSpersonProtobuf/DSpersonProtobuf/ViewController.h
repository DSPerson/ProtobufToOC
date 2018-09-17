//
//  ViewController.h
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
{
    BOOL canSelect;
    BOOL checkOnce;
}
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSScrollView *scollrView;

@property (weak) IBOutlet NSButton *selectButton;

@property (weak) IBOutlet NSButton *recheckButton;

@end

