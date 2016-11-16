//
//  DPLoginViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPLoginViewController.h"
#import "DPTabBarController.h"
#import "KeyChain.h"
#import "DPRegisterViewController.h"
#import "DPPasswordForgetViewController.h"

#import <AFNetworking/AFNetworking.h>
#import "AFOAuth2Manager.h"

@interface DPLoginViewController ()

@end

// 用作字典中键值
NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
NSString * const KEY_USERNAME = @"com.company.app.username";
NSString * const KEY_PASSWORD = @"com.company.app.password";


@implementation DPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showUsernameAndPasswordFromKeyChain];
    
    // 让用户名输入框只显示手机键盘
    self.userNameField.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击空白键盘消失的方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - 界面初始化时调用方法

// 页面启动时加载KeyChain中已有的用户名和密码
- (void)showUsernameAndPasswordFromKeyChain {
    
    // 调试：从keychain中读取用户名和密码
    NSMutableDictionary *readUsernamePassword = (NSMutableDictionary *)[KeyChain load:KEY_USERNAME_PASSWORD];
    NSString *userNameStr = [readUsernamePassword objectForKey:KEY_USERNAME];
    NSString *passwordStr = [readUsernamePassword objectForKey:KEY_PASSWORD];
    // 调试：打印
    //    NSLog(@"username = %@", userNameStr);
    //    NSLog(@"password = %@", passwordStr);
    
    // 判断字符串是否不为空
    if (![userNameStr isEqualToString:@""] && ![passwordStr isEqualToString:@""]) {
        // 将用户名和密码写入到输入框中
        self.userNameField.text = userNameStr;
        self.passwordField.text =passwordStr;
    }
    
}


#pragma mark - 输入值有效性判断方法

// 使用正则表达式验证邮箱地址
- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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

#pragma mark - 按钮点击方法

// 登录按钮方法
- (IBAction)loginButtonTouched:(id)sender {
    NSString *userNameStr = self.userNameField.text;
    NSString *userPasswordStr = self.passwordField.text;
    
    
    // 如果用户名和密码有效
    // 则发起网络请求
    // 如果网络请求返回成功 则说明用户名和密码正确 可以保存用户名和密码到KeyChain
    // 然后跳转到根视图控制器
    if (([self isValidatePhone:userNameStr] || [self isValidateEmail:userNameStr]) && [self isValidatePassword:userPasswordStr]) {
        NSLog(@"用户名:%@ 密码:%@", userNameStr, userPasswordStr);
        NSLog(@"有效的用户名和密码");
        
        // 发起网络请求
        // 利用AFOAuth2Manager库来进行OAuth2认证
        // 根据clientID、clientSecret、api、用户名和密码来获取包含accessToken的credential对象
        NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
        NSString *kClientID = @"a5e72efb5d4d1bca2691a4d9d09d07b5c59745bd4f412f1602f871b197d81e69";
        NSString *kClientSecret = @"945dd833f04111f2db822cd5ffd22fb165c181dcd5d1677552490831b0ff8228";
        
        AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL clientID:kClientID secret:kClientSecret];
        
        // 测试用户名15575112289 密码11111111111
        [OAuth2Manager authenticateUsingOAuthWithURLString:@"/oauth/token" username:userNameStr password:userPasswordStr scope:nil success:^(AFOAuthCredential * _Nonnull credential) {
            // 网络请求成功
            NSLog(@"Login界面网络请求成功返回credential:%@", credential);
            
            // 把包含Token的凭证对象存储 注意这里的Identifier要和AppDelegate中load的一致
            [AFOAuthCredential storeCredential:credential withIdentifier:@"OAuthCredential"];
            
            // 如果网络返回成功说明用户名密码正确就应该保存用户名和密码到KeyChain
            // 创建可变字典用于存储用户名和密码
            NSMutableDictionary *userNamePasswordKVPairs = [NSMutableDictionary dictionary];
            [userNamePasswordKVPairs setObject:userNameStr forKey:KEY_USERNAME];
            [userNamePasswordKVPairs setObject:userPasswordStr forKey:KEY_PASSWORD];
            // 将包含用户名和密码的字典作为参数写入keychain
            [KeyChain save:KEY_USERNAME_PASSWORD data:userNamePasswordKVPairs];
            
            // 最后跳转到根TabBar控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[DPTabBarController alloc] init];
            // 可以在根TabBar控制器的viewDidLoad中读取credential试试
            
            
        } failure:^(NSError * _Nonnull error) {
            
            // 网络请求失败就弹窗显示登录失败
            NSLog(@"results: %@", error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"服务器返回登录失败信息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ensureAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
        
        
    } else { // 如果输入的用户名和密码本地判断不符合规范
        // 提示输入的用户名或者密码错误
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无效的用户名或密码" message:@"您输入的用户名或密码不符合基本规则" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ensureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 注册按钮方法
- (IBAction)registerButtonTouched:(id)sender {
    
    DPRegisterViewController * reg = [[DPRegisterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:reg];
    
    [self presentViewController:nav animated:YES completion:nil];

}

// 删除Keychain中保存的用户名和密码按钮方法
- (IBAction)deletePasswordButtonTouched:(id)sender {
    // 从keychain中读取用户名和密码
    NSMutableDictionary *readUsernamePassword = (NSMutableDictionary *)[KeyChain load:KEY_USERNAME_PASSWORD];
    NSString *userName = [readUsernamePassword objectForKey:KEY_USERNAME];
    NSString *password = [readUsernamePassword objectForKey:KEY_PASSWORD];
    NSLog(@"username = %@", userName);
    NSLog(@"password = %@", password);
    
    // 将用户名和密码从keychain中删除
    [KeyChain delete:KEY_USERNAME_PASSWORD];
    
    // 将文本输入框中的文字清空
    self.userNameField.text = @"";
    self.passwordField.text = @"";
}

// 忘记密码按钮方法
- (IBAction)passwordForgetButtonTouched:(id)sender {
    
    DPPasswordForgetViewController *identification = [[DPPasswordForgetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:identification];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}


@end
