//
//  DPPhoto.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPPhoto.h"

@implementation DPPhoto
/*pic_ids中的地址都是缩略图地址：比如：
 http://ww2.sinaimg.cn/thumbnail/005AywYdgw1f1mvobdt5cj30ku1120wt.jpg
 只需要把其中的thumbnail替换为bmiddle，或者original，就能得到更大尺寸的图片。如果没有，就返回没有*/
//- (void)setBmiddle_pic:(NSString *)bmiddle_pic {
//    _bmiddle_pic = self.thumbnail_pic;
//    // 正则表达式
//    // 截取字符串
////    NSRange range;
////    range.location = [source rangeOfString:@">"].location + 1;
////    range.length = [source rangeOfString:@"</"].location - range.location;
////    _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
//    //例子string=[string stringByReplacingOccurrencesOfString:@"-"withString:@"/"];
//    _bmiddle_pic = [_bmiddle_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//}

- (NSString *)bmiddle_pic {
    
    NSString *string = self.thumbnail_pic;
    return [string stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}

@end
