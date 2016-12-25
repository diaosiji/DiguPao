//
//  LGSettingViewController.m
//  LGSettingViewDemo
//
//  Created by LiGo on 11/16/15.
//  Copyright © 2015 LiGo. All rights reserved.
//
//
#import "LGSettingViewController.h"
#import "LGSettingItem.h"
#import "LGSettingSection.h"
#import "DPUser.h"
#import "UIImageView+WebCache.h"
#import <AFNetworking/AFNetworking.h>
#import "AFOAuth2Manager.h"
#import "DPUserInfoViewController.h"
#import "MJExtension.h"
#import "DPLoginViewController.h"
#import "KeyChain.h"
#import "DPIconView.h"


@interface LGSettingViewController ()
@property (strong, nonatomic) NSMutableArray * groups;

/** DPUser 用户信息模型 */
@property (nonatomic, strong) DPUser *myInfo;

/** LGSettingItem 用户信息显示Cell */
@property (nonatomic, weak) LGSettingItem *infoItem;

@end

//// 用作字典中键值
//NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
//NSString * const KEY_USERNAME = @"com.company.app.username";
//NSString * const KEY_PASSWORD = @"com.company.app.password";

@implementation LGSettingViewController

/**
 数组懒加载
 */
- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (DPUser *)myInfo {
    if (!_myInfo) {
        _myInfo = [[DPUser alloc] init];
    }
    return _myInfo;
}

- (instancetype)init{
    // 设置样式
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getUserInfomation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 首先通过网络得到个人信息模型
//    [self getUserInfomation];
    
    //添加第一组
    LGSettingSection *section1 = [LGSettingSection initWithHeaderTitle:nil footerTitle:nil];
    //添加行
    LGSettingItem *item1 = [LGSettingItem initWithtitle:@""];
    item1.height = 88;
    self.infoItem = item1;
    [section1 addItem:item1];
    //保存到groups数组
    [self.groups addObject:section1];
    
    //添加第二组
    LGSettingSection *section2 = [LGSettingSection initWithHeaderTitle:nil footerTitle:nil];
    //添加行
    LGSettingItem *item21 = [LGSettingItem initWithtitle:@"历史信息"];
    item21.image = [UIImage imageNamed:@"album"];
    [section2 addItem:item21];
    
    LGSettingItem *item22 = [LGSettingItem initWithtitle:@"我的关注"];
    item22.image = [UIImage imageNamed:@"new_friend"];
    [section2 addItem:item22];
    
    LGSettingItem *item23 = [LGSettingItem initWithtitle:@"关注我的"];
    item23.image = [UIImage imageNamed:@"new_friend"];
    [section2 addItem:item23];
    
    LGSettingItem *item24 = [LGSettingItem initWithtitle:@"我的收藏"];
    item24.image = [UIImage imageNamed:@"collect"];
    [section2 addItem:item24];
    
    LGSettingItem *item25 = [LGSettingItem initWithtitle:@"隐私设置"];
    item25.image = [UIImage imageNamed:@"draft"];
    [section2 addItem:item25];
    
    //保存到groups数组
    [self.groups addObject:section2];
    
    //添加第三组
    LGSettingSection *section3 = [LGSettingSection initWithHeaderTitle:nil footerTitle:nil];
    //添加行
    LGSettingItem *item31 = [LGSettingItem initWithtitle:@"推出登录"];
    item31.image = [UIImage imageNamed:@"like"];
    [section3 addItem:item31];
    //保存到groups数组
    [self.groups addObject:section3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfomation {
    // 获取含accessToken的凭证对象
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    // 暂时先用iTunes的API代替
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
    
    [manager GET:@"/api/v1/users/me" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"LGSettingViewController userInfo:%@", responseObject);
        
        DPUser *myInfo = [DPUser mj_objectWithKeyValues:responseObject];
        self.myInfo = myInfo;
        self.infoItem.title = self.myInfo.name;
        
        DPIconView *iconView = [[DPIconView alloc] init];
        iconView.user = self.myInfo;
        self.infoItem.image = iconView.image;
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"LGSettingViewController userInfo error");
    }];
}


#pragma mark - Table view data source
/**
 设置组数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}
/**
 设置行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LGSettingSection *group = self.groups[section];
    return group.items.count;
}

/**
 设置每行内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    LGSettingSection *section = self.groups[indexPath.section];
    LGSettingItem *item = section.items[indexPath.row];
    // 设置Cell的标题
    cell.textLabel.text = item.title;
    // 设置Cell左边的图标
#warning 修改
    cell.imageView.image = item.image;
    // 设置Cell右边的图标
    cell.accessoryType = item.type;
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    LGSettingSection *group = self.groups[section];
    return group.headerTitle;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    LGSettingSection *group = self.groups[section];
    return group.footerTitle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LGSettingSection *section = self.groups[indexPath.section];
    LGSettingItem *item = section.items[indexPath.row];
    return item.height;
}


#pragma mark 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //添加点击事件
        DPUserInfoViewController *userInfo = [[DPUserInfoViewController alloc] init];
        userInfo.title = @"修改信息";
        userInfo.myInfo = self.myInfo;
        [self.navigationController pushViewController:userInfo animated:YES];
    }
    NSLog(@"点击了第%ld组,第%ld行",indexPath.section,indexPath.row);
    
    if (indexPath.section == 2 && indexPath.row == 0) {

        DPLoginViewController *login = [[DPLoginViewController alloc] init];
        
        // 将用户名和密码从keychain中删除
        [KeyChain delete:@"com.company.app.usernamepassword"];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = login;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 
 */

@end
