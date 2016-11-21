//
//  DPEmotionAttachment.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/21.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPEmotionAttachment.h"
#import "DPEmotion.h"

@implementation DPEmotionAttachment

- (void)setEmotion:(DPEmotion *)emotion {

    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
    
}


@end
