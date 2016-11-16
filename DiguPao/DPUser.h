//
//  DPUser.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPUser : NSObject
/** NSString 艺术家ID */
@property (nonatomic, copy) NSString *artistId;
/** NSString 艺术家姓名 */
@property (nonatomic, copy) NSString *artistName;
/** NSString 艺术家头像url */
@property (nonatomic, copy) NSString *artworkUrl100;
/** NSString 专辑价格 */
@property (nonatomic, copy) NSString *collectionPrice;


@end
