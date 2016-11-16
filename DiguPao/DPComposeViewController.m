//
//  DPComposeViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPComposeViewController.h"

@interface DPComposeViewController ()

@property (nonatomic, weak) UITextView *textView;

@end

@implementation DPComposeViewController

- (UITextView *)textView {
    
    if (!_textView) {
        self.textView = [[UITextView alloc] init];
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    
    [self setupTextView];
    
    
}

- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 设置导航栏部分
- (void)setupNavigationBar {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(compose)];
    
    self.navigationItem.title = @"发嘀咕";
}

- (void)setupTextView {
    
    UITextView *textView = [[UITextView alloc] init];
    
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)compose {
    
    NSLog(@"%@", self.textView.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
