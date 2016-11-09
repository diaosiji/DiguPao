//
//  DPNavigationController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPNavigationController.h"
#import "UIView+Extension.h"

@interface DPNavigationController ()

@end

@implementation DPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 重写push方法的目的：能够拦截所有push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:YES];
    
    if (self.viewControllers.count > 1) {// 这是push进来的视图控制器不是第一个（不是根控制器）
        // push后隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏左边的按钮
        // 0.初始化一个自定义类型按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 1.设置backButton的图片
        [backButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal]; // 正常状态下的图片
        [backButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted]; // 高亮状态下的图片
        // 2.设置backButton的尺寸（不设置尺寸不会显示）
        // 这里利用了UIView的分类十分方便
        // 让backButton的尺寸等于自身当前背景图片的尺寸
        backButton.size = backButton.currentBackgroundImage.size;
        // 3.向backButton添加动作方法
        [backButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        // 4.将backButton赋值给传进来的视图控制器导航栏左边按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // 设置导航栏右边的按钮
        // 0.初始化一个按钮
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 1.设置moreButton的图片
        [moreButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateNormal];
        [moreButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_more"] forState:UIControlStateHighlighted];
        // 2.设置moreButton的尺寸
        moreButton.size = moreButton.currentBackgroundImage.size;
        // 3.添加动作方法
        [moreButton addTarget:self action:@selector(moreButtonTouched) forControlEvents:UIControlEventTouchUpInside];
        // 4.将moreButton赋值给传进来的视图控制器的导航栏右边按钮
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    }
    
}

- (void)backButtonTouched {
    [self popViewControllerAnimated:YES];
}

- (void)moreButtonTouched {
    
    [self popToRootViewControllerAnimated:YES];
}


@end
