//
//  DPTableViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/9.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPTableViewController.h"
#import "TestViewController.h"
#import "UIView+Extension.h"
#import "DPDropdownMenu.h"
#import "DPTitleMenuController.h"
#import "AFOAuth2Manager.h"
#import "DPStatus.h"
#import "DPUser.h"
#import "MJExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DPLoadMoreFooter.h"
#import "DPStatusCell.h"
#import "DPStatusFrame.h"
#import "DPStatusDetailController.h"
#import "LGSettingViewController.h"
#import "DPUserController.h"

@interface DPTableViewController () <DPDropdownMenuDelegate>

/** NSMutableArray 嘀咕数组 元素是DPStatusFrame模型 一个DPStatusFrame对象代表一个嘀咕 */
@property (nonatomic, strong) NSMutableArray *statusFrames;

@end

@implementation DPTableViewController

// 懒加载 使得数组永远不为空
- (NSMutableArray *)statusFrames {
    
    if (!_statusFrames) {
        self.statusFrames = [[NSMutableArray alloc] init];
    }
    return _statusFrames;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    // 让顶部也有间隔
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    // 学习使用类来注册Cell 有了这句下面的cellForRowAtIndexPath才能正常运行
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
    
    // 设置导航栏左中右按钮
    [self setNavigationBar];
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    // 集成上拉加载控件
    [self setupUpRefresh];
    
    // 监听iconView中选中的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iconViewDidSelected:) name:@"DPIconViewDidSelectedNotification" object:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 控件加载与方法

// 设置导航栏左中右按钮的方法
- (void)setNavigationBar {
    
    // 设置导航栏左边的按钮
    // 0.初始化一个自定义类型按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 1.设置backButton的图片
    [leftButton setBackgroundImage:[UIImage imageNamed:@"tabbar_profile"] forState:UIControlStateNormal]; // 正常状态下的图片
    [leftButton setBackgroundImage:[UIImage imageNamed:@"tabbar_profile_selected"] forState:UIControlStateHighlighted]; // 高亮状态下的图片
    // 2.设置backButton的尺寸（不设置尺寸不会显示）
    // 这里利用了UIView的分类十分方便
    // 让backButton的尺寸等于自身当前背景图片的尺寸
    leftButton.size = leftButton.currentBackgroundImage.size;
    // 3.向backButton添加动作方法
    [leftButton addTarget:self action:@selector(leftButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    // 4.将backButton赋值给传进来的视图控制器导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 设置导航栏右边的按钮
    // 0.初始化一个自定义类型按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 1.设置backButton的图片
    [rightButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_pop"] forState:UIControlStateNormal]; // 正常状态下的图片
    [rightButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_pop_highlighted"] forState:UIControlStateHighlighted]; // 高亮状态下的图片
    // 2.设置backButton的尺寸（不设置尺寸不会显示）
    // 这里利用了UIView的分类十分方便
    // 让backButton的尺寸等于自身当前背景图片的尺寸
    rightButton.size = rightButton.currentBackgroundImage.size;
    // 3.向backButton添加动作方法
    [rightButton addTarget:self action:@selector(rightButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    // 4.将backButton赋值给传进来的视图控制器导航栏左边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    // 设置中间标题按钮
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.width = 150;
    titleButton.height = 30;
    //titleButton.backgroundColor = [UIColor redColor];
    // 设置按钮图片和文字
    [titleButton setTitle:@"附近" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    // 设置顶端按钮的箭头不同状态下图片
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    // 在后续方法中通过设置selected属性变化就能改变图片
    // 调整按钮中图片和文字的位置
    // 左边空出90
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    // 右边空出20
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    // 监听标题的点击
    [titleButton addTarget:self action:@selector(titleButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}

// 导航栏左边按钮点击方法
- (void)leftButtonTouched {
    
    LGSettingViewController *profile = [[LGSettingViewController alloc] init];
    profile.hidesBottomBarWhenPushed = YES;
    profile.title = @"我";
    [self.navigationController pushViewController:profile animated:YES];
}

// 导航栏右边按钮点击方法
- (void)rightButtonTouched {
    NSLog(@"right");
}

// 中间标题按钮点击方法
- (void)titleButtonTouched:(UIButton *)titleButton {
    
    // 创建下拉菜单
    DPDropdownMenu *menu = [DPDropdownMenu menu];
    menu.delegate = self;
    
    // 设置菜单中的内容
    //menu.content = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
    DPTitleMenuController * menuController = [[DPTitleMenuController alloc] init];
    menuController.view.height = 44 * 3;
    // 这里和图片设置的slicing有关 设置为strech
    // 灰色图片原本宽度217 我们设置它的宽度150 箭头会被压扁一点
    menuController.view.width = 150;
    
    menu.contentController = menuController;
    
    // 显示菜单
    [menu showFrom:titleButton];
    
    
}

// 集成下拉刷新控件
- (void)setupDownRefresh {
    
    // 1.添加刷新控件
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    // 监听的UIControlEventValueChanged事件就是用户手动下拉 control进入了刷新状态
    [control addTarget:self action:@selector(refreshStateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    // 2.进入刷新状态 但是不会触发refreshStateChanged方法
    [control beginRefreshing];
    // 3.加载数据
    [self refreshStateChanged:control];
    
}

// 下拉刷新控件动作对应的方法:加载最新嘀咕数据
- (void)refreshStateChanged:(UIRefreshControl *)control {
    
    NSLog(@"refreshStateChanged");
    // 获取含accessToken的凭证对象
//    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    // 暂时先用iTunes的API代替
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
    
    //取出最前面（新）的嘀咕
    DPStatusFrame *firstStatusFrame = [self.statusFrames firstObject];
    if (firstStatusFrame) {
        // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
        params[@"since_id"] = firstStatusFrame.status.idstr;
        NSLog(@"本地最新嘀咕的id是:%@", firstStatusFrame.status.idstr);
    }
    
    [manager GET:@"/api/v1/paopaos/public" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"嘀咕广场API调用成功:%@", responseObject);
        NSArray *newStatus = [DPStatus mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        // 将DPStatus的数组转为DPStatusFrame的数组
        NSMutableArray *newFrames = [NSMutableArray array];
        for (DPStatus *status in newStatus) {
            DPStatusFrame *frame = [[DPStatusFrame alloc] init];
            frame.status = status;
            [newFrames addObject:frame];
        }
        // 将最新微博数据添加到对应数组最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        [control endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"嘀咕广场API调用失败: %@", error);
        // 结束刷新
        [control endRefreshing];
        
    }];

    
}

// 集成上拉加载控件
- (void)setupUpRefresh {
    DPLoadMoreFooter *footer = [DPLoadMoreFooter footer];
    // 不隐藏的话一开始就会出现
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
    
}

// 重写系统方法 实现下滑自动加载的关键点
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    
    // scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        // 网络加载更早的嘀咕
        [self loadEarlierStatus];
    };
    
}

#pragma mark - 网络通信方法

// 加载更早嘀咕的网络方法
- (void)loadEarlierStatus {
    // 获取含accessToken的凭证对象
    //    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"access_token"] = credential.accessToken;
    DPStatusFrame *lastStatusFrame = [self.statusFrames lastObject];
    if (lastStatusFrame) {
        // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
        params[@"max_id"] = lastStatusFrame.status.idstr;
        NSLog(@"获取最旧嘀咕的id:%@", lastStatusFrame.status.idstr);
    }
    
    [manager GET:@"/api/v1/paopaos/public" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"加载更早嘀咕API调用成功");
        NSArray *newStatus = [DPStatus mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        // 将DPStatus的数组转为DPStatusFrame的数组
        NSMutableArray *newFrames = [NSMutableArray array];
        for (DPStatus *status in newStatus) {
            DPStatusFrame *frame = [[DPStatusFrame alloc] init];
            frame.status = status;
            [newFrames addObject:frame];
        }
        
        // 将最新微博数据添加到对应数组最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"加载更早嘀咕API调用失败: %@", error);
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
        
    }];
    
}

// 获取用户地理位置附近的嘀咕
- (void)loadAroundStatus {
    
    // 获取含accessToken的凭证对象
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 获取地理位置
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    double latitudeDouble = [user doubleForKey:@"latitude"];
    double longtitudeDouble = [user doubleForKey:@"longtitude"];
    NSString *latitude = [NSString stringWithFormat:@"%f", latitudeDouble];
    NSString *longitude = [NSString stringWithFormat:@"%f", longtitudeDouble];
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
    params[@"latitude"] = latitude;
    params[@"longitude"]= longitude;
    
    [manager GET:@"/api/v1/paopaos/location" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSLog(@"附近API测试成功: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"附近API测试失败: %@", error);
    }];
    
}


#pragma mark - DPDropdownMenuDelegate
- (void)dropdownMenuDidDismiss:(DPDropdownMenu *)menu {
    // 说明菜单已经被销毁了
    // 应该将箭头倒过来
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
    
}

- (void)dropdownMenuDidShow:(DPDropdownMenu *)menu {
    
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    // 取出模型
//    DPUser * user = self.statuses[indexPath.row];
//    
//    // 设置cell
//    
//    cell.textLabel.text = @"test";
//    cell.detailTextLabel.text = @"试一试";
//    
//    return cell;
    
    // 另一种循环利用方法
    // 被static修饰的局部变量：只会初始化一次，在整个程序运行过程中，只有一份内存
//    static NSString *ID = @"cell";
    
    // 先根据cell的标识去缓存池中查找可循环利用的cell
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 如果cell为nil（缓存池找不到对应的cell）
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
   
    // 获得cell
    DPStatusCell *cell = [DPStatusCell cellWithTableView:tableView];
    
    // 给cell传递模型
    cell.statusFrame = self.statusFrames[indexPath.row];
    cell.iconView.tag = indexPath.row;
    [cell.iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserDetailsView:)]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DPStatusDetailController *detail = [[DPStatusDetailController alloc] init];
    // 跳转后隐藏底部的bar
    detail.hidesBottomBarWhenPushed = YES;
    // 传递嘀咕数据模型
    DPStatusFrame *frame = self.statusFrames[indexPath.row];
    detail.status = frame.status;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DPStatusFrame *frame = self.statusFrames[indexPath.row];
    
    return frame.cellHeight;
}

// iconView点击后跳转到用户界面
//- (void)iconViewDidSelected:(NSNotification *)notification {
//    
//    NSLog(@"收到通知:iconViewDidSelected");
////    DPUser *user = notification.userInfo[@"iconUser"];
//    DPUserController *controller = [[DPUserController alloc] init];
////    controller.user = user;
//    #warning 报错 说tableview没有接收到cell
//    [self presentViewController:controller animated:YES completion:nil];

#pragma mark - 跳转到用户详情页

- (void)pushUserDetailsView:(UITapGestureRecognizer *)recognizer
{
//    OSCTweet *tweet = self.objects[recognizer.view.tag];
//    UserDetailsViewController *userDetailsVC = [[UserDetailsViewController alloc] initWithUserID:tweet.authorID];
//    [self.navigationController pushViewController:userDetailsVC animated:YES];
    NSLog(@"pushUserDetailsView");
    DPStatusFrame *frame = self.statusFrames[recognizer.view.tag];
    DPUserController *controller = [[DPUserController alloc] init];
    controller.user = frame.status.user;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}




    
    
//}

@end
