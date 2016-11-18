//
//  DPComposeAlbumView.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/18.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  用于显示在发送页面的选取的图片的相册

#import <UIKit/UIKit.h>

@interface DPComposeAlbumView : UIView

// 添加图片到相册
- (void)addPhoto:(UIImage*)photo;
// 返回被选中的图像数组
- (NSArray *)photos;

@end
