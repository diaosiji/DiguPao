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

@interface DPEmotionKeyboard() <DPEmotionTabBarDelegate>
/** 容纳表情内容的控件 */
@property (nonatomic, weak) UIView *contentView;
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
        self.recentListView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    }
    return _recentListView;
}

- (DPEmotionListView *)defaultListView {
    if (!_defaultListView) {
        self.defaultListView = [[DPEmotionListView alloc] init];
        self.defaultListView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
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
        self.emojiListView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/eomoji/info.plist" ofType:nil];
        NSArray *emojiEmotions = [DPEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        self.emojiListView.emotions = emojiEmotions;
        
    }
    return _emojiListView;
}

- (DPEmotionListView *)diguListView {
    if (!_diguListView) {
        self.diguListView = [[DPEmotionListView alloc] init];
        self.diguListView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
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
        // 1.装表情内容listView的容器
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
        
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
    
    // 2.表情容器控件的尺寸
    self.contentView.x = 0;
    self.contentView.y = 0;
    self.contentView.width = self.width;
    self.contentView.height = self.tabBar.y;
    
    // 设置frame
    UIView *child = [self.contentView.subviews lastObject];
    child.frame = self.contentView.bounds;

}

#pragma - mark DPEmotionTabBarDelegate
- (void)emotionTabBar:(DPEmotionTabBar *)tabBar didSelectButton:(DPEmotionTabBarButtonType)buttonType {
    // 移除contentView之前显示的控件 把之前的挪掉
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 根据按钮类型 再把点击到的加进去
    switch (buttonType) {
            
        case DPEmotionTabBarButtonTypeRecent: { // 最近
            [self.contentView addSubview:self.recentListView];
            break;
        }
            
        case DPEmotionTabBarButtonTypeDefault: {
            
            NSLog(@"默认");
            [self.contentView addSubview:self.defaultListView];
            break;
        }
            
        case DPEmotionTabBarButtonTypeEmoji: {
            
            NSLog(@"emoji");
            [self.contentView addSubview:self.emojiListView];
            break;
        
        }
            
        case DPEmotionTabBarButtonTypeDigu: {
            
            NSLog(@"嘀咕");
            [self.contentView addSubview:self.diguListView];
            break;
        }
            
    }
    // 重新布局子控件
    [self setNeedsLayout]; // 强制刷新子控件（会在恰当时刻重新调用layoutSubviews）
}

@end













