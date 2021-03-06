//
//  DPEmotionTool.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/23.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPEmotionTool.h"
#import "DPEmotion.h"

// 最近表情的存储路径
#define HWRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

@implementation DPEmotionTool

+ (void)addRecentEmotion:(DPEmotion *)emotion
{
    // 加载沙盒中的表情数据
    NSMutableArray *emotions = (NSMutableArray *)[self recentEmotions];
    if (emotions == nil) {
        emotions = [NSMutableArray array];
    }
    
    // 将表情放到数组的最前面
    [emotions insertObject:emotion atIndex:0];
    
    // 将所有的表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:emotions toFile:HWRecentEmotionsPath];
}

/**
 *  返回装着HWEmotion模型的数组
 */
+ (NSArray *)recentEmotions
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:HWRecentEmotionsPath];
}


@end
