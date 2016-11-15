//
//  DPRegisterViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPRegisterViewController.h"
#import "DPLoginViewController.h"
#import "AFOAuth2Manager.h"

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

#pragma mark - 界面相关
// 导航栏取消按钮方法
- (void)backButtonTouched {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 输入值有效性判断方法

// 使用正则表达式判断用户昵称有效性
- (BOOL)isValidateNickname:(NSString *)nickname {
    // 表示匹配4-12个中英文字符
    NSString *nicknameRegex = @"^[a-zA-Z\\u4e00-\\u9fa5]{4,12}$";
    NSPredicate *nicknameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [nicknameTest evaluateWithObject:nickname];
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

// 使用正则表达式验证短信验证码为6位数字
- (BOOL)isValidateMessageIdentification:(NSString *)message
{
    // 短信验证码为6位数字
    NSString *messageRegex = @"^\\d{6}$";
    NSPredicate *messageTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", messageRegex];
    NSLog(@"短信验证码为6位数字");
    NSLog(@"%d", [messageTest evaluateWithObject:message]);
    return [messageTest evaluateWithObject:message];
    
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

// 开启短信验证码按钮倒计时效果方法
- (void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.authCodeButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
                [self.authCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.authCodeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.authCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.authCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.authCodeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

// 获取短信验证码按钮方法
- (IBAction)getMessageIdentificationButtonTouched:(id)sender {
    
    NSString *phone = self.phoneNumberField.text;
    
    if ([self isValidatePhone:phone]) { // 如果手机号码有效
        NSLog(@"手机号OK");
        // 开启短信验证码按钮倒计时效果
        [self openCountdown];
        
        // 根据API和手机号码发送获取短信验证码的网络请求
        // warning 暂时不能获取短信，约定有效的短信验证码为00+月+日:比如001114
        // 设置基础url
        #warning API is developing 参数构建方式可能变化
        NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        // 设置参数
        // 构建复杂参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        // 创建子字典
        NSMutableDictionary *verification = [NSMutableDictionary dictionary];
        verification[@"phone"] = phone;
        // 设置主字典的key的值为子字典
        params[@"verification"] = verification;
        // 发起请求
        // 参数只需要手机号码phone
        [manager POST:@"/api/v1/verifications" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"短信验证码API调用成功: %@", responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"短信验证码API调用失败: %@", error);
            // 弹框提示失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络返回错误" message:@"短信验证码API调用失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ensureAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }];

    } else { // 如果手机号码无效
        NSLog(@"手机号不对");
        // 弹框提示无效
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手机号码无效" message:@"请输入有效的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ensureAction];
        [self presentViewController:alert animated:YES completion:nil];

    };

}

// 注册按钮方法
- (IBAction)registerButtonTouched:(id)sender {
    
    // 获取界面输入框的输入信息
    NSString *phoneNumber = self.phoneNumberField.text;
    NSString *messageIdentification = self.messageIdentificationField.text;
    NSString *nickname = self.nicknameField.text;
    NSString *password = self.passwordField.text;
    NSString *repeatPassword = self.repeatPasswordField.text;
    
    // 本地验证输入信息是否合乎规范
    if ([self isValidatePhone:phoneNumber] && [self isValidatePassword:password] && [self isValidateNickname:nickname] && [password isEqualToString:repeatPassword] && [self isValidateMessageIdentification:messageIdentification]) {
        // 如果合乎规范
        NSLog(@"有效的注册信息");
        // 发起网络请求
        // 根据注册API和手机号码、有效密码、短信验证码和昵称参数 发起注册请求
         #warning API is developing
        
        // 网络注册请求返回成功结果则弹窗提示 点击确认后跳转到登录界面重新登录
        UIAlertController *success = [UIAlertController alertControllerWithTitle:@"注册成功" message:@"注册成功请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *successAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 跳转到登录界面
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[DPLoginViewController alloc] init];
        }];
        [success addAction:successAction];
        [self presentViewController:success animated:YES completion:nil];
        
        // 网络注册请求失败则弹窗提示失败
        // ...
        
    } else { // 输入的信息有不符合规范
        NSLog(@"无效的注册信息");
        // 弹窗提示注册信息有不符合规范
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册信息有误" message:@"请输入合法的注册信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ensureAction];
        [self presentViewController:alert animated:YES completion:nil];

    };
    
}

@end


















