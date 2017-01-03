//
//  DPAttitudeCell.h
//  DiguPao
//
//  Created by 屌斯基 on 2017/1/2.
//  Copyright © 2017年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPAttitudeFrame;

@interface DPAttitudeCell : UITableViewCell

@property (nonatomic, strong) DPAttitudeFrame *attitudeFrame;

// 返回Cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
