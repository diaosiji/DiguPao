//
//  DPAttitudeFrame.h
//  DiguPao
//
//  Created by 屌斯基 on 2017/1/2.
//  Copyright © 2017年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DPAttitude;

@interface DPAttitudeFrame : NSObject

@property (nonatomic, strong) DPAttitude *attitude;

/** 点赞用户显示整体 */
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
