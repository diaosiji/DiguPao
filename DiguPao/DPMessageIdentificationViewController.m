//
//  DPMessageIdentificationViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPMessageIdentificationViewController.h"
#import "DPPasswordChangeViewController.h"

@interface DPMessageIdentificationViewController ()

@end

@implementation DPMessageIdentificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"短信验证";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonTouched)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonTouched {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

// 开启短信验证码按钮倒计时效果
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

// 短信验证码按钮点击方法
- (IBAction)getMessageIdentificationButtonTouched:(id)sender {
    
    NSString *phone = self.phoneNumberField.text;
    
    if ([self isValidatePhone:phone]) {
        NSLog(@"手机号OK");
        // 让按钮倒计时60秒
        [self openCountdown];
        
    } else {
        NSLog(@"手机号不对");
        UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"无效的手机号" message:@"请输入有效的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    };
    
}

- (IBAction)nextStepButtonTouched:(id)sender {
    
    NSString *phone = self.phoneNumberField.text;
    NSString *message = self.messageIdentificationField.text;
    
    if ([self isValidatePhone:phone] && ![message isEqualToString:@""]) {
        DPPasswordChangeViewController *change =[[DPPasswordChangeViewController alloc] init];
        
        [self.navigationController pushViewController:change animated:YES];
    } else {
        NSLog(@"请输入验证码");
        UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"验证码为空" message:@"请输入有效的验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    };
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
