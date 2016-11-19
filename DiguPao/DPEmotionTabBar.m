//
//  DPEmotionTabBar.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/18.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPEmotionTabBar.h"
#import "UIView+Extension.h"
#import "DPEmotionTabBarButton.h"

@interface DPEmotionTabBar()
// 记录被选中的按钮
@property (nonatomic, weak) DPEmotionTabBarButton *selectedButton;
@end


@implementation DPEmotionTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self setupButton:@"最近" buttonType:DPEmotionTabBarButtonTypeRecent];
        [self setupButton:@"默认" buttonType:DPEmotionTabBarButtonTypeDefault];
        [self setupButton:@"Emoji" buttonType:DPEmotionTabBarButtonTypeEmoji];
        [self setupButton:@"嘀咕" buttonType:DPEmotionTabBarButtonTypeDigu];
    }
    return self;
}

// 创建一个按钮
- (DPEmotionTabBarButton *)setupButton:(NSString *)title buttonType:(DPEmotionTabBarButtonType)buttonType {
    // 创建按钮
    DPEmotionTabBarButton *button = [[DPEmotionTabBarButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = buttonType;
    [self addSubview:button];
    // 实现默认按钮初始被选中
    if (buttonType == DPEmotionTabBarButtonTypeDefault) {
        [self buttonClicked:button];
    }
    
    // 添加监听方法 实现按下后颜色改变保持
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown]; // 注意是UIControlEventTouchDown
    // 设置文字颜色在DPEmotionTabBarButton类中...
    
    
    // 设置背景图片 根据按钮的位置使用不同的背景图片 美工给了3套
    NSString *image = nil;
    NSString *imageSelected = nil;
    if (self.subviews.count == 1) { // 第一个按钮
        
        image = @"compose_emotion_table_left_normal";
        imageSelected = @"compose_emotion_table_left_selected";
        
    } else if (self.subviews.count == 4) { // 最后一个按钮
        
        image = @"compose_emotion_table_right_normal";
        imageSelected = @"compose_emotion_table_right_selected";
        
    } else {
        
        image = @"compose_emotion_table_mid_normal";
        imageSelected = @"compose_emotion_table_mid_selected";
        
    }
    
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageSelected] forState:UIControlStateDisabled]; // 注意
    
    return button;
    
}

// 排布子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger buttonCount = self.subviews.count;
    CGFloat buttonWidth = self.width / buttonCount;
    CGFloat buttonHeight = self.height;
    
    for (int i = 0; i < buttonCount; i++) {
        UIButton *button = self.subviews[i];
        button.y = 0;
        button.width = buttonWidth;
        button.height = buttonHeight;
        button.x = i * buttonWidth;
    }
    
}

// 按钮点击
- (void)buttonClicked:(DPEmotionTabBarButton *)button {
    // 循环套路
    // 点击后不能再点
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    // 通知代理 按钮被点击
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:(int)button.tag];
    }
};

@end
















