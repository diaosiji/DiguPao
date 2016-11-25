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
#import "DPEmotionButton.h"
#import "DPEmotionTool.h"

// 一页中最多3行
#define DPEmotionMaxRows 3
// 一行中最多7列
#define DPEmotionMaxCols 7
// 每一页的表情个数
#define DPEmotionPageSize ((DPEmotionMaxRows * DPEmotionMaxCols) - 1)

@interface DPEmotionPageView()
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;

@end

@implementation DPEmotionPageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        // 1.删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        
        
    }
    return self;
}

// 删除按钮方法
// 发出通知 在控制器接受通知
- (void)deleteClick {
    
    NSLog(@"deleteClick");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DPEmotionDidDeleteNotification" object:nil];
}

- (void)setEmotionsInPage:(NSArray *)emotionsInPage {
    
    _emotionsInPage = emotionsInPage;
    //NSLog(@"本页表情数:%lu", (unsigned long)emotionsInPage.count);
    //
    NSUInteger count = emotionsInPage.count;
    for (int i = 0; i < count; i++) {
        DPEmotionButton *button = [[DPEmotionButton alloc] init];
        [self addSubview:button];
        
        button.emotion = emotionsInPage[i];
        // 监听按钮点击
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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
        UIButton *button = self.subviews[i+1];

        button.width = buttonWidth;
        button.height = buttonHeight;

        button.x = inset + (i % DPEmotionMaxCols) * buttonWidth;
        button.y = inset + (i / DPEmotionMaxCols) * buttonHeight;
//        NSLog(@"按钮宽度:%f",button.width);

    }
    // 删除按钮
    self.deleteButton.width = buttonWidth;
    self.deleteButton.height = buttonHeight;
    self.deleteButton.y = self.height - buttonHeight - inset;
    self.deleteButton.x = self.width - inset - buttonWidth;
    
}

// 监听表情按钮的点击
- (void)buttonClicked:(DPEmotionButton *)button {
    // 发出通知 制定通知名的同时可以传数据（表情放到字典里）
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[@"selectedEmotion"] = button.emotion;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DPEmotionDidSelectedNotification" object:nil userInfo:userInfo];
    [self selectEmotion:button.emotion];
}

- (void)selectEmotion:(DPEmotion *)emotion {
    
    // 将这个表情存进沙盒
    [DPEmotionTool addRecentEmotion:emotion];
    
    // 发出通知 制定通知名的同时可以传数据（表情放到字典里）
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"selectedEmotion"] = emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DPEmotionDidSelectedNotification" object:nil userInfo:userInfo];
}

@end




















