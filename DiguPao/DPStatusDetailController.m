//
//  DPStatusDetailController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPStatusDetailController.h"
#import "DPDetailHeader.h"
#import "DPDetailStatusFrame.h"
#import "DPDetailStatusCell.h"
#import "DPStatus.h"
#import "DPDetailStatusCell.h"
#import "UIView+Extension.h"
#import "DPDetailToolBar.h"
#import "DPApplyViewController.h"
#import "AFOAuth2Manager.h"
#import "MJExtension.h"
#import "DPLoadMoreFooter.h"
#import "DPApply.h"
#import "DPApplyFrame.h"
#import "DPApplyCell.h"
#import "DPCollection.h"
#import "DPCollectionFrame.h"
#import "DPCollectionCell.h"
#import "DPAttitude.h"
#import "DPAttitudeFrame.h"
#import "DPAttitudeCell.h"

@interface DPStatusDetailController () <DPDetailHeaderDelegate, DPDetailToolBarDelegate>

{
    DPDetailHeader *_detailHeader;
}

@property (nonatomic, strong) DPDetailStatusFrame *detailStatusFrame;
/** DPDetailHeader 第二个section的自定义控件 */
//@property (nonatomic, weak) DPDetailHeader *detailHeader;

/** 顶部工具条 */
@property (nonatomic, strong) DPDetailToolBar *toolBar;

/** NSMutableArray 嘀咕数组 元素是DPApplyFrame模型 一个DPApplyFrame对象代表一个嘀咕回应 */
@property (nonatomic, strong) NSMutableArray *applyFrames;
/** NSMutableArray 嘀咕数组 元素是DPApplyFrame模型 一个DPCollectionFrame对象代表一个收藏 */
@property (nonatomic, strong) NSMutableArray *collectionFrames;
/** NSMutableArray 嘀咕数组 元素是DPApplyFrame模型 一个DPAttitudeFrame对象代表一个收藏 */
@property (nonatomic, strong) NSMutableArray *attitudeFrames;

@end

@implementation DPStatusDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"嘀咕详情";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailCell"];
//    self.detailHeader.delegate = self;
    [self setupToolbar];

    
    if (_detailHeader == nil) {
        DPDetailHeader *header = [DPDetailHeader header];
        header.delegate = self;
        _detailHeader = header;
    }
    
    // 集成下拉刷新控件
    [self setupDownRefresh];
    
    //
    [self setupUpRefresh];
    
    // 初始header点击回应
    [self detailHeader:_detailHeader btnClick:DetailHeaderBtnTypeApply];

    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
//    [self setupToolbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (DPDetailHeader *)detailHeader {
//    if (!_detailHeader) {
//        DPDetailHeader *header = [DPDetailHeader header];
//        header.delegate = self;
//        self.detailHeader = header;
//        
//    }
//    return _detailHeader;
//}

// 懒加载令微博尺寸模型存在且得到数据模型
- (DPDetailStatusFrame *)detailStatusFrame {
    
    if (!_detailStatusFrame) {
        self.detailStatusFrame = [[DPDetailStatusFrame alloc] init];
        self.detailStatusFrame.status = self.status;
    }
    return _detailStatusFrame;
}

// 懒加载
- (NSMutableArray *)applyFrames {
    if (!_applyFrames) {
        self.applyFrames = [[NSMutableArray alloc] init];
    }
    return _applyFrames;
}

// 懒加载
- (NSMutableArray *)collectionFrames {
    if (!_collectionFrames) {
        self.collectionFrames = [[NSMutableArray alloc] init];
    }
    return _collectionFrames;
}

// 懒加载
- (NSMutableArray *)attitudeFrames {
    if (!_attitudeFrames) {
        self.attitudeFrames = [[NSMutableArray alloc] init];
    }
    return _attitudeFrames;
}

// 添加工具条
- (void)setupToolbar {
    
    DPDetailToolBar *toolbar = [[DPDetailToolBar alloc] init];
    // 顶层窗口
    //    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    toolbar.x = 0;
    toolbar.width = window.width;
    toolbar.height = 44;
    toolbar.y = window.height - toolbar.height;
    //    toolbar.y = 0;
    // 让工具条的代理是控制器自己 这样就可以实现点击按钮的代理方法
    toolbar.delegate = self;
    
    [window addSubview:toolbar];
    
    self.toolBar = toolbar;
}


// 集成下拉刷新控件
- (void)setupDownRefresh {
    
    // 1.添加刷新控件
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    // 监听的UIControlEventValueChanged事件就是用户手动下拉 control进入了刷新状态
    [control addTarget:self action:@selector(refreshStateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    // 2.进入刷新状态 但是不会触发refreshStateChanged方法
//    [control beginRefreshing];
    // 3.加载数据
//    [self refreshStateChanged:control];
    
}

// 下拉刷新控件动作对应的方法:加载最新嘀咕数据
- (void)refreshStateChanged:(UIRefreshControl *)control {
    
    NSLog(@"refreshStateChanged");
    if (_detailHeader.currentType == DetailHeaderBtnTypeApply) {
        /** 回应API未成功前使用广场API测试显示效果 */
        NSLog(@"loadNewApply");
        // 获取含accessToken的凭证对象
            AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
        // 设置基础url
        // 暂时先用iTunes的API代替
        NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        // 设置参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
        params[@"paopao_id"] = self.status.idstr; // 指明是看哪个嘀咕
        
        //取出最前面（新）的嘀咕
        DPApplyFrame *firstFrame = [self.applyFrames firstObject];
        if (firstFrame) {
            // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
            params[@"since_id"] = firstFrame.apply.idstr;
            NSLog(@"本地最新嘀咕的id是:%@", firstFrame.apply.idstr);
        }
        
        [manager GET:@"/api/v1/comments/list" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //        NSLog(@"嘀咕广场API调用成功:%@", responseObject);
            NSArray *newApplys = [DPStatus mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
            // 将DPStatus的数组转为DPStatusFrame的数组
            NSMutableArray *newFrames = [NSMutableArray array];
            for (DPApply *apply in newApplys) {
                DPApplyFrame *frame = [[DPApplyFrame alloc] init];
                frame.apply = apply;
                [newFrames addObject:frame];
            }
            // 将最新微博数据添加到对应数组最前面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.applyFrames insertObjects:newFrames atIndexes:set];
            
            // 刷新表格
            [self.tableView reloadData];
            // 结束刷新
            [control endRefreshing];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"嘀咕广场API调用失败: %@", error);
            // 结束刷新
            [control endRefreshing];
            
        }];
    } else if (_detailHeader.currentType == DetailHeaderBtnTypeCollection){
        // 按钮点击收藏的时候
        /** 回应API未成功前使用广场API测试显示效果 */
        NSLog(@"loadNewCollection");
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
        DPCollectionFrame *firstFrame = [self.collectionFrames firstObject];
        if (firstFrame) {
            // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
            params[@"since_id"] = firstFrame.collection.idstr;
            NSLog(@"本地最新嘀咕的id是:%@", firstFrame.collection.idstr);
        }
        
        [manager GET:@"/api/v1/paopaos/public" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //        NSLog(@"嘀咕广场API调用成功:%@", responseObject);
            NSArray *newCollections = [DPCollection mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
            // 将DPStatus的数组转为DPStatusFrame的数组
            NSMutableArray *newFrames = [NSMutableArray array];
            for (DPCollection *collection in newCollections) {
                DPCollectionFrame *frame = [[DPCollectionFrame alloc] init];
                frame.collection = collection;
                [newFrames addObject:frame];
            }
            // 将最新微博数据添加到对应数组最前面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.collectionFrames insertObjects:newFrames atIndexes:set];
            
            // 刷新表格
            [self.tableView reloadData];
            // 结束刷新
            [control endRefreshing];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"嘀咕广场API调用失败: %@", error);
            // 结束刷新
            [control endRefreshing];
            
        }];

    } else if (_detailHeader.currentType == DetailHeaderBtnTypeAttitude) {
        // 点击显示点赞用户按钮
        /** 回应API未成功前使用广场API测试显示效果 */
        NSLog(@"loadNewCollection");
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
        DPAttitudeFrame *firstFrame = [self.attitudeFrames firstObject];
        if (firstFrame) {
            // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
            params[@"since_id"] = firstFrame.attitude.idstr;
            NSLog(@"本地最新嘀咕的id是:%@", firstFrame.attitude.idstr);
        }
        
        [manager GET:@"/api/v1/paopaos/public" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //        NSLog(@"嘀咕广场API调用成功:%@", responseObject);
            NSArray *newAttitudes = [DPAttitude mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
            // 将DPStatus的数组转为DPStatusFrame的数组
            NSMutableArray *newFrames = [NSMutableArray array];
            for (DPAttitude *attitude in newAttitudes) {
                DPAttitudeFrame *frame = [[DPAttitudeFrame alloc] init];
                frame.attitude = attitude;
                [newFrames addObject:frame];
            }
            // 将最新微博数据添加到对应数组最前面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.collectionFrames insertObjects:newFrames atIndexes:set];
            
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
//    if (self.applyFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
//    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
//        // 显示footer
//        self.tableView.tableFooterView.hidden = NO;
//        if (_detailHeader.currentType == DetailHeaderBtnTypeApply) {
//            // 网络加载更早的回应
//            [self loadEarlierApply];
//        } else if (_detailHeader.currentType == DetailHeaderBtnTypeCollection) {
//            // 加载更早的收藏
//            [self loadEarlierColletction];
//        }
//        
//    };
    
    if (_detailHeader.currentType == DetailHeaderBtnTypeApply) {
        //
        if (self.applyFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
        if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
            // 显示footer
            self.tableView.tableFooterView.hidden = NO;
            // 网络加载更早回应
            [self loadEarlierApply];
        };
    } else if (_detailHeader.currentType == DetailHeaderBtnTypeCollection) {
        //
        if (self.collectionFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
        if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
            // 显示footer
            self.tableView.tableFooterView.hidden = NO;
            // 网络加载更早回应
            [self loadEarlierColletction];
        };
    } else {
        if (self.attitudeFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
        if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
            // 显示footer
            self.tableView.tableFooterView.hidden = NO;
            // 网络加载更早回应
            [self loadEarlierAttitude];
        };
    }
    
}

- (void)loadEarlierApply {
    // 获取含accessToken的凭证对象
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
    params[@"paopao_id"] = self.status.idstr; // 指明是看哪个嘀咕
    
    DPApplyFrame *lastFrame = [self.applyFrames lastObject];
    if (lastFrame) {
        // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
        params[@"max_id"] = lastFrame.apply.idstr;
        NSLog(@"获取最旧嘀咕的id:%@", lastFrame.apply.idstr);
    }
    
    [manager GET:@"/api/v1/comments/list" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"加载更早嘀咕API调用成功");
        NSArray *newStatus = [DPApply mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        // 将DPStatus的数组转为DPStatusFrame的数组
        NSMutableArray *newFrames = [NSMutableArray array];
        for (DPApply *apply in newStatus) {
            DPApplyFrame *frame = [[DPApplyFrame alloc] init];
            frame.apply = apply;
            [newFrames addObject:frame];
        }
        
        // 将最新微博数据添加到对应数组最后面
        [self.applyFrames addObjectsFromArray:newFrames];
        
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

- (void)loadEarlierColletction {
    
    // 获取含accessToken的凭证对象
    //    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"access_token"] = credential.accessToken;
    DPCollectionFrame *lastFrame = [self.collectionFrames lastObject];
    if (lastFrame) {
        // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
        params[@"max_id"] = lastFrame.collection.idstr;
        NSLog(@"获取最旧嘀咕的id:%@", lastFrame.collection.idstr);
    }
    
    [manager GET:@"/api/v1/paopaos/public" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"加载更早嘀咕API调用成功");
        NSArray *newCollections = [DPCollection mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        // 将DPStatus的数组转为DPStatusFrame的数组
        NSMutableArray *newFrames = [NSMutableArray array];
        for (DPCollection *collection in newCollections) {
            DPCollectionFrame *frame = [[DPCollectionFrame alloc] init];
            frame.collection = collection;
            [newFrames addObject:frame];
        }
        
        // 将最新微博数据添加到对应数组最后面
        [self.collectionFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"加载更早收藏API调用失败: %@", error);
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
        
    }];

    
}

- (void)loadEarlierAttitude {
    // 获取含accessToken的凭证对象
    //    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"access_token"] = credential.accessToken;
    DPAttitudeFrame *lastFrame = [self.attitudeFrames lastObject];
    if (lastFrame) {
        // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
        params[@"max_id"] = lastFrame.attitude.idstr;
        NSLog(@"获取最旧嘀咕的id:%@", lastFrame.attitude.idstr);
    }
    
    [manager GET:@"/api/v1/paopaos/public" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"加载更早嘀咕API调用成功");
        NSArray *newAttitudes = [DPAttitude mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        // 将DPStatus的数组转为DPStatusFrame的数组
        NSMutableArray *newFrames = [NSMutableArray array];
        for (DPAttitude *attitude in newAttitudes) {
            DPAttitudeFrame *frame = [[DPAttitudeFrame alloc] init];
            frame.attitude = attitude;
            [newFrames addObject:frame];
        }
        
        // 将最新微博数据添加到对应数组最后面
        [self.attitudeFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"加载更早收藏API调用失败: %@", error);
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
        
    }];
}

#pragma mark - Table view data source

#pragma mark NO.1 有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

#pragma mark NO.2 第section组头部控件有多高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    return 60;
}

#pragma mark NO.3 第section组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (_detailHeader.currentType == DetailHeaderBtnTypeApply){
        // 当前按钮状态为回应
        return self.applyFrames.count;
        
    } else if (_detailHeader.currentType == DetailHeaderBtnTypeCollection) {
        // 当前按钮状为收藏
        return self.collectionFrames.count;
        
    } else {
        // 这里是按钮状态为点赞
        return self.attitudeFrames.count;
    }
}

#pragma mark NO.4 indexPath这行的cell有多高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.detailStatusFrame.cellHeight;
    } else if (_detailHeader.currentType == DetailHeaderBtnTypeApply){
        // 当前按钮状态为回应
        DPApplyFrame *frame = self.applyFrames[indexPath.row];
        return frame.cellHeight;
    } else if (_detailHeader.currentType == DetailHeaderBtnTypeCollection) {
        // 当前按钮状为收藏
        DPCollectionFrame *frame = self.collectionFrames[indexPath.row];
        return frame.cellHeight;
    } else {// if (_detailHeader.currentType == DetailHeaderBtnTypeAttitude)
        // 这里是按钮状态为点赞
        DPAttitudeFrame *frame = self.attitudeFrames[indexPath.row];
        return frame.cellHeight;
        
    }
}

#pragma mark NO.5 indexPath这行的cell长什么样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // 嘀咕详情
        // 获得详情Cell
        DPDetailStatusCell *cell = [DPDetailStatusCell cellWithTableView:tableView];
        cell.detailStatusFrame = self.detailStatusFrame;
        NSLog(@"嘀咕文字:%@", cell.detailStatusFrame.status.text);
//        NSLog(@"嘀咕高度:%f", cell.detailStatusFrame.cellHeight);
        return cell;
        
    } else if (_detailHeader.currentType == DetailHeaderBtnTypeApply) {
        // 当前按钮状态为回应
        DPApplyCell *cell = [DPApplyCell cellWithTableView:tableView];
        cell.applyFrame = self.applyFrames[indexPath.row];
        return cell;
    } else if (_detailHeader.currentType == DetailHeaderBtnTypeCollection) {
        // 当前按钮状为收藏
        DPCollectionCell *cell = [DPCollectionCell cellWithTableView:tableView];
        cell.collectionFrame = self.collectionFrames[indexPath.row];
        return cell;
    } else {
        // 这里是按钮状态为点赞
        DPAttitudeCell *cell = [DPAttitudeCell cellWithTableView:tableView];
        cell.attitudeFrame = self.attitudeFrames[indexPath.row];
        return cell;
    }
    
}

#pragma mark NO.6 第section组头部显示什么控件
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    //    _detailHeader.status = _status;
    
//    return self.detailHeader;
    return _detailHeader;
}

- (void)loadNewApply {
    /** 回应API未成功前使用广场API测试显示效果 */
    NSLog(@"loadNewApply");
    // 获取含accessToken的凭证对象
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    // 暂时先用iTunes的API代替
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
    params[@"paopao_id"] = self.status.idstr; // 指明是看哪个嘀咕
    
    //取出最前面（新）的嘀咕
    DPApplyFrame *firstFrame = [self.applyFrames firstObject];
    if (firstFrame) {
        // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
        params[@"since_id"] = firstFrame.apply.idstr;
        NSLog(@"本地最新嘀咕的id是:%@", firstFrame.apply.idstr);
    }
    
    [manager GET:@"/api/v1/comments/list" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"list API调用成功:%@", responseObject);
        NSArray *newApplys = [DPApply mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        // 将DPStatus的数组转为DPStatusFrame的数组
        NSMutableArray *newFrames = [NSMutableArray array];
        for (DPApply *apply in newApplys) {
            DPApplyFrame *frame = [[DPApplyFrame alloc] init];
            frame.apply = apply;
            [newFrames addObject:frame];
        }
        // 将最新微博数据添加到对应数组最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.applyFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
//        [control endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"list API调用失败: %@", error);
        // 结束刷新
//        [control endRefreshing];
        
    }];

}

- (void)loadNewCollection {
    /** 回应API未成功前使用广场API测试显示效果 */
    NSLog(@"loadNewCollection");
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
    DPCollectionFrame *firstFrame = [self.collectionFrames firstObject];
    if (firstFrame) {
        // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
        params[@"since_id"] = firstFrame.collection.idstr;
        NSLog(@"本地最新嘀咕的id是:%@", firstFrame.collection.idstr);
    }
    
    [manager GET:@"/api/v1/paopaos/public" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSLog(@"嘀咕广场API调用成功:%@", responseObject);
        NSArray *newCollections = [DPCollection mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        // 将DPStatus的数组转为DPStatusFrame的数组
        NSMutableArray *newFrames = [NSMutableArray array];
        for (DPCollection *collection in newCollections) {
            DPCollectionFrame *frame = [[DPCollectionFrame alloc] init];
            frame.collection = collection;
            [newFrames addObject:frame];
        }
        // 将最新微博数据添加到对应数组最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.collectionFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        //        [control endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"嘀咕广场API调用失败: %@", error);
        // 结束刷新
        //        [control endRefreshing];
        
    }];

    
}

- (void)loadNewAttitude {
    /** 回应API未成功前使用广场API测试显示效果 */
    NSLog(@"loadNewCollection");
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
    DPAttitudeFrame *firstFrame = [self.attitudeFrames firstObject];
    if (firstFrame) {
        // 指定此参数则返回嘀咕ID比since_id大（即更晚的）的嘀咕 默认为0
        params[@"since_id"] = firstFrame.attitude.idstr;
        NSLog(@"本地最新嘀咕的id是:%@", firstFrame.attitude.idstr);
    }
    
    [manager GET:@"/api/v1/paopaos/public" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSLog(@"嘀咕广场API调用成功:%@", responseObject);
        NSArray *newAttitudes = [DPAttitude mj_objectArrayWithKeyValuesArray:responseObject[@"content"]];
        // 将DPStatus的数组转为DPStatusFrame的数组
        NSMutableArray *newFrames = [NSMutableArray array];
        for (DPAttitude *attitude in newAttitudes) {
            DPAttitudeFrame *frame = [[DPAttitudeFrame alloc] init];
            frame.attitude = attitude;
            [newFrames addObject:frame];
        }
        // 将最新微博数据添加到对应数组最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.attitudeFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新
        //        [control endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"嘀咕广场API调用失败: %@", error);
        // 结束刷新
        //        [control endRefreshing];
        
    }];
}

#pragma mark - DetailHeader Delegate
-(void)detailHeader:(DPDetailHeader *)header btnClick:(DetailHeaderBtnType)index
{
    //先刷新表格（马上显示对应数据，避免数据迟缓）
    [self.tableView reloadData];
    
    if (index == DetailHeaderBtnTypeApply) { //点击了回应按钮
        //
        NSLog(@"加载回应");
        [self loadNewApply];
        
        
    }else if (index == DetailHeaderBtnTypeCollection) { //点击了收藏按钮
        //
        NSLog(@"收藏");
        [self loadNewCollection];
    } else { // 点击了点赞按钮
        //
        NSLog(@"点赞");
        [self loadNewAttitude];
    }
}

#pragma mark - DPDetailToolBar Delegate
- (void)detailToolBar:(DPDetailToolBar *)toolBar didClickButton:(DPDetailToolBarButtonType)buttonType {
    
    switch (buttonType) {
        case DPDetailToolBarButtonTypeAltitude:
            NSLog(@"点赞");
            break;
        
        case DPDetailToolBarButtonTypeCollection:
            NSLog(@"收藏");
            break;
            
        case DPDetailToolBarButtonTypeApply:
            NSLog(@"回应");
            // 跳转到回应发送控制器
            DPApplyViewController *apply = [[DPApplyViewController alloc] init];
            apply.status = self.status;
            [self.navigationController pushViewController:apply animated:YES];
            break;
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    
//    [self.toolBar removeFromSuperview];
    self.toolBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.toolBar.hidden = NO;
}

//- (void)dealloc {
//    
//    [self.toolBar removeFromSuperview];
//}

@end
