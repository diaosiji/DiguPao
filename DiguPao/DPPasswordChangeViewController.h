//
//  DPPasswordChangeViewController.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPPasswordChangeViewController : UIViewController
// 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
// 重复密码输入框
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;

@end
