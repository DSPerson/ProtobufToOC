//
//  UserDefault.m
//  DSpersonProtobuf
//
//  Created by DSperson on 2019/10/24.
//  Copyright © 2019 bat. All rights reserved.
//

#import "UserDefault.h"
#define kDSpersonGroup @"KB9FW2X72R.group.bat.DSpersonProtobuf"
@implementation UserDefault
+ (NSUserDefaults *)group {
    NSUserDefaults *d = [[NSUserDefaults alloc] initWithSuiteName:kDSpersonGroup];
    return d;
}

+ (void)setselectPath:(NSURL *)url {
    if (url == nil) {
        return;
    }
    NSUserDefaults *u = [UserDefault group];
    [u setURL:url forKey:@"UserDefault.selectPath"];
    [u synchronize];
}

+ (NSURL * _Nullable)getselectPath {
    return [[UserDefault group] URLForKey:@"UserDefault.selectPath"];
}
@end
