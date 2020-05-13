//
//  UserDefault.h
//  DSpersonProtobuf
//
//  Created by DSperson on 2019/10/24.
//  Copyright © 2019 bat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefault : NSObject


+ (NSUserDefaults *)group;

+ (void)setselectPath:(NSURL *)url;
+ (NSURL * _Nullable)getselectPath;
@end

NS_ASSUME_NONNULL_END
