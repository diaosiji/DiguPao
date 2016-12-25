//
//  DPIconView.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/25.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPIconView.h"
#import "DPUser.h"
#import "UIImageView+WebCache.h"

@implementation DPIconView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // 下两句代码让头像成为圆型
        // 这里设置不生效是因为这里还没有宽高等size数据？
        //self.layer.cornerRadius = self.frame.size.width / 2;
        
        // 是否按照尺寸裁剪多出边缘的图片
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setUser:(DPUser *)user {
    
    _user = user;
    // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
}

@end















