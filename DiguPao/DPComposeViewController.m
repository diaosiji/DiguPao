//
//  DPComposeViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPComposeViewController.h"
#import "DPTextViw.h"
#import "DPComposeToolbar.h"
#import "UIView+Extension.h"
#import "AFOAuth2Manager.h"

@interface DPComposeViewController ()

@property (nonatomic, strong) DPTextViw *textView;

@end

@implementation DPComposeViewController

// 懒加载以保持始终有
- (UITextView *)textView {
    
    if (!_textView) {
        self.textView = [[DPTextViw alloc] init];
    }
    return _textView;
}

#pragma -mark 系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setupNavigationBar];
    // 添加输入控件
    [self setupTextView];
    // 添加工具条
    [self setupToolbar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    // 控制器销毁后就撤销监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma -mark 初始化方法
// 添加工具条
- (void)setupToolbar {
    
    DPComposeToolbar *toolbar = [[DPComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    // inputView是设置键盘
//    self.textView.inputView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    // 设置显示在键盘顶部的内容
    self.textView.inputAccessoryView = toolbar;
}

// 设置导航栏部分
- (void)setupNavigationBar {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.title = @"发嘀咕";
}

// 添加输入控件
- (void)setupTextView {
    // 在此控制器中 textView的contentInset.top默认为64
    DPTextViw *textView = [[DPTextViw alloc] init];
    
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:16];
    textView.placeholder = @"嘀咕一下...";
    textView.placeholderColor = [UIColor grayColor];
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
}

#pragma -mark 监听方法
// 监听到文字改变后调用的方法
- (void)textDidChange {
    // 如果有文字 发送按钮就可用
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

// 发送嘀咕方法
- (void)compose {
    // 获取地理位置
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    double latitudeDouble = [user doubleForKey:@"latitude"];
    double longtitudeDouble = [user doubleForKey:@"longtitude"];
//    NSNumber *latitude = [NSNumber numberWithDouble:latitudeDouble];
//    NSNumber *longtitude = [NSNumber numberWithDouble:longtitudeDouble];
    NSString *latitude = [NSString stringWithFormat:@"%f", latitudeDouble];
    NSString *longtitude = [NSString stringWithFormat:@"%f", longtitudeDouble];
    
    // 获取token凭证
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 构建字符串
    NSLog(@"Compose with text:%@ latitude:%f,longtitude:%f",self.textView.text, latitudeDouble,longtitudeDouble);
    // 发起网络请求
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken;
    params[@"text"] = self.textView.text;
    params[@"latitude"] = latitude;
    params[@"longitude"]= longtitude;
    // 发起请求
    [manager POST:@"/api/v1/paopaos" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"发送嘀咕API调用成功: %@", responseObject);
        // 弹窗提示成功
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发送成功" message:@"发送嘀咕API调用成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ensureAction];
        [self presentViewController:alert animated:YES completion:nil];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"发送嘀咕API调用失败: %@", error);
        // 弹框提示失败
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发送失败" message:@"发送嘀咕API调用失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ensureAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];

    
    
    
    
}

// 导航栏左边取消按钮
- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
