//
//  DPTabBar.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPTabBar.h"
#import "UIView+Extension.h"

@interface DPTabBar()
// 用一个属性来装发送按钮
@property (nonatomic, weak) UIButton *plusButton;
@end

@implementation DPTabBar

// 这里不写DGTabBar.h中的代理属性会警告
@dynamic delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // 添加发送按钮到TabBar中
        UIButton *plusButton = [[UIButton alloc] init];
        // 设置按钮背景图片不同状态
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        // 设置按钮图片不同状态
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        // 设置按钮尺寸 用到UIView的分类
        plusButton.size = plusButton.currentBackgroundImage.size;
        // 监听点击按钮的动作
        [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        // 添加按钮
        [self addSubview:plusButton];
        // 赋值给属性
        self.plusButton = plusButton;
        
    }
    
    return self;
}

// 点击发嘀咕加号按钮的方法
- (void)plusClick {
    
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置发送按钮的位置
    self.plusButton.centerX = self.width * 0.5;
    self.plusButton.centerY = self.height * 0.5;
    
    // 设置其余TabBarButton按钮的位置
    // int count = self.subviews.count 不行，还有其他东西
    // 这里的count指TabBar上含发送按钮的所有按钮的个数
    int buttonCount = 3;
    // 计算每个按钮的宽度
    CGFloat tabBarButtonWidth = self.width / buttonCount;
    // 用于计算每个按钮的位置
    CGFloat tabBarButtonIndex = 0;
    // 得到所有子视图个
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        //
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabBarButtonWidth;
            // 设置x
            child.x = tabBarButtonIndex * tabBarButtonWidth;
            // 增加索引
            tabBarButtonIndex++;
            // 这是为了越过中间的发送按钮
            if (tabBarButtonIndex == (int)(buttonCount / 2)) {
                tabBarButtonIndex++;
            }
            
        }
        
    }
    
    
}

@end
