//
//  DPComposeToolbar.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/17.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  

#import "DPComposeToolbar.h"

@implementation DPComposeToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
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

@end
