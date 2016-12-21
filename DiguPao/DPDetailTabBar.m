//
//  DPDetailTabBar.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/15.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPDetailTabBar.h"
#import "UIView+Extension.h"

@interface DPDetailTabBar()
/** UIButton 回应按钮 */
@property (nonatomic, weak) UIButton *applyButton;
/** UIButton 收藏按钮 */
@property (nonatomic, weak) UIButton *collectionButton;
/** UIButton 点赞按钮 */
@property (nonatomic, weak) UIButton *attitudeButton;

@end

@implementation DPDetailTabBar
// 这里不写.h中的代理属性会警告
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
        // 1.添加回应按钮到TabBar中
        UIButton *applyButton = [[UIButton alloc] init];
        // 设置按钮图片不同状态
        [applyButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [applyButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [applyButton setTitle:@"回应" forState:UIControlStateNormal];
        // 设置按钮尺寸 用到UIView的分类
        applyButton.size = applyButton.currentBackgroundImage.size;
        // 监听点击按钮的动作
        [applyButton addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
        // 添加按钮
        [self addSubview:applyButton];
        // 赋值给属性
        self.applyButton = applyButton;
        
        // 2.添加收藏按钮到TabBar中
        UIButton *collectionButton = [[UIButton alloc] init];
        // 设置按钮图片不同状态
        [collectionButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [collectionButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        // 设置按钮尺寸 用到UIView的分类
        collectionButton.size = collectionButton.currentBackgroundImage.size;
        // 监听点击按钮的动作
        [collectionButton addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
        // 添加按钮
        [self addSubview:collectionButton];
        // 赋值给属性
        self.collectionButton = collectionButton;
        
        // 3.添加点赞按钮到TabBar中
        UIButton *attitudeButton = [[UIButton alloc] init];
        // 设置按钮图片不同状态
        [attitudeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [attitudeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [attitudeButton setTitle:@"点赞" forState:UIControlStateNormal];
        // 设置按钮尺寸 用到UIView的分类
        attitudeButton.size = attitudeButton.currentBackgroundImage.size;
        // 监听点击按钮的动作
        [attitudeButton addTarget:self action:@selector(attitudeClick) forControlEvents:UIControlEventTouchUpInside];
        // 添加按钮
        [self addSubview:attitudeButton];
        // 赋值给属性
        self.attitudeButton = attitudeButton;

    }
    
    return self;
}

// 点击回应按钮方法
- (void)applyClick {
    
    if ([self.delegate respondsToSelector:@selector(detialTabBarDidClickApplyButton:)]) {
        [self.delegate detialTabBarDidClickApplyButton:self];
    }
}

// 收藏按钮方法
- (void)collectionClick {
    
    if ([self.delegate respondsToSelector:@selector(detialTabBarDidClickCollectionButton:)]) {
        [self.delegate detialTabBarDidClickApplyButton:self];
    }
}

// 点赞按钮方法
- (void)attitudeClick {
    
    if ([self.delegate respondsToSelector:@selector(detialTabBarDidClickAttitudeButton:)]) {
        [self.delegate detialTabBarDidClickApplyButton:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
            
        }
        
    }


}

@end





















