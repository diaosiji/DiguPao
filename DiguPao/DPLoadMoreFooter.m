//
//  DPLoadMoreFooter.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/27.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPLoadMoreFooter.h"

@implementation DPLoadMoreFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)footer {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"DPLoadMoreFooter" owner:nil options:nil] lastObject];
}

@end
