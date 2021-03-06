//
//  DPTabBarController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPTabBarController.h"
#import "DPNavigationController.h"
#import "DPTabBar.h"
#import "DPTableViewController.h"
#import "DPMapViewController.h"
#import "AFOAuth2Manager.h"
#import "DPComposeViewController.h"

@interface DPTabBarController () <DPTabBarDelegate>

@end

@implementation DPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 测试 登录成会把credential存储 这里测试能够从钥匙串得到credential
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    NSLog(@"TabBar界面读取credential:%@", [credential description]);
    
    // 设置子控制器
    DPMapViewController *discover = [[DPMapViewController alloc] init];
    [self addChildViewController:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    DPTableViewController *digu = [[DPTableViewController alloc] init];
    [self addChildViewController:digu title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    // 更换控制器的TabBar
    // self.tabBar = [[DPTabBar alloc] init]; // 报错 是只读属性
    DPTabBar *tabBar = [[DPTabBar alloc] init];
    tabBar.delegate = self;//注意不能放到KVC后面
    
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewController:(UIViewController *)childViewController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    // 设置子控制器
    // 设置背景色为随机色
    //childViewController.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    // 导航控制器的文字标题
    // childViewController.navigationItem.title = title;
    // tabBar按钮的文字标题
    // childViewController.tabBarItem.title = title;
    
    // 同时设置导航控制器的文字标题和tabBar按钮的文字标题
    childViewController.title = title;
    
    childViewController.tabBarItem.image = [UIImage imageNamed:image];
    childViewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0];
    [childViewController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置文字被选中时候的样式
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childViewController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    // 将子控制器包装入自定义的导航控制器
    DPNavigationController *nav = [[DPNavigationController alloc] initWithRootViewController:childViewController];
    
    // 添加子控制器
    [self addChildViewController:nav];
    
}

#pragma mark - DGTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(DPTabBar *)tabBar {
    
    DPComposeViewController *compose = [[DPComposeViewController alloc] init];
    
    DPNavigationController *navigation = [[DPNavigationController alloc] initWithRootViewController:compose];
    
    [self presentViewController:navigation animated:YES completion:nil];
}


@end
