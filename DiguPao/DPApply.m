//
//  DPApply.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/31.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPApply.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"

@implementation DPApply

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

- (NSString *)created_at {
    
    //created_at == Thu Feb 25 20:01:28 +0800 2016
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 如果是真机调试 转换这种欧美时间需要设置locale 即告诉他时间是那个地方用的
    // 中国是zh_CN
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 设置日期格式：声明字符串里面每个数字和单词的含义
    // E:周几
    // M:月份
    // d:几号
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // Z:时区比较特殊 只用一位
    // y:年
    //    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss Z";
    //DGLog(@"%@", _created_at);
    // 微博的创建日期
    NSDate *createdDate = [formatter dateFromString:_created_at];
    //DGLog(@"%@", createdDate);
    // 转成中国人熟悉的模式
    //formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    return [formatter stringFromDate:createdDate];
    // 获取当前时间
    NSDate *now =  [NSDate date];
    // 日历对象 方便比较日期之间差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获取哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期的差值
    NSDateComponents *components = [calendar components:unit fromDate:createdDate toDate:now options:0];
    
    
    // 逻辑判断
    if ([createdDate isThisYear]) {// 今年
        if ([createdDate isThisYesterday]) {// 昨天
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createdDate];
        } else if ([createdDate isThisToday]) {//今天 比较复杂
            if (components.hour >= 1) {// 大于1小时前发的
                return [NSString stringWithFormat:@"%ld小时前", (long)components.hour];
            } else if (components.minute >= 1){
                return [NSString stringWithFormat:@"%ld分钟前", (long)components.minute];
            } else {// 一分钟内
                return @"刚刚";
            }
        } else {// 其他
            formatter.dateFormat = @"MM-dd HH:mm";
            return [formatter stringFromDate:createdDate];
            
        }
    } else {// 非今年
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:createdDate];
    }
    
}

@end
