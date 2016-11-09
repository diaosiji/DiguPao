//
//  KeyChain.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

// 将用户名和密码保存到keychain
+ (void)save:(NSString *)service data:(id)data;

// 从keychain读取用户名和密码
+ (id)load:(NSString *)service;

// 删除keychain中的用户名和密码
+ (void)delete:(NSString *)serviece;

@end
