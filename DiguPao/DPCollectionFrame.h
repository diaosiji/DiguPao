//
//  DPCollectionFrame.h
//  DiguPao
//
//  Created by 屌斯基 on 2017/1/1.
//  Copyright © 2017年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DPCollection;

@interface DPCollectionFrame : NSObject

// 数据模型
@property (nonatomic,strong) DPCollection *collection;

/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic,assign) CGRect originalViewFrame;
/** 头像 */
@property (nonatomic,assign) CGRect iconViewFrame;
/** 昵称 */
@property (nonatomic,assign) CGRect nameLabelFrame;
/** 时间 */
@property (nonatomic,assign) CGRect timeLabelFrame;
/** Cell的高度 */
@property (nonatomic,assign) CGFloat cellHeight;


@end
