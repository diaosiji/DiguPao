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

@interface DPTableViewController ()

@end

@implementation DPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // 学习使用类来注册Cell 有了这句下面的cellForRowAtIndexPath才能正常运行
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testCell"];
    
    
    // 设置导航栏左边的按钮
    // 0.初始化一个自定义类型按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 1.设置backButton的图片
    [leftButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_friendsearch"] forState:UIControlStateNormal]; // 正常状态下的图片
    [leftButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted"] forState:UIControlStateHighlighted]; // 高亮状态下的图片
    // 2.设置backButton的尺寸（不设置尺寸不会显示）
    // 这里利用了UIView的分类十分方便
    // 让backButton的尺寸等于自身当前背景图片的尺寸
    leftButton.size = leftButton.currentBackgroundImage.size;
    // 3.向backButton添加动作方法
    //[leftButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
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
    //[rightButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    // 4.将backButton赋值给传进来的视图控制器导航栏左边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = @"text";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestViewController *test = [[TestViewController alloc] init];
    test.title = @"测试";
    // 跳转后隐藏底部的bar
    test.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:test animated:YES];
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

@end
