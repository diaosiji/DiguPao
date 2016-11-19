//
//  DPEmotionTabBar.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/18.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  表情键盘下面的选项卡

#import <UIKit/UIKit.h>

typedef enum {
    
    DPEmotionTabBarButtonTypeRecent, // 最近
    DPEmotionTabBarButtonTypeDefault, // 默认
    DPEmotionTabBarButtonTypeEmoji, // Emoji
    DPEmotionTabBarButtonTypeDigu, // 嘀咕
    
} DPEmotionTabBarButtonType;

@class DPEmotionTabBar;

@protocol DPEmotionTabBarDelegate <NSObject>

@optional
//
- (void)emotionTabBar:(DPEmotionTabBar *)tabBar didSelectButton:(DPEmotionTabBarButtonType)buttonType;
@end


@interface DPEmotionTabBar : UIView
//
@property (nonatomic, weak) id<DPEmotionTabBarDelegate> delegate;
@end
