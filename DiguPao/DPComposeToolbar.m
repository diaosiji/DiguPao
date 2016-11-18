//
//  DPComposeToolbar.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/17.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  

#import "DPComposeToolbar.h"
#import "UIView+Extension.h"

@interface DPComposeToolbar()
// 表情按钮
@property (nonatomic, weak) UIButton *emotionButton;
@end

@implementation DPComposeToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        // 初始化按钮
        [self setupButtonWithImage:@"compose_camerabutton_background" highlightedImage:@"compose_camerabutton_background_highlighted" type:DPComposeToolBarButtonTypeCamera];
        
        [self setupButtonWithImage:@"compose_toolbar_picture" highlightedImage:@"compose_toolbar_picture_highlighted" type:DPComposeToolBarButtonTypePicture];
        
        [self setupButtonWithImage:@"compose_mentionbutton_background" highlightedImage:@"compose_mentionbutton_background_highlighted" type:DPComposeToolBarButtonTypeMention];
        
        [self setupButtonWithImage:@"compose_trendbutton_background" highlightedImage:@"compose_trendbutton_background_highlighted" type:DPComposeToolBarButtonTypeTrend];
        
        self.emotionButton =  [self setupButtonWithImage:@"compose_emoticonbutton_background" highlightedImage:@"compose_emoticonbutton_background_highlighted" type:DPComposeToolBarButtonTypeEmotion];
    };
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)buttonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickButton:)]) {
        // tag中装的是枚举类型
        [self.delegate composeToolBar:self didClickButton:(int)button.tag];
    }
}

// 创建工具条中的按钮
- (UIButton *)setupButtonWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage type:(DPComposeToolBarButtonType)type {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    // 用tag来绑定按钮的枚举值
    button.tag = type;
    [self addSubview:button];
    
    return button;
    
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

- (void)setShowEmotionButton:(BOOL)showEmotionButton {
    _showEmotionButton = showEmotionButton;
    
    NSString *image = @"compose_keyboardbutton_background";
    NSString *highImage = @"compose_keyboardbutton_background_highlighted";
    
    if (showEmotionButton) {
        image = @"compose_emoticonbutton_background";
        highImage = @"compose_emoticonbutton_background_highlighted";
    }
    
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}



@end











