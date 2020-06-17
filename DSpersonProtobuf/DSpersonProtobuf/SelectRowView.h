//
//  SelectRowView.h
//  DSpersonProtobuf
//
//  Created by DSperson on 2020/6/16.
//  Copyright © 2020 bat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^kSelectSwitchAction)(BOOL s);
@interface SelectRowView : NSTableRowView

@property (weak) IBOutlet NSButton *switchButton;
@property (weak) IBOutlet NSTextField *fileLabel;
@property (nonatomic, copy) kSelectSwitchAction block;
@end

NS_ASSUME_NONNULL_END
