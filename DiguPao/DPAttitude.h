//
//  DPAttitude.h
//  DiguPao
//
//  Created by 屌斯基 on 2017/1/2.
//  Copyright © 2017年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DPUser;

@interface DPAttitude : NSObject
/** NSString 收藏的id字符串 ?实际设计的时候可能不需要 使用广场API测试需要 */
@property (nonatomic, copy) NSString *idstr;

/** NSString 收藏的创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** DPUser 用户的详细字段 */
@property (nonatomic, strong) DPUser *user;
@end
