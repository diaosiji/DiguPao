//
//  DPDetailTabBar.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/15.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPDetailTabBar;

// 因为DGTabBar继承自UITabBar 所以成为DGTabBar的代理 也必须实现UITabBar的代理协议
@protocol DPDetailTabBarDelegate <UITabBarDelegate>

@optional
/** 点击了回应按钮 */
- (void)detialTabBarDidClickApplyButton:(DPDetailTabBar *)tabBar;
/** 点击了收藏按钮 */
- (void)detialTabBarDidClickCollectionButton:(DPDetailTabBar *)tabBar;
/** 点击了点赞按钮 */
- (void)detialTabBarDidClickAttitudeButton:(DPDetailTabBar *)tabBar;

@end

@interface DPDetailTabBar : UITabBar

@property (nonatomic, weak)id<DPDetailTabBarDelegate> delegate;

@end
