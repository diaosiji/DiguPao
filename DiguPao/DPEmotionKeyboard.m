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
#import "DPEmotion.h"
#import "MJExtension.h"
#import "DPEmotionTool.h"

@interface DPEmotionKeyboard() <DPEmotionTabBarDelegate>
/** 保存正在表情键盘上显示的listView */
@property (nonatomic, weak) DPEmotionListView *showingListView;
/** 最近表情内容 */
@property (nonatomic, strong) DPEmotionListView *recentListView;
/** 默认表情内容 */
@property (nonatomic, strong) DPEmotionListView *defaultListView;
/** emoji表情内容 */
@property (nonatomic, strong) DPEmotionListView *emojiListView;
/** 嘀咕表情内容 */
@property (nonatomic, strong) DPEmotionListView *diguListView;
/** 选项卡 */
@property (nonatomic, weak) DPEmotionTabBar *tabBar;

@end

@implementation DPEmotionKeyboard
#pragma mark - 懒加载
- (DPEmotionListView *)recentListView {
    if (!_recentListView) {
        self.recentListView = [[DPEmotionListView alloc] init];
        // 从沙盒中加载最近表情数据
        self.recentListView.emotions = [DPEmotionTool recentEmotions];
        
    }
    return _recentListView;
}

- (DPEmotionListView *)defaultListView {
    if (!_defaultListView) {
        self.defaultListView = [[DPEmotionListView alloc] init];
//        self.defaultListView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        // 使用MJ框架将字典数组转化为模型数组
        NSArray *defaultEmotions = [DPEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        // 将模型数组赋值给表情数组
        self.defaultListView.emotions = defaultEmotions;
        
    }
    return _defaultListView;
}

- (DPEmotionListView *)emojiListView {
    if (!_emojiListView) {
        self.emojiListView = [[DPEmotionListView alloc] init];
//        self.emojiListView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        NSArray *emojiEmotions = [DPEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.emojiListView.emotions = emojiEmotions;
        
    }
    return _emojiListView;
}

- (DPEmotionListView *)diguListView {
    if (!_diguListView) {
        self.diguListView = [[DPEmotionListView alloc] init];
//        self.diguListView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        NSArray *diguEmotions = [DPEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.diguListView.emotions = diguEmotions;
    }
    return _diguListView;
}


#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // TabBar
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
    
    // 2.listView
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;

}

#pragma - mark DPEmotionTabBarDelegate
- (void)emotionTabBar:(DPEmotionTabBar *)tabBar didSelectButton:(DPEmotionTabBarButtonType)buttonType {
    
    // 移除键盘正在显示的listView
    [self.showingListView removeFromSuperview];
    
    // 根据按钮类型 切换键盘上的listView
    switch (buttonType) {
            
        case DPEmotionTabBarButtonTypeRecent: { // 最近
            [self addSubview:self.recentListView];
//            self.showingListView = self.recentListView;
            break;
        }
            
        case DPEmotionTabBarButtonTypeDefault: {
            
            NSLog(@"默认");
            [self addSubview:self.defaultListView];
//            self.showingListView = self.defaultListView;
            break;
        }
            
        case DPEmotionTabBarButtonTypeEmoji: {
            
            NSLog(@"emoji");
            [self addSubview:self.emojiListView];
//            self.showingListView = self.emojiListView;
            break;
        
        }
            
        case DPEmotionTabBarButtonTypeDigu: {
            
            NSLog(@"嘀咕");
            [self addSubview:self.diguListView];
//            self.showingListView = self.diguListView;
            break;
        }
            
    }
    // 设置子控件中最后加入的一个为正在显示的listView
    self.showingListView = [self.subviews lastObject];
    // 设置frame 在适当时候调用layoutSubviews
    [self setNeedsLayout];
}

@end













