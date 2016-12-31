//
//  DPApplyViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/28.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  对嘀咕的回应操作的发送控制器

#import "DPApplyViewController.h"
#import "DPTextViw.h"
#import <AFNetworking/AFNetworking.h>
#import "AFOAuth2Manager.h"
#import "MBProgressHUD.h"
#import "DPStatus.h"
#import "DPUser.h"


@interface DPApplyViewController () <UITextViewDelegate>

/** 输入控件 */
@property (nonatomic, strong) DPTextViw *textView;

@end

@implementation DPApplyViewController

// 懒加载以保持始终有
- (DPTextViw *)textView {
    
    if (!_textView) {
        self.textView = [[DPTextViw alloc] init];
    }
    return _textView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    
    [self setupTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置导航栏部分
- (void)setupNavigationBar {
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"回应" style:UIBarButtonItemStyleDone target:self action:@selector(apply)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.title = @"发出回应";
}


// 添加输入控件
- (void)setupTextView {
    // 在此控制器中 textView的contentInset.top默认为64
    DPTextViw *textView = [[DPTextViw alloc] init];
    // 垂直方向上可以拖动 使得占位符可以下托
    //textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:16];
    textView.placeholder = @"输入回应...";
    textView.placeholderColor = [UIColor grayColor];
    // 为了实现下拉时键盘退下
    textView.delegate = self;
    
    [self.view addSubview:textView];
    self.textView = textView;
    // 出现就调出键盘
    [textView becomeFirstResponder];
    
    // 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
}

// 利用MBProgressHUD制作的显示通知的方法
- (void)showHUD:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    UIImage *image = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.0];
}


#pragma -mark 监听方法
// 监听到文字改变后调用的方法
- (void)textDidChange {
    // 如果有文字 发送按钮就可用
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)apply {
    NSLog(@"Apply");
    // 获取含accessToken的凭证对象
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
    params[@"paopao_id"] = self.status.idstr;
    params[@"text"] = self.textView.text;
    // 发送评论
    [manager POST:@"/api/v1/comments/create" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"回应成功:%@",responseObject);
        [self showHUD:@"回应成功" icon:nil view:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"回应失败:%@",error);
        [self showHUD:@"回应失败" icon:nil view:nil];
        
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end





