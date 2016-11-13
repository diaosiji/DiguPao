//
//  UIWindow+Extension.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/13.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "DPTabBarController.h"
#import "DPNewFeatureViewController.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController {
    
    // 即使是上次成功登陆也要检查版本
    // 存储在沙盒中的版本号 即上次版本号
    NSString *versionKey = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    
    // 当前软件版本 从Info.plist中获取
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    //DGLog(@"%@", currentVersion);
    
    // 进行版本对比判断
    //UIWindow *window = [UIApplication sharedApplication].keyWindow; //换为对象方法后就不需要了
    if ([currentVersion isEqualToString:lastVersion]) {
        // 版本相同 直接进入Tabbar控制器
        self.rootViewController = [[DPTabBarController alloc] init];
    } else {
        // 版本不同 显示新特性界面
        self.rootViewController = [[DPNewFeatureViewController alloc] init];
        // 并更新存储新版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


@end
