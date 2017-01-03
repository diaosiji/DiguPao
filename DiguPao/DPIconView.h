//
//  DPIconView.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/25.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPUser;
@class DPIconView;

@protocol DPIconViewDelegate <NSObject>

@optional
// 点击了IconView
//- (void)iconView:(DPIconView)

@end

@interface DPIconView : UIImageView

@property (nonatomic, strong) DPUser *user;

@end
