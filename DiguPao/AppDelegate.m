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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 测试控制器
    // 目前是作为核心的DPTabBarController
    //DPTabBarController *tabVC = [[DPTabBarController alloc] init];
    //DPLoginViewController *login = [[DPLoginViewController alloc] init];
    DPNewFeatureViewController *new = [[DPNewFeatureViewController alloc] init];
    
    self.window.rootViewController = new;
    // 首先判断应用中是否有accessToken 使用AFOAuth2Manager的retrieveCredentialWithIdentifier方法 从钥匙串中取出凭证对象
    // 然后判断凭证对象是否存在或者凭证对象的过期属性是否为真
    
    // 如果有且没有失效 那么应该直接调用UIWindow+Extension的switchRootViewController方法进行版本判断后显示新特性或者跟控制器
    // 如果accessToken不存在或者失效 那么应该显示登录界面
    
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    return YES;
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
