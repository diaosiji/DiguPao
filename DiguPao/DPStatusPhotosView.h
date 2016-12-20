//
//  DPStatusPhotosView.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPStatusPhotosView : UIView

@property (nonatomic, strong) NSArray *photos;

// 根据图片个数计算相册尺寸
+ (CGSize)SizeWithCount:(int)count;

@end
