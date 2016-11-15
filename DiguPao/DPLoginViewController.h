//
//  DPLoginViewController.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  用户登录界面

#import <UIKit/UIKit.h>

@interface DPLoginViewController : UIViewController
// 账户名输入框
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
// 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
