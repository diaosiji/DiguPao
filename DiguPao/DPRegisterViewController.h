//
//  DPRegisterViewController.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  用户注册界面

#import <UIKit/UIKit.h>

@interface DPRegisterViewController : UIViewController
// 手机号输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
// 验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *messageIdentificationField;
// 昵称输入框
@property (weak, nonatomic) IBOutlet UITextField *nicknameField;
// 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
// 重复密码输入框
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;
// 短信验证码按钮的属性 用于实现倒计时
@property (weak, nonatomic) IBOutlet UIButton *authCodeButton;

@end
