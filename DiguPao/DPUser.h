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

/** string 用户头像url */
@property (nonatomic, copy) NSString *avatar;

/** string 用户手机 */
@property (nonatomic, copy) NSString *phone;

/** string 用户创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** string 用户的email */
@property (nonatomic, copy) NSString *email;



@end
