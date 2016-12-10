//
//  DPStatusDetailController.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPStatus;

@interface DPStatusDetailController : UITableViewController

// 存放Home中被点击的嘀咕的数据模型
@property (nonatomic, strong)DPStatus *status;

@end
