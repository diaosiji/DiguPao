//
//  DPPasswordForgetViewController.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/14.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  用户点击忘记密码后进入的修改密码界面

#import <UIKit/UIKit.h>

@interface DPPasswordForgetViewController : UIViewController
// 手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
// 短信验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *messageIdentificationField;
// 短信验证码按钮 用于实现倒计时功能
@property (weak, nonatomic) IBOutlet UIButton *authCodeButton;
// 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
// 重复密码输入框
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;

@end
