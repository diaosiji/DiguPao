//
//  DPStatusFrame.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/27.
//  Copyright © 2016年 intelligentunit. All rights reserved.

#import "DPStatusFrame.h"
#import "DPUser.h"
#import "DPStatus.h"
#import "DPStatusToolbar.h"
#import "DPStatusPhotosView.h"

// Cell的边框宽度
#define DPStatusCellBorderWidth 10
#define DPStatusCellInnerBorderWidth 5

@implementation DPStatusFrame

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

-(void)setStatus:(DPStatus *)status {
    
    _status = status;
    DPUser *user = status.user;
    
    // 从左上角开始算frame
    /** 头像 */
    CGFloat iconWH = 50;
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
    CGSize timeSize = [self sizeWithText:status.created_at font:[UIFont systemFontOfSize:12]];
    self.timeLabelFrame = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    /** 正文 */
    CGFloat contentX = nameX;
    // y值取头像和时间标签中比较靠下那个加编剧
//    CGFloat contentY = MAX(CGRectGetMaxY(self.timeLabelFrame), CGRectGetMaxY(self.iconViewFrame)) + DPStatusCellBorderWidth; // 微博设计
    CGFloat contentY = CGRectGetMaxY(self.timeLabelFrame) + DPStatusCellInnerBorderWidth; // 王小崽设计
    // 对照图片仔细算
//    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 2 * DPStatusCellBorderWidth; // 微博正文是和屏幕几乎等宽
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 3 * DPStatusCellBorderWidth - iconWH; // 王小崽的设计是文字左边和昵称对齐
    CGSize contentSize = [self sizeWithText:status.text font:[UIFont systemFontOfSize:14] maxWidth:maxWidth];
    self.contentLabelFrame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    
    /** 配图 */
    // 初始化原创微博整体的高度
    CGFloat originalHeight = 0;
    
    if (status.pic_urls.count) {//有配图
        
        CGFloat photosX = DPStatusCellBorderWidth;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelFrame) + DPStatusCellBorderWidth;
        
        CGSize photosSize = [DPStatusPhotosView SizeWithCount:(int)status.pic_urls.count];
        self.photosViewFrame = (CGRect){{photosX, photosY}, photosSize};
        //有配图时 原创微博整体的高度在配图下方加间距
        originalHeight = CGRectGetMaxY(self.photosViewFrame) + DPStatusCellBorderWidth;
    } else {
        //无配图时 原创微博整体的高度在正文内容下方加间距
        originalHeight = CGRectGetMaxY(self.contentLabelFrame) + DPStatusCellBorderWidth;
        
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.originalViewFrame = CGRectMake(originalX, originalY, originalWidth, originalHeight);
    
    /** 工具条 */
    CGFloat toolbarX = 0;
    // 工具条的Y值是原创整体的下沿
    CGFloat toolbarY = CGRectGetMaxY(self.originalViewFrame);
    CGFloat toolbarWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat toolbarHeight = 35; // 直接来
    self.toolbarFrame = CGRectMake(toolbarX, toolbarY, toolbarWidth, toolbarHeight);
    
    /** Cell高度是最后算的 */
    // 加一个间距是为了让Cell之间有间隔的效果
    self.cellHeight = CGRectGetMaxY(self.toolbarFrame) + DPStatusCellBorderWidth; // 暂时
    
}

@end














