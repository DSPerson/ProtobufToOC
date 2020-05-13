//
//  ViewController.m
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import "ViewController.h"
#import "STPrivilegedTask.h"
#import "OpenView.h"
#import "DSConst.m"
#import "UserDefault.h"

@interface ViewController ()

@property (nonatomic, strong) STPrivilegedTask *taskS;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectIndex = @"objc";
    __weak ViewController *wealSelf = self;
    self.openView.dragFile = ^(NSString *file) {
        [wealSelf createShell:file];
    };
    self.openView.dragEX = ^(BOOL enter) {
        wealSelf.dragEnterMaskView.hidden = !enter;
    };
    self.dragEnterMaskView.wantsLayer = true;
    self.dragEnterMaskView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    // Do any additional setup after loading the view.
    [self check];
}


- (NSString *)cmd:(NSString *)cmd
{
    // 初始化并设置shell路径
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    // -c 用来执行string-commands（命令字符串），也就说不管后面的字符串里是什么都会被当做shellcode来执行
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    
    // 新建输出管道作为Task的输出
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    // 开始task
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    // 获取运行结果
    NSData *data = [file readDataToEndOfFile];
    return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}
- (IBAction)changgePopButton:(NSPopUpButton *)sender {
    
    NSArray *current = @[@"objc", @"java", @"cpp"];
    _selectIndex = current[sender.indexOfSelectedItem];
}
- (void)check {
    BOOL check_protoc = [[[NSUserDefaults standardUserDefaults] objectForKey:@"check_protoc"] boolValue];
    if (check_protoc) {
        
    } else {
        NSMutableString *desc = [@"第一步:\n检查是否安装Protobuf;\n" mutableCopy];
        self.textView.string = desc;
        
        __block NSString *protobufVaild = @"0";
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create("com.dsperson.protobuf", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_group_async(group, queue, ^{
            NSTask *task = [[NSTask alloc] init];
            task.launchPath = @"/bin/bash";
            task.arguments = @[@"cc.sh"];
            task.currentDirectoryPath = [[NSBundle mainBundle] resourcePath];
            
            NSPipe *outputPipe = [NSPipe pipe];
            [task setStandardOutput:outputPipe];
            [task setStandardError:outputPipe];
            NSFileHandle *readHandle = [outputPipe fileHandleForReading];
            
            [task launch];
            [task waitUntilExit];
            
            NSData *outputData = [readHandle readDataToEndOfFile];
            protobufVaild = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
            NSLog(@"protbuf 安装状态%@", protobufVaild);
        });
        
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([protobufVaild integerValue] == 0) {
                    NSAlert *alert = [[NSAlert alloc] init];
                    alert.messageText = @"检测到未安装 Protobuf";
                    alert.informativeText = @"是否自动安装?";
                    
                    [alert addButtonWithTitle:@"确认"];
                    [alert addButtonWithTitle:@"取消"];
                    
                    
                    NSButton *cancel = [[NSButton alloc] init];
                    cancel.title = @"取消";
                    __weak ViewController *weakSelf = self;
                    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                        __strong ViewController *strongSelf = weakSelf;
                        if (returnCode == 1000) {
                            [strongSelf install:@"installProtobuf.sh"];
                            
                            return;
                            NSString *cc = [NSString stringWithFormat:@"/usr/local/bin/brew install protobuf"];
                            STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
                            [privilegedTask setLaunchPath:@"/bin/bash"];///bin/bash
                            [privilegedTask setArguments:@[@"-c", cc]];
                            [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
                            OSStatus err = [privilegedTask launch];
                            if (err != errAuthorizationSuccess) {
                                if (err == errAuthorizationCanceled) {
                                    NSLog(@"User cancelled");
                                    return;
                                }  else {
                                    NSLog(@"Something went wrong: %d", (int)err);
                                }
                            }
                            [privilegedTask waitUntilExit];
                            NSFileHandle *handle = [privilegedTask outputFileHandle];
                            NSData *outData = [handle readDataToEndOfFile];
                            NSString * rs = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
                            
                            if ([rs isEqualToString:@"Updating Homebrew..."]) {
                                self.textView.string = @"此处非常慢 最好使用 VPN";
                            } else {
                                self.textView.string = rs;
                                //                            [self.textView scrollPoint:CGPointMake(0, CGRectGetMaxX(self.textView.frame))];
                                [self.textView scrollToEndOfDocument:nil];
                                self.selectButton.enabled = true;
                                self->canSelect = true;
                            }
                        } else if(returnCode == 1001) {
                            
                        }
                    }];
                    
                }else {
                    self->canSelect = true;
                    self.selectButton.enabled = true;
                    self.textView.string = @"已安装Protobuf\n 请选择文件夹";
                }
                
            });
        });
        
        
        
        //            NSLog(@"%d", [outputString intValue]);
        //            return;
        //            STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
        //            [privilegedTask setLaunchPath:@"/bin/bash"];
        //            [privilegedTask setArguments:@[@"cc.sh"]];
        //            [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
        //            OSStatus err = [privilegedTask launch];
        //            if (err != errAuthorizationSuccess) {
        //                if (err == errAuthorizationCanceled) {
        //                    NSLog(@"User cancelled");
        //                    self->checkOnce = false;
        //                    self.recheckButton.hidden = false;
        //                    self.recheckButton.enabled = true;
        //                    return;
        //                }  else {
        //                    NSLog(@"Something went wrong: %d", (int)err);
        //                    self->checkOnce = false;
        //                    self.recheckButton.enabled = true;
        //                }
        //            } else {
        //                //                [self.view.window orderFront:self];
        //                [NSApp activateIgnoringOtherApps:true];
        //            }
        //            self.recheckButton.enabled = true;
        //            self.recheckButton.hidden = true;
        //            NSLog(@"--->开始执行检查1");
        //            [privilegedTask waitUntilExit];
        //            NSLog(@"--->开始执行检查2");
        //            NSFileHandle *handle = [privilegedTask outputFileHandle];
        //            NSLog(@"--->开始执行检查3");
        //            NSData *outData = [handle readDataToEndOfFile];
        //            NSString * rs = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
        
        
        return;
    }
}

- (void)install:(NSString *)agruments {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.dsperson.install", DISPATCH_QUEUE_CONCURRENT);
    __block NSString *rs = @"";
    dispatch_group_async(group, queue, ^{
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/bin/bash";
        task.arguments = @[agruments];
        task.currentDirectoryPath = [[NSBundle mainBundle] resourcePath];
        
        NSPipe *outputPipe = [NSPipe pipe];
        [task setStandardOutput:outputPipe];
        [task setStandardError:outputPipe];
        NSFileHandle *readHandle = [outputPipe fileHandleForReading];
        
        [task launch];
        [task waitUntilExit];
        
        NSData *outputData = [readHandle readDataToEndOfFile];
        rs = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", rs);
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"%@", rs);
    });
    
}
- (IBAction)recheckAction:(id)sender {
    self.recheckButton.enabled = false;
    [self check];
    
}

- (BOOL)checkBrew {
    STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
    [privilegedTask setLaunchPath:@"/bin/bash"];
    [privilegedTask setArguments:@[
        @"brewc.sh"]];
    [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    OSStatus err = [privilegedTask launch];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            NSLog(@"User cancelled");
            return false;
        }  else {
            NSLog(@"Something went wrong: %d", (int)err);
            // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
        }
    }
    [privilegedTask waitUntilExit];
    NSFileHandle *handle = [privilegedTask outputFileHandle];
    NSData *outData = [handle readDataToEndOfFile];
    NSString * rs = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    if ([rs integerValue] == 0) {
        //        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
        [privilegedTask setLaunchPath:@"/bin/bash"];
        [privilegedTask setArguments:@[
            @"-c", @"/usr/bin/ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'"]];
        [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
        OSStatus err = [privilegedTask launch];
        if (err != errAuthorizationSuccess) {
            if (err == errAuthorizationCanceled) {
                NSLog(@"User cancelled");
                return false;
            }  else {
                NSLog(@"Something went wrong: %d", (int)err);
                // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
            }
        }
        [privilegedTask waitUntilExit];
        NSFileHandle *handle = [privilegedTask outputFileHandle];
        NSData *outData = [handle readDataToEndOfFile];
        NSString * rs = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
        self.textView.string = @"正在安装 Home brew";
        
        return false;
    }
    return true;
}


- (void)brewProtobuf {
    
}
- (IBAction)openWorkSpace:(id)sender {
    if (!canSelect) {
        return;
    }
    [self openWorkSpaceForce:false];
}

- (void)openWorkSpaceForce:(BOOL)force {
    NSOpenPanel *open = [NSOpenPanel openPanel];
    NSArray *lists = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentList];
    NSString *l = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    if (lists.count != 0 && !force) {
        l = lists.firstObject;
    }
    //    l = @"/Users/shuaidu/BAT_文档/protobuf";
    [open setDirectoryURL:[NSURL URLWithString:l]];
    open.allowsMultipleSelection = false;
    open.canChooseFiles = false;
    open.canChooseDirectories = true;
    open.allowedFileTypes = @[@"doc"];
    NSModalResponse rs = [open runModal];
    if (rs == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createShell:open.URLs.firstObject.path];
        });
    }
}


- (void)createShell:(NSString *)filePath {
    
    NSMutableString *string = [NSMutableString string];
    ///在界面上创建一个新的文件夹
    NSError *error;
    NSString *needDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop/Proto_OBJC"];
    [[NSFileManager defaultManager] removeItemAtPath:needDirectory error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:needDirectory withIntermediateDirectories:false attributes:nil error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    [string appendFormat:@"#!/bin/bash"];
    [string appendFormat:@"\n"];
    [string appendFormat:@"%@ --proto_path=%@ --%@_out=%@",@"/usr/local/bin/protoc", filePath, _selectIndex, needDirectory];
    //     [string appendFormat:@" --version"];
    
    //获取文件夹里面内容
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    if (arr.count == 0) {
        return;
    }
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:arr.count];
    [arr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasSuffix:@"proto"] && [[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingPathComponent:obj]  isDirectory:false]) {
            [names addObject:obj];
        }
    }];
    if (names.count == 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"未找到Protobuf文件";
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        return;
    }
    [names enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@" %@/%@",filePath, obj];
    }];
    [string appendFormat:@"\n"];
    [string appendFormat:@"exit 0"];
    //    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //    [fileHandle writeData:data];
    
    STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
    [privilegedTask setLaunchPath:@"/bin/bash"];
    [privilegedTask setArguments:@[@"-c",
                                   string]];
    [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    OSStatus err = [privilegedTask launch];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            NSLog(@"User cancelled");
            return;
        }  else {
            NSLog(@"Something went wrong: %d", (int)err);
            // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
        }
    }
    NSLog(@"--->开始执行检查4");
    [privilegedTask waitUntilExit];
    NSLog(@"--->开始执行检查5");
    NSFileHandle *handle = [privilegedTask outputFileHandle];
    NSLog(@"--->开始执行检查6");
    NSData *outData = [handle readDataToEndOfFile];
    NSString * rs = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    if (rs.length == 0) {
        rs = @"成功";
        rs = [rs stringByAppendingString:[NSString stringWithFormat:@"生成路径 --> \n%@", needDirectory]];
        STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
        [privilegedTask setLaunchPath:@"/bin/bash"];
        [privilegedTask setArguments:@[@"-c", @"cd ~/Desktop; open Proto_OBJC"]];
        [privilegedTask launch];
        
    } else {
        rs = @"失败";
    }
    self.textView.string = rs;
    NSString *cc = @"objc_objc";
    NSUserDefaults *defalut = [NSUserDefaults standardUserDefaults];
    if (![defalut boolForKey:cc] && [_selectIndex isEqualToString: @"objc"]) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"OC 是 MRC文件, 如果工程为ARC工程, 则需要在 'Build Phases -> Compile Sources' 添加 '-fno-objc-arc'";
        alert.alertStyle = NSAlertStyleWarning;
        
        
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"不再提示"];
        
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == 1000) {
                
            } else if (returnCode == 1001) {
                [defalut setBool:true forKey:cc];
                [defalut synchronize];
            }
        }];
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


@end
