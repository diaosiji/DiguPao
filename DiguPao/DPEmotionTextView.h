//
//  DPEmotionTextView.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  继承自DPTextViw 增加可以输入表情的功能

#import "DPTextViw.h"

@class DPEmotion;

@interface DPEmotionTextView : DPTextViw

- (void)insertEmotion:(DPEmotion *)emotion;

@end
