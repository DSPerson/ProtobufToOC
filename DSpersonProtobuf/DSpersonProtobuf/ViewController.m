//
//  ViewController.m
//  DSpersonProtobuf
//
//  Created by ds on 2018/9/10.
//  Copyright © 2018年 bat. All rights reserved.
//

#import "ViewController.h"
#import "STPrivilegedTask.h"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
- (void)check {
    BOOL check_protoc = [[[NSUserDefaults standardUserDefaults] objectForKey:@"check_protoc"] boolValue];
    if (check_protoc) {
        
    } else {
        NSMutableString *desc = [@"第一步:\n检查是否安装Protobuf;\n" mutableCopy];
        self.textView.string = desc;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
            [privilegedTask setLaunchPath:@"/bin/bash"];
            [privilegedTask setArguments:@[@"cc.sh"]];
            [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
            OSStatus err = [privilegedTask launch];
            if (err != errAuthorizationSuccess) {
                if (err == errAuthorizationCanceled) {
                    NSLog(@"User cancelled");
                    self->checkOnce = false;
                    self.recheckButton.hidden = false;
                    self.recheckButton.enabled = true;
                    return;
                }  else {
                    NSLog(@"Something went wrong: %d", (int)err);
                    // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
                    self->checkOnce = false;
                    self.recheckButton.enabled = true;
                }
            }
            self.recheckButton.enabled = true;
            self.recheckButton.hidden = true;
            [privilegedTask waitUntilExit];
            NSFileHandle *handle = [privilegedTask outputFileHandle];
            NSData *outData = [handle readDataToEndOfFile];
            NSString * rs = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
            if ([rs integerValue] == 1) {
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = @"检测到未安装 Protobuf";
                alert.informativeText = @"是否自动安装?";
                
                [alert addButtonWithTitle:@"确认"];
                [alert addButtonWithTitle:@"取消"];
                
                
                NSButton *cancel = [[NSButton alloc] init];
                cancel.title = @"取消";
                
                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                    if (returnCode == 1000) {
                        
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
                                // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
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
                        
                        //                        NSURL *url = [NSURL fileURLWithPath:[[NSWorkspace sharedWorkspace] fullPathForApplication:@"Terminal"]];
                        //                        NSError *error = nil;
                        //                        [[NSWorkspace sharedWorkspace] launchApplicationAtURL:url options:NSWorkspaceLaunchAndPrint configuration:@{NSWorkspaceLaunchConfigurationArguments : @[@"Terminal://brew install protobuf;", @"exit;"]} error:&error];
                        //                        NSLog(@"%@", error);
                    } else if(returnCode == 1001) {
                        
                    }
                }];
                
            }else {
                self->canSelect = true;
                self.selectButton.enabled = true;
                self.textView.string = @"已安装Protobuf\n 请选择文件夹";
            }
        });
        
        return;
    }
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
    //    [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:@"~/Documents"];
    NSOpenPanel *open = [NSOpenPanel openPanel];
    
    [open  setDirectoryURL:[NSURL URLWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"]]];
    open.allowsMultipleSelection = false;
    open.canChooseFiles = false;
    open.canChooseDirectories = true;
    NSModalResponse rs = [open runModal];
    NSLog(@"%ld", (long)rs);
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
    [string appendFormat:@"%@ --proto_path=%@ --objc_out=%@",@"/usr/local/bin/protoc", filePath, needDirectory];
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
    [privilegedTask waitUntilExit];
    
    NSFileHandle *handle = [privilegedTask outputFileHandle];
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
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


@end