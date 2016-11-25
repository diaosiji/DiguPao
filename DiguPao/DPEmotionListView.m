//
//  DPEmotionListView.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/18.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPEmotionListView.h"
#import "UIView+Extension.h"
#import "DPEmotionPageView.h"

// 定义每页上表情的个数
#define DPEmotionPageCount 20

@interface DPEmotionListView() <UIScrollViewDelegate>
/** UIScrollView 装表情的UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** UIPageControl 表情分页的UIPageControl */
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation DPEmotionListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 1.scrollview
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        //scrollView.backgroundColor = [UIColor blueColor];
        scrollView.pagingEnabled = YES;//分页
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.delegate = self; // 实现pagecontrol跟着页面变
        
        // 2.pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.userInteractionEnabled = NO;
        // 只有一页时隐藏高亮点
        pageControl.hidesForSinglePage = YES;
        // 设置内部原点图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"currentPageImage"];
//        pageControl.backgroundColor = [UIColor blackColor];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
    }
    return self;
}

/** 根据emotions创建对应个数的表情 */
- (void)setEmotions:(NSArray *)emotions {
    
    _emotions = emotions;
    //NSLog(@"表情数量:%lu", (unsigned long)emotions.count);
    // 1.设置页数
    NSUInteger count = (emotions.count + DPEmotionPageCount - 1) / DPEmotionPageCount;
    self.pageControl.numberOfPages = count;
    // 2.显示表情
    // 首先创建用来显示每一页表情的容器控件
    for (int i = 0; i < count; i++) {
        DPEmotionPageView *pageView = [[DPEmotionPageView alloc] init];
        // 设置这一页的表情
        // 计算表情范围
        NSRange range;
        range.location = i * DPEmotionPageCount;
        // 防止数组获取越界 leftCount即剩余表情个数
        NSUInteger leftCount = emotions.count - range.location;
        if (leftCount >= DPEmotionPageCount) {
            range.length = DPEmotionPageCount;
        } else {
            range.length = leftCount;
        }
        
        pageView.emotionsInPage = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
        
        // 每个pageview都应该把表情都加入进去
    }
    
    // 去除水平和垂直方向的滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    // 1.pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 2.scrollView
    self.scrollView.width = self.width;
    self.scrollView.x = self.scrollView.y = 0;
    self.scrollView.height = self.pageControl.y;
    
    // 3.设置scrollView内一个页表情容器控件的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i++) {
        DPEmotionPageView *pageView = self.scrollView.subviews[i];
        
        pageView.height = self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = pageView.width * i;
        pageView.y = 0;
    }
    
    // 4.设置scrollview的contentSize 这样才能滚动
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
    
}

#pragma mark UIScrollViewDelegate
// 实现pagecontrol指示点跟随scrollview翻页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double pageNumber = scrollView.contentOffset.x  / scrollView.width;
    self.pageControl.currentPage = (int)pageNumber + 0.5;
}

@end

















