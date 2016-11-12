//
//  DPDropdownMenu.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/12.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPDropdownMenu;

@protocol DPDropdownMenuDelegate <NSObject>

@optional
// 通知外界自己被销毁
- (void)dropdownMenuDidDismiss:(DPDropdownMenu *)menu;
// 通知外界自己已经显示
- (void)dropdownMenuDidShow:(DPDropdownMenu *)menu;
@end

@interface DPDropdownMenu : UIView

@property (nonatomic, weak)id <DPDropdownMenuDelegate> delegate;

+ (instancetype)menu;

- (void)showFrom:(UIView *)from;

- (void)dismiss;

// 内容
@property (nonatomic, strong) UIView *content;

// 内容控制器
@property (nonatomic, strong) UIViewController *contentController;

@end
