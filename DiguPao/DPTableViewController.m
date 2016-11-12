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

@interface DPTableViewController () <DPDropdownMenuDelegate>

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
    NSLog(@"left");
}

// 导航栏右边按钮点击方法
- (void)rightButtonTouched {
    NSLog(@"left");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DPDropdownMenuDelegate
- (void)dropdownMenuDidDismiss:(DPDropdownMenu *)menu {
    // 说明菜单已经被销毁了
    // 应该讲箭头倒过来
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
    
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    
}

- (void)dropdownMenuDidShow:(DPDropdownMenu *)menu {
    
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    
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
