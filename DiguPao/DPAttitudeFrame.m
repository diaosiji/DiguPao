//
//  DPAttitudeFrame.m
//  DiguPao
//
//  Created by 屌斯基 on 2017/1/2.
//  Copyright © 2017年 intelligentunit. All rights reserved.
//

#import "DPAttitudeFrame.h"
#import "DPUser.h"
#import "DPAttitude.h"

// Cell的边框宽度
#define DPStatusCellBorderWidth 10
#define DPStatusCellInnerBorderWidth 5

@implementation DPAttitudeFrame

// 字符串根据字体得到size的方法 宽度限制
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = font;
    // 高度不限制
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    //
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}

// 字符串根据字体得到size的方法 宽度不限制
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font {
    
    // 宽度不限制
    return [self sizeWithText:text font:font maxWidth:MAXFLOAT];
}

- (void)setAttitude:(DPAttitude *)attitude {
    _attitude =  attitude;
    DPUser *user = attitude.user;
    
    // 从左上角开始算frame
    /** 头像 */
    CGFloat iconWH = 40;
    CGFloat iconX = DPStatusCellBorderWidth;
    CGFloat iconY = DPStatusCellBorderWidth;
    self.iconViewFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    // 昵称的x应试头像最右侧加上间距
    CGFloat nameX = CGRectGetMaxX(self.iconViewFrame) + DPStatusCellBorderWidth;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:[UIFont systemFontOfSize:15]];
    self.nameLabelFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    /** 时间 */
    // 时间的y是昵称的下边沿加间距
    CGFloat timeY = CGRectGetMaxY(self.nameLabelFrame) + DPStatusCellInnerBorderWidth;
    // 时间的x是昵称的x
    CGFloat timeX = nameX;
    CGSize timeSize = [self sizeWithText:attitude.created_at font:[UIFont systemFontOfSize:12]];
    self.timeLabelFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    /** Cell高度是最后算的 */
    // 加一个间距是为了让Cell之间有间隔的效果
    // 昵称加时间都不及头像高
    self.cellHeight = CGRectGetMaxY(self.iconViewFrame) + DPStatusCellBorderWidth; 
}

@end
























