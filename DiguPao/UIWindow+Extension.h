//
//  UIWindow+Extension.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/13.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  实现在应用启动时AppDelegate中如果accessToken有效后的逻辑
//  逻辑为判断当前应用版本，如果版本更新则显示新特性控制器，否则显示TabBar根控制器

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)

- (void)switchRootViewController;

@end
