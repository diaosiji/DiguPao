//
//  DPUserInfoViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/22.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPUserInfoViewController.h"
#import "LGSettingItem.h"
#import "LGSettingSection.h"
#import "DPChangeNameViewController.h"
#import "DPIconView.h"

@interface DPUserInfoViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSMutableArray * groups;

/** LGSettingItem 头像信息显示Cell */
@property (nonatomic, weak) LGSettingItem *iconItem;

@end

@implementation DPUserInfoViewController

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

- (instancetype)init{
    // 设置样式
    return [self initWithStyle:UITableViewStyleGrouped];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //添加第一组
    LGSettingSection *section1 = [LGSettingSection initWithHeaderTitle:nil footerTitle:nil];
    //添加行

    LGSettingItem *item1 = [[LGSettingItem alloc] init];
    
    item1.height = 88;
    item1.type = UITableViewCellAccessoryDisclosureIndicator;
    self.iconItem = item1;
    [section1 addItem:item1];
    
    LGSettingItem *item2 = [LGSettingItem initWithtitle:self.myInfo.name];
    [section1 addItem:item2];
    
    LGSettingItem *item3 = [LGSettingItem initWithtitle:@"个性签名"];
    [section1 addItem:item3];
    
    
    //保存到groups数组
    [self.groups addObject:section1];
    
    //添加第二组
    LGSettingSection *section2 = [LGSettingSection initWithHeaderTitle:nil footerTitle:nil];
    //添加行
    LGSettingItem *item21 = [LGSettingItem initWithtitle:@"性别"];
    [section2 addItem:item21];
    
    LGSettingItem *item22 = [LGSettingItem initWithtitle:@"爱好"];
    [section2 addItem:item22];
    
    
    //保存到groups数组
    [self.groups addObject:section2];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 从手机相册选择图片的操作，见下文步骤5
            //初始化UIImagePickerController
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
            //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
            //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
            PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //允许编辑，即放大裁剪
            PickerImage.allowsEditing = YES;
            //自代理
            PickerImage.delegate = self;
            //页面跳转
            [self presentViewController:PickerImage animated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 拍照操作，见下文下文步骤5
            //初始化UIImagePickerController
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
            //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
            //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
            PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            //允许编辑，即放大裁剪
            PickerImage.allowsEditing = YES;
            //自代理
            PickerImage.delegate = self;
            //页面跳转
            [self presentViewController:PickerImage animated:YES completion:nil];

            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        DPChangeNameViewController *change = [[DPChangeNameViewController alloc] init];
        change.name = self.myInfo.name;
        [self.navigationController pushViewController:change animated:YES];
    }
    NSLog(@"点击了第%ld组,第%ld行",indexPath.section,indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //把newPhono设置成头像
    self.iconItem.image = newPhoto;
    [self.tableView reloadData];
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"picker didFinishPickingMediaWithInfo");
}

- (void)loadIcon {

    DPIconView *iconView = [[DPIconView alloc] init];
    iconView.user = self.myInfo;
    self.iconItem.image = iconView.image;
    
    [self.tableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self loadIcon];
}

@end
