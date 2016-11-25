//
//  DPEmotion.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/19.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPEmotion.h"

@implementation DPEmotion

// 从文件中解析对象时调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.chs = [aDecoder decodeObjectForKey:@"chs"];
        self.png = [aDecoder decodeObjectForKey:@"png"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

// 将对象写入文件
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.code forKey:@"code"];
}

@end
