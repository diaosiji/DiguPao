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

@interface DPStatusDetailController () <DPDetailHeaderDelegate, DPDetailToolBarDelegate>

{
    DPDetailHeader *_detailHeader;
}

@property (nonatomic, strong) DPDetailStatusFrame *detailStatusFrame;
/** DPDetailHeader 第二个section的自定义控件 */
//@property (nonatomic, weak) DPDetailHeader *detailHeader;

/** 顶部工具条 */
@property (nonatomic, weak) DPDetailToolBar *toolBar;


@end

@implementation DPStatusDetailController

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
    
    // 初始header点击回应
    [self detailHeader:_detailHeader btnClick:DetailHeaderBtnTypeApply];
    

    

    
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
    }/*else if (_detailHeader.currentType == kDetailHeaderBtnTypeRepost) {
      return _repostFrames.count;
      }else{
      return _commentFrames.count;
      }*/
    else{
        return 20;
    }
}

#pragma mark NO.4 indexPath这行的cell有多高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        NSLog(@"detailStatus高度:%f", self.detailStatusFrame.cellHeight);
        return self.detailStatusFrame.cellHeight;
    }/*else if (_detailHeader.currentType == kDetailHeaderBtnTypeRepost) {
      return [_repostFrames[indexPath.row] cellHeight];
      }else{
      return [_commentFrames[indexPath.row] cellHeight];
      }*/
    else{
//        return [[self currentFrames][indexPath.row] cellHeight];
        return 44;
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
        
    } else {
        // 第二个section中情况暂时不管
        static NSString *cellIdentifier = @"detailCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        cell.textLabel.text = [NSString stringWithFormat:@"测试第%ld行", (long)indexPath.row];
        
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

#pragma mark - DetailHeader Delegate
-(void)detailHeader:(DPDetailHeader *)header btnClick:(DetailHeaderBtnType)index
{
    //先刷新表格（马上显示对应数据，避免数据迟缓）
    [self.tableView reloadData];
    
    if (index == DetailHeaderBtnTypeApply) { //点击了回应按钮
        //
        NSLog(@"回应");
    }else if (index == DetailHeaderBtnTypeCollection) { //点击了收藏按钮
        //
        NSLog(@"收藏");
    } else { // 点击了点赞按钮
        //
        NSLog(@"点赞");
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
    
    [self.toolBar removeFromSuperview];
}

//- (void)dealloc {
//    
//    [self.toolBar removeFromSuperview];
//}

@end
