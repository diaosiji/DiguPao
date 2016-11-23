//
//  DPEmotionTool.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/23.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DPEmotion;

@interface DPEmotionTool : NSObject

+ (void)addRecentEmotion:(DPEmotion *)emotion;
+ (NSArray *)recentEmotions;


@end
