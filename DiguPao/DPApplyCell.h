//
//  DPApplyCell.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/31.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPApplyFrame;

@interface DPApplyCell : UITableViewCell

// 布局模型（包含了数据模型）
@property (nonatomic,strong) DPApplyFrame *applyFrame;

// 返回Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
