//
//  OpenView.m
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import "OpenView.h"
#import <QuartzCore/QuartzCore.h>
#import "DSConst.m"
@interface OpenView ()
{
    BOOL _currentDraging;
}


@end
@implementation OpenView

- (void)awakeFromNib {
    [super awakeFromNib];
//    NSLog(@"222");
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    _currentDraging = false;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    self.wantsLayer = true;
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    // Drawing code here.
    
    if (_currentDraging) {
        //1
        NSBezierPath *path = [NSBezierPath bezierPath];
        CGFloat array[2];
        array[0] = 3.0;
        array[1] = 1.0;
        
        [path setLineDash:array count:2 phase:0];
        
        NSPoint leftBottom = NSMakePoint(0, 0);
        NSPoint rightBottom = NSMakePoint(CGRectGetWidth(dirtyRect), 0);
        NSPoint rightTop = NSMakePoint(CGRectGetWidth(dirtyRect), CGRectGetHeight(dirtyRect));
        NSPoint lefttop = NSMakePoint(0, CGRectGetHeight(dirtyRect));
        
        [path moveToPoint:leftBottom];
        
        [path lineToPoint:rightBottom];
        
        [path lineToPoint:rightTop];
        
        [path lineToPoint:lefttop];
        
        [path closePath];
        
        path.lineWidth = _currentDraging ? 1.0 : 0.0;
        
        //color
        [[NSColor redColor] set];
        
        [path stroke];
    } else {
        
    }
    
    
    
    //(2)
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
//    
//    CGContextSetLineWidth(context, 1);
//    
//    CGFloat dashArray[] = {3, 1};
//    
//    CGContextSetLineDash(context, 1, dashArray, 1);//跳过3个再画虚线，所以刚开始有6-（3-2）=5个虚点
//
//    CGContextMoveToPoint(context, <#CGFloat x#>, <#CGFloat y#>)
    
    
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
}

- (BOOL)isDirectory:(NSString *)filePath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}
//- (BOOL)isDirectory:(NSString *)filePath
//{
//    NSNumber *isDirectory;
//    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
//    [fileUrl getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
//    return isDirectory.boolValue;
//}
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
//        NSDragOperation newmask = sourceDragMask & NSDragOperationLink;
        if (sourceDragMask & NSDragOperationLink) {
            id cc = [pboard propertyListForType:NSFilenamesPboardType];
            if ([cc isKindOfClass:[NSArray class]]) {
                NSArray *dd = (NSArray *)cc;
                NSString *fi = [dd firstObject];
//                BOOL isDirectory = false;
//                BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:fi isDirectory:&isDirectory];
                if (fi && [fi pathExtension].length == 0) {
                    _currentDraging = true;
                    self.dragEX(true);
                    [self setNeedsDisplay:true];
                    return NSDragOperationLink;
                } else {
                    return NSDragOperationNone;
                }
            } else {
                return NSDragOperationNone;

            }
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        } else
            return NSDragOperationGeneric;
    } else if ([[pboard types] containsObject:NSFileContentsPboardType]) {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    [self exit];
}

- (void)exit {
    _currentDraging = false;
    self.dragEX(false);
    [self setNeedsDisplay:true];
}
- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard *pb = [sender draggingPasteboard];
    if ([[pb types] containsObject:NSFilenamesPboardType]) {
        NSArray *rs = [pb propertyListForType:NSFilenamesPboardType];
        NSString *first = [rs firstObject];
        if (first) {
            NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:kRecentList] mutableCopy];
            if (![arr containsObject:first]) {
                arr = [NSMutableArray array];
                [arr addObject:first];
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:kRecentList];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kRecentListNotificationName object:nil];
            [self exit];
            !self.dragFile ?: self.dragFile(first);
        }
    }
    return true;
}
@end
