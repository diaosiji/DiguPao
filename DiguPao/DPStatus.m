//
//  DPStatus.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  嘀咕消息数据模型

#import "DPStatus.h"
#import "MJExtension.h"

@implementation DPStatus

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"idstr" : @"id",
            };

}

@end
