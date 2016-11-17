//
//  DPTabBar.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPTabBar;
// 因为DGTabBar继承自UITabBar 所以成为DGTabBar的代理 也必须实现UITabBar的代理协议
@protocol DPTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(DPTabBar *)tabBar;

@end

@interface DPTabBar : UITabBar

@property (nonatomic, weak) id<DPTabBarDelegate> delegate;

@end
