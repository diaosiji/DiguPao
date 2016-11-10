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

- (IBAction)changeConfirmButtonTouched:(id)sender {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[DPLoginViewController alloc] init];
    
}

@end

















