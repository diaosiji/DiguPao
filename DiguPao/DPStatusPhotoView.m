//
//  DPStatusPhotoView.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPStatusPhotoView.h"
#import "DPPhoto.h"
#import "UIImageView+WebCache.h"

@implementation DPStatusPhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setPhoto:(DPPhoto *)photo {
    
    _photo = photo;
    // 设置图片
//    NSLog(@"setPhoto url:%@", photo.url);
    NSString *small_url = [NSString stringWithFormat:@"%@!small", photo.url];
//    NSLog(@"setPhoto small_url:%@", small_url);
    [self sd_setImageWithURL:[NSURL URLWithString:small_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    // 根据后缀扩展名显示或者隐藏gif控件
    //self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 内容模式
        //        UIViewContentModeScaleToFill,
        //        UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
        //        UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
        //        UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
        //        UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
        //        UIViewContentModeTop,
        //        UIViewContentModeBottom,
        //        UIViewContentModeLeft,
        //        UIViewContentModeRight,
        //        UIViewContentModeTopLeft,
        //        UIViewContentModeTopRight,
        //        UIViewContentModeBottomLeft,
        //        UIViewContentModeBottomRight,
        // 经验规律
        // 凡是带有Scale的，都会拉伸
        // 凡是带有Aspect，都会保持宽高比
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //self.gifView.x = self.width - self.gifView.width;
    //self.gifView.y = self.height - self.gifView.height;
}

@end
