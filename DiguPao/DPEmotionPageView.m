//
//  DPEmotionPageView.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPEmotionPageView.h"
#import "UIView+Extension.h"
#import "DPEmotion.h"
#import "NSString+Emoji.h"

// 一页中最多3行
#define DPEmotionMaxRows 3
// 一行中最多7列
#define DPEmotionMaxCols 7
// 每一页的表情个数
#define DPEmotionPageSize ((DPEmotionMaxRows * DPEmotionMaxCols) - 1)

@implementation DPEmotionPageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    }
    return self;
}

- (void)setEmotionsInPage:(NSArray *)emotionsInPage {
    
    _emotionsInPage = emotionsInPage;
    //NSLog(@"本页表情数:%lu", (unsigned long)emotionsInPage.count);
    //
    NSUInteger count = emotionsInPage.count;
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] init];
//        button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        DPEmotion *emotion = emotionsInPage[i];
        
        if (emotion.png) { // 有图片
            // NSLog(@"图片名:%@",emotion.png);
            [button setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        } else if (emotion.code) { // 是emoji表情
            // 设置emoji
            [button setTitle:emotion.code.emoji forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:32];
        }

        [self addSubview:button];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 四周内边距
    CGFloat inset = 10;
    NSUInteger count = self.emotionsInPage.count;
    CGFloat buttonWidth = (self.width - 2 * inset) / DPEmotionMaxCols;
    CGFloat buttonHeight = (self.height - 2 * inset) / DPEmotionMaxRows;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = self.subviews[i];

        button.width = buttonWidth;
        button.height = buttonHeight;

        button.x = inset + (i % DPEmotionMaxCols) * buttonWidth;
        button.y = inset + (i / DPEmotionMaxCols) * buttonHeight;
        NSLog(@"按钮宽度:%f",button.width);

    }
    
}

@end




















