//
//  DPStatus.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPStatus : NSObject

/** NSString 返回结果数 */
@property (nonatomic, strong) NSString *resultCount;
/** NSMutableArray 数组中装的是返回结果 */
@property (nonatomic, strong) NSMutableArray *results;

@end
