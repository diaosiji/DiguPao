//
//  AppDelegate.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "AppDelegate.h"
#import "DPTabBarController.h"
#import "DPLoginViewController.h"
#import "DPNewFeatureViewController.h"
#import "UIWindow+Extension.h"
#import "AFOAuth2Manager.h"
#import "SDWebImageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 测试
    // 目前是作为核心的DPTabBarController
    //DPTabBarController *tabVC = [[DPTabBarController alloc] init];
    //DPLoginViewController *login = [[DPLoginViewController alloc] init];
    //DPNewFeatureViewController *new = [[DPNewFeatureViewController alloc] init];
    //self.window.rootViewController = tabVC;
    
    
    // 首先判断应用中是否有accessToken 使用AFOAuth2Manager的retrieveCredentialWithIdentifier方法 从钥匙串中取出凭证对象
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    NSLog(@"AppDelegate读取credential:%@", credential);
    
    // 然后判断凭证对象是否存在或者凭证对象的过期属性是否为真
    if (credential.isExpired || credential == nil) { // 如果Token过期或凭证对象为空
        // 如果过期 则删除凭证对象 如果是没有 再删除下也无妨
        // 让登录控制器显示的时候 钥匙串中没有凭证对象 通过用户登录去获取新的
        [AFOAuthCredential deleteCredentialWithIdentifier:@"OAuthCredential"];
        // 则显示登录控制器让用户重新登录
        self.window.rootViewController = [[DPLoginViewController alloc] init];
    } else { // 如果Token有效
        // UIWindow+Extension的switchRootViewController方法进行版本判断后显示新特性或者跟控制器
        [self.window switchRootViewController];
    }
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 使用SDWebImage库的方法 在图片导致内存过多时清除图片并取消图片下载
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // 取消下载
    [manager cancelAll];
    // 清空内存
    [manager.imageCache clearMemory];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
