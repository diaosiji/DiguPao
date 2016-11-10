//
//  DPRegisterViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPRegisterViewController.h"
#import "DPLoginViewController.h"

@interface DPRegisterViewController ()

@end

@implementation DPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置导航栏
    self.navigationItem.title = @"注册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonTouched)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 使用正则表达式判断手机号码格式
- (BOOL)isValidatePhone:(NSString *)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

// 判断密码长度是否在6到12
- (BOOL)isValidatePassword:(NSString *)password {
    // if-else结构
    if ([password length] >= 6 && [password length] <= 12) {
        return YES;
    } else{
        return NO;
    }
}

// 导航栏取消按钮方法
- (void)backButtonTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 获取短信验证码按钮方法
- (IBAction)getMessageIdentificationButtonTouched:(id)sender {
}

// 注册按钮方法
- (IBAction)registerButtonTouched:(id)sender {
    
    NSString *phoneNumber = self.phoneNumberField.text;
    NSString *messageIdentification = self.messageIdentificationField.text;
    NSString *nickname = self.nicknameField.text;
    NSString *password = self.passwordField.text;
    NSString *repeatPassword = self.repeatPasswordField.text;
    
    
    if ([self isValidatePhone:phoneNumber] && [self isValidatePassword:password] && ![nickname isEqualToString:@""] && [password isEqualToString:repeatPassword] && ![messageIdentification isEqualToString:@""]) {
        NSLog(@"有效的注册信息");
        // 发起网络请求
        
        // 网络请求返回成功结果则跳转到登录界面
        UIAlertController *success = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"注册成功请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        //UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *successAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 跳转到登录界面
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[DPLoginViewController alloc] init];
        }];
        
        [success addAction:successAction];
        [self presentViewController:success animated:YES completion:nil];
        
        
        
    } else {
        NSLog(@"无效的注册信息");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册信息有误" message:@"请输入合法的注册信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ensureAction];
        [self presentViewController:alert animated:YES completion:nil];

        
    };
    
    
}

@end


















