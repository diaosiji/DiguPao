//
//  DPMessageIdentificationViewController.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPMessageIdentificationViewController : UIViewController
// 手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
// 短信验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *messageIdentificationField;

@end
