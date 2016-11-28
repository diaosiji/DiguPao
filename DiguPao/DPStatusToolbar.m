//
//  DPStatusToolbar.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/28.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPStatusToolbar.h"
#import "UIView+Extension.h"

@interface DPStatusToolbar()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;
/** 里面存放所有的分割线 */
@property (nonatomic, strong) NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *repostButton;
@property (nonatomic, weak) UIButton *commentButton;
@property (nonatomic, weak) UIButton *attitudeButton;

@end

@implementation DPStatusToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        self.buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}
// 添加分割线
- (void)setupDivider {
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    [self.dividers addObject:divider];
    
}

// 初始化一个按钮
- (UIButton *)setupButton:(NSString *)title icon:(NSString *)icon {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.buttons addObject:button];
    [self addSubview:button];
    
    return button;
}


+ (instancetype)toolbar {
    
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        // 设置颜色
        //self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        
        // 初始化按钮
        self.repostButton =  [self setupButton:@"转发" icon:@"timeline_icon_retweet"];
        self.commentButton =  [self setupButton:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeButton =  [self setupButton:@"赞" icon:@"timeline_icon_unlike"];
        
        // 添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置按钮的frame
    int buttonCount = (int)self.buttons.count;
    CGFloat buttonWidth = self.width / buttonCount;
    CGFloat buttonHeight = self.height;
    for (int i = 0; i < buttonCount; i++) {
        UIButton *button = self.buttons[i];
        // 不让按钮能点击 误导用户
        button.enabled = NO;
        button.x = buttonWidth * i;
        button.y = 0;
        button.width = buttonWidth;
        button.height = buttonHeight;
        
    }
    
    // 设置分割线的frame
    int dividerCount = (int)self.dividers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = buttonHeight;
        divider.x = (i + 1) * buttonWidth;
        divider.y = 0;
    }
}


@end

















