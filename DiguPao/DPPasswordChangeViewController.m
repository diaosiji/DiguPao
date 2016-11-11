//
//  DPPasswordChangeViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPPasswordChangeViewController.h"
#import "DPLoginViewController.h"

@interface DPPasswordChangeViewController ()

@end

@implementation DPPasswordChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonTouched)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonTouched {
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)changeConfirmButtonTouched:(id)sender {
    
    NSString *password = self.passwordField.text;
    NSString *repeatPassword = self.repeatPasswordField.text;
    
    if ([password isEqualToString:repeatPassword] && [self isValidatePassword:password]) {
        // 发起网络请求
        // 如果网络返回成功就返回登录界面重新登录
        // 网络请求yet
        UIAlertController *success = [UIAlertController alertControllerWithTitle:@"密码修改成功" message:@"密码修改成功请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        //UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *successAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 跳转到登录界面
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[DPLoginViewController alloc] init];
        }];
        [success addAction:successAction];
        [self presentViewController:success animated:YES completion:nil];
        
    } else {
        //
        UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"密码出错" message:@"请输入有效的密码且保证重复密码一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    };
    
    
    
}

@end

















