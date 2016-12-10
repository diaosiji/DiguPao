//
//  DPDetailHeader.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPDetailHeader.h"

@implementation DPDetailHeader

+ (instancetype)header
{
    return [[NSBundle mainBundle] loadNibNamed:@"DPDetailHeader" owner:nil options:nil][0];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
