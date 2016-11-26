//
//  DPUser.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPUser : NSObject

/** string 字符串类型的uid */
@property (nonatomic, copy) NSString *idstr;

/** string 用户昵称 */
@property (nonatomic, copy) NSString *name;

// 尚未提供
/** string 50pt的用户头像地址 */
//@property (nonatomic, copy) NSString *profile_image_url;

/** string 用户手机 */
@property (nonatomic, copy) NSString *phone;

/** string 用户创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** string 用户的email */
@property (nonatomic, copy) NSString *email;



@end
