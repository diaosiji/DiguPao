//
//  DPEmotionTabBarButton.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/19.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  为了实现高亮时没有颜色改变的自定义Button

#import "DPEmotionTabBarButton.h"

@implementation DPEmotionTabBarButton

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
        // 设置按钮文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted {
    /*所做的一切事情都没有了*/
}



@end
