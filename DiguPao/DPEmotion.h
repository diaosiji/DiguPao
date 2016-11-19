//
//  DPEmotion.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/19.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPEmotion : NSObject
/** NSString 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** NSString 表情的图片名 */
@property (nonatomic, copy) NSString *png;
/** NSString emoji表情的16进制编码 */
@property (nonatomic, copy) NSString *code;

@end
