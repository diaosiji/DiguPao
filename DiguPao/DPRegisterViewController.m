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

- (void)backButtonTouched {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerButtonTouched:(id)sender {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[DPLoginViewController alloc] init];
}

@end
