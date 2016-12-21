//
//  DPPhoto.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPPhoto : NSObject

/** string 缩略图url */
@property (nonatomic, copy) NSString *thumbnail_pic;
/** string 中等大小图url */
@property (nonatomic, copy) NSString *bmiddle_pic;

@end
