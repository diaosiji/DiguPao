//
//  NSDate+Extension.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/28.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

// 是否为今年
- (BOOL)isThisYear;

// 是否为昨天
- (BOOL)isThisYesterday;

// 是否为今天
- (BOOL)isThisToday;

@end
