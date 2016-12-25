//
//  DPDetailToolBar.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/21.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPDetailToolBar.h"
#import "UIView+Extension.h"

@implementation DPDetailToolBar

- (void)buttonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(detailToolBar:didClickButton:)]) {
        // tag中装的是枚举类型
        [self.delegate detailToolBar:self didClickButton:(int)button.tag];
    }
}


// 创建工具条中的按钮
- (UIButton *)setupButtonWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage type:(DPDetailToolBarButtonType)type {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    // 用tag来绑定按钮的枚举值
    button.tag = type;
    [self addSubview:button];
    
    return button;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        // 初始化按钮
        // 回应
        [self setupButtonWithImage:@"compose_camerabutton_background" highlightedImage:@"compose_camerabutton_background_highlighted" type:DPDetailToolBarButtonTypeApply];
        // 收藏
        [self setupButtonWithImage:@"compose_toolbar_picture" highlightedImage:@"compose_toolbar_picture_highlighted" type:DPDetailToolBarButtonTypeCollection];
        // 点赞
        [self setupButtonWithImage:@"compose_mentionbutton_background" highlightedImage:@"compose_mentionbutton_background_highlighted" type:DPDetailToolBarButtonTypeAltitude];
            }
        return self;
    }

// 在layoutSubviews中设置尺寸最可靠
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置所有按钮frame
    NSUInteger count = self.subviews.count;
    CGFloat buttonWidth = self.width / count;
    CGFloat buttonHeight = self.height;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = self.subviews[i];
        button.y = 0;
        button.height = buttonHeight;
        button.width = buttonWidth;
        button.x = i * buttonWidth;
    }
    
}

@end
