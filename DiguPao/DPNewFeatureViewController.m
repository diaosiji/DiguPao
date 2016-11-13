//
//  DPNewFeatureViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/13.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPNewFeatureViewController.h"
#import "UIView+Extension.h"
#import "DPTabBarController.h"
#define DGNewFeatureCount 3

@interface DPNewFeatureViewController () <UIScrollViewDelegate>

@property (nonatomic, weak)UIPageControl *pageControl;

@end

@interface DPNewFeatureViewController ()

@end

@implementation DPNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.创建一个scrollview用来显示新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    // 2.添加图片到scrollview
    CGFloat scrollViewWidth = scrollView.width;
    CGFloat scrollViewHeight = scrollView.height;
    
    for (int i = 0; i < DGNewFeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollViewWidth;
        imageView.height = scrollViewHeight;
        imageView.y = 0;
        imageView.x = i * scrollViewWidth;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一张图片 就添加开始按钮
        if (i == DGNewFeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
        
    }
    
    // 3.设置scrollview的其他属性
    // 如果某个方向不想动，设置为0
    scrollView.contentSize = CGSizeMake(scrollViewWidth * DGNewFeatureCount, 0);
    // 去除弹簧效果
    scrollView.bounces = NO;
    // 增加分页效果
    scrollView.pagingEnabled = YES;
    // 去掉水平滑动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 4.添加pageControl：分页 展示目前是第几页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = DGNewFeatureCount;
    pageControl.width = 100;
    pageControl.height = 50;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.centerX = scrollViewWidth * 0.5;
    pageControl.centerY = scrollViewHeight - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    double page = scrollView.contentOffset.x / scrollView.width;
    // 四舍五入算页码
    self.pageControl.currentPage = (int)(page + 0.5);
}

- (void)setupLastImageView:(UIImageView *)imageView {
    
    imageView.userInteractionEnabled = YES;
    
    // 1.分享给大家checkbox
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareButton setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
    shareButton.width = 100;
    shareButton.height = 30;
    shareButton.centerX = imageView.width * 0.5;
    shareButton.centerY = imageView.height * 0.7;
    [shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareButton];
    
    // 2.开始嘀咕
    UIButton *startButton = [[UIButton alloc] init];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startButton.size = startButton.currentBackgroundImage.size;
    startButton.centerX = imageView.width * 0.5;
    startButton.centerY = imageView.height * 0.8;
    [startButton setTitle:@"开始嘀咕" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    
    
}

- (void)shareClick:(UIButton *)shareButton {
    
    shareButton.selected = !shareButton.isSelected;
}

- (void)startClick {
    NSLog(@"startClick");
    // 切换到DGTabBarController
    /* 切换控制器的手段有：
     push:依赖UINavigationController push操作可逆
     modal：也可逆
     切换window的rootController */
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[DPTabBarController alloc] init];
    
}

@end
