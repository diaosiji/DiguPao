//
//  DPComposeViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPComposeViewController.h"
#import "DPTextViw.h"

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
    
    [self setupNavigationBar];
    
    [self setupTextView];
    
    
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
    
    NSLog(@"%@", self.textView.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 导航栏左边取消按钮
- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
