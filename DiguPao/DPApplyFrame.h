//
//  DPApplyFrame.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/31.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DPApply;

@interface DPApplyFrame : NSObject

// 数据模型
@property (nonatomic,strong) DPApply *apply;

/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic,assign) CGRect originalViewFrame;
/** 头像 */
@property (nonatomic,assign) CGRect iconViewFrame;
/** 昵称 */
@property (nonatomic,assign) CGRect nameLabelFrame;
/** 时间 */
@property (nonatomic,assign) CGRect timeLabelFrame;
/** 正文 */
@property (nonatomic,assign) CGRect contentLabelFrame;
/** Cell的高度 */
@property (nonatomic,assign) CGFloat cellHeight;

@end
