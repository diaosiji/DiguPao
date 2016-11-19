//
//  DPEmotionKeyboard.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/18.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPEmotionKeyboard.h"
#import "DPEmotionListView.h"
#import "DPEmotionTabBar.h"
#import "UIView+Extension.h"

@interface DPEmotionKeyboard() <DPEmotionTabBarDelegate>
/** 表情内容 */
@property (nonatomic, weak) DPEmotionListView *listView;
/** 选项卡 */
@property (nonatomic, weak) DPEmotionTabBar *tabBar;

@end

@implementation DPEmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // 1.表情内容
        DPEmotionListView *listView = [[DPEmotionListView alloc] init];
        listView.backgroundColor = [UIColor greenColor];
        [self addSubview:listView];
        self.listView = listView;
        
        
        // 2.TabBar
        DPEmotionTabBar *tabBar = [[DPEmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
    };
    
    return self;
}

// 设置子控件尺寸
- (void)layoutSubviews {
    
    // 1.tabBar
    self.tabBar.height = 37; // 这里是根据图片高度设置的
    self.tabBar.y = self.height - self.tabBar.height;
    self.tabBar.width = self.width;
    self.x = 0;
    
    // 2.表情内容
    self.x = 0;
    self.y = 0;
    self.listView.width = self.width;
    self.listView.height = self.tabBar.y;
}

#pragma - mark DPEmotionTabBarDelegate
- (void)emotionTabBar:(DPEmotionTabBar *)tabBar didSelectButton:(DPEmotionTabBarButtonType)buttonType {
    switch (buttonType) {
            
        case DPEmotionTabBarButtonTypeRecent:
            NSLog(@"最近");
            break;
            
        case DPEmotionTabBarButtonTypeDefault:
            NSLog(@"默认");
            break;
            
        case DPEmotionTabBarButtonTypeEmoji:
            NSLog(@"emoji");
            break;
            
        case DPEmotionTabBarButtonTypeDigu:
            NSLog(@"嘀咕");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
            NSArray *lxhEmotions = [NSArray arrayWithContentsOfFile:path];
            NSLog(@"%@", lxhEmotions);
            
            
            break;
            
    }
}

@end













