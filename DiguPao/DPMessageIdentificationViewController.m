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

- (IBAction)nextStepButtonTouched:(id)sender {
    
    DPPasswordChangeViewController *change =[[DPPasswordChangeViewController alloc] init];
    
    [self.navigationController pushViewController:change animated:YES];
    
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
