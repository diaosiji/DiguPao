//
//  DPCollectionCell.h
//  DiguPao
//
//  Created by 屌斯基 on 2017/1/1.
//  Copyright © 2017年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPCollectionFrame;

@interface DPCollectionCell : UITableViewCell

// 布局模型（包含了数据模型）
@property (nonatomic,strong) DPCollectionFrame *collectionFrame;

// 返回Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
