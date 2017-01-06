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
#import "DPNavigationController.h"
#import "DPUserController.h"

@implementation DPIconView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // 下两句代码让头像成为圆型
        // 这里设置不生效是因为这里还没有宽高等size数据？
        //self.layer.cornerRadius = self.frame.size.width / 2;
        
        // 是否按照尺寸裁剪多出边缘的图片
        self.clipsToBounds = YES;
        
        // 可以点击
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)setUser:(DPUser *)user {
    
    _user = user;
    // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //添加手势到自身
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconOnTap)];
//    [self addGestureRecognizer:gestureRecognizer];
    

}

// 点击自身发出通知
//- (void)iconOnTap {
//    NSLog(@"iconOnTap发出通知");
//    // 发出通知
//    // 发出通知 制定通知名的同时可以传数据 控制器需要对通知进行监听
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[@"iconUser"] = self.user;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DPIconViewDidSelectedNotification" object:nil userInfo:userInfo];
//    
//    
//}

@end















