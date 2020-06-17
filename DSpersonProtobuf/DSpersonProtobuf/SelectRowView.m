//
//  SelectRowView.m
//  DSpersonProtobuf
//
//  Created by DSperson on 2020/6/16.
//  Copyright © 2020 bat. All rights reserved.
//

#import "SelectRowView.h"

@implementation SelectRowView
- (void)awakeFromNib {
    [super awakeFromNib];
//    _fileLabel.stringValue = @"111";
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
- (IBAction)switchButtonAction:(NSButton *)sender {
    !_block ?: _block(sender.state);
}

@end
