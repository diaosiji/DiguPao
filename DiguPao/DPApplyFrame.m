//
//  DPApplyFrame.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/31.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPApplyFrame.h"
#import "DPUser.h"
#import "DPApply.h"

// Cell的边框宽度
#define DPStatusCellBorderWidth 10
#define DPStatusCellInnerBorderWidth 5

@implementation DPApplyFrame

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

- (void)setApply:(DPApply *)apply {
    
    _apply = apply;
    DPUser *user = apply.user;
    
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
    CGSize timeSize = [self sizeWithText:apply.created_at font:[UIFont systemFontOfSize:12]];
    self.timeLabelFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    /** 正文 */
    CGFloat contentX = iconX;
    // y值取头像和时间标签中比较靠下那个加编剧
    //    CGFloat contentY = MAX(CGRectGetMaxY(self.timeLabelFrame), CGRectGetMaxY(self.iconViewFrame)) + DPStatusCellBorderWidth; // 微博设计
    CGFloat contentY = CGRectGetMaxY(self.timeLabelFrame) + DPStatusCellInnerBorderWidth; // 王小崽设计
    // 对照图片仔细算
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 2 * DPStatusCellBorderWidth; // 微博正文是和屏幕几乎等宽
    
    CGSize contentSize = [self sizeWithText:apply.text font:[UIFont systemFontOfSize:14] maxWidth:maxWidth];
    self.contentLabelFrame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    /** Cell高度是最后算的 */
    // 加一个间距是为了让Cell之间有间隔的效果
    self.cellHeight = CGRectGetMaxY(self.contentLabelFrame) + DPStatusCellBorderWidth; // 暂时

}

@end



















