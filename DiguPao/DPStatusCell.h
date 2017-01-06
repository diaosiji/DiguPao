//
//  DPStatusCell.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/27.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  自定义的Cell类 需要数据模型DPStatus和尺寸模型DPStatusFrame支持

#import <UIKit/UIKit.h>
#import "DPIconView.h"

@class DPStatusFrame;
//@class DPIconView;

@interface DPStatusCell : UITableViewCell

// 布局模型（包含了数据模型）
@property (nonatomic,strong) DPStatusFrame *statusFrame;

/** 头像 */
@property (nonatomic, weak) DPIconView *iconView;

// 返回Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
