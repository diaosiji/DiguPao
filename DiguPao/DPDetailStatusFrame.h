//
//  DPDetailStatusFrame.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/11.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  一个DPDetailStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.cell高度
//  3.数据模型DGStatus

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DPStatus;

@interface DPDetailStatusFrame : NSObject

// 数据模型
@property (nonatomic,strong) DPStatus *status;

/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic,assign) CGRect originalViewFrame;
/** 头像 */
@property (nonatomic,assign) CGRect iconViewFrame;
/** 配图 */
@property (nonatomic,assign) CGRect photosViewFrame;
/** 昵称 */
@property (nonatomic,assign) CGRect nameLabelFrame;
/** 时间 */
@property (nonatomic,assign) CGRect timeLabelFrame;
/** 正文 */
@property (nonatomic,assign) CGRect contentLabelFrame;
/** Cell的高度 */
@property (nonatomic,assign) CGFloat cellHeight;

@end
