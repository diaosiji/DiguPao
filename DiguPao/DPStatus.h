//
//  DPStatus.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DPUser;

@interface DPStatus : NSObject

/** NSString 嘀咕的id字符串 */
@property (nonatomic, copy) NSString *idstr;

/** NSString 嘀咕的文本内容 */
@property (nonatomic, copy) NSString *text;

/** NSString 嘀咕的纬度 */
@property (nonatomic, copy) NSString *latitude;

/** NSString 嘀咕的经度 */
@property (nonatomic, copy) NSString *longitude;

/** NSString 嘀咕的创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** DPUser 嘀咕的作者的详细字段 */
@property (nonatomic, strong) DPUser *user;

/** 微博配图地址 多图返回多rul 无图返回[] */
@property (nonatomic, strong) NSArray *pic_urls;


/**         服务器尚未提供       **/

/** 被转发的原微博信息字段 */
//@property (nonatomic, strong) DPStatus *retweeted_status;

/** int 转发数 */
//@property (nonatomic, assign) int reposts_count;

/** int 评论数 */
//@property (nonatomic, assign) int comments_count;

/** int 点赞数 */
//@property (nonatomic, assign) int attitudes_count;

@end
