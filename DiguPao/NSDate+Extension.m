//
//  NSDate+Extension.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/28.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

// 是否为今年
- (BOOL)isThisYear {
    // 日历对象 方便比较日期之间差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获取哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear;
    // 获得某个日期的年月日时分秒
    NSDateComponents *createDateComponents = [calendar components:unit fromDate:self];
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    
    return createDateComponents.year == nowComponents.year;
    
}

// 是否为昨天
- (BOOL)isThisYesterday {
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:self];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
    
}

// 是否为今天
- (BOOL)isThisToday {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
    
}

@end
