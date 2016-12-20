//
//  DPStatusPhotosView.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPStatusPhotosView.h"
#import "DPPhoto.h"
#import "DPStatusPhotoView.h"

#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#define DPStatusPhotoWH 70
#define DPStatusPhotoMargin 10
// 巧妙地定义了最大列数
#define DPStatusPhotoMaxCol(count) ((count == 4)?2:3)


@implementation DPStatusPhotosView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    int photoCount = (int)photos.count;
    // 创建缺少的imageView
    while (self.subviews.count < photoCount) {
        DPStatusPhotoView *photoView = [[DPStatusPhotoView alloc] init];
        //添加手势到每个photoView
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusPhotoOnTap:)];
        [photoView addGestureRecognizer:gestureRecognizer];
        
        [self addSubview:photoView];
    }
    // 遍历图片控件 设置图片
    for (int i = 0; i < self.subviews.count; i++) {
        DPStatusPhotoView *photoView = self.subviews[i];
        // 添加tag
        photoView.tag = i;
        
        if (i < photoCount) {
            photoView.photo = photos[i];
            photoView.hidden = NO;
            
        } else {
            photoView.hidden = YES;
        }
    }
    
}

- (void)statusPhotoOnTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"statusPhotoOnTap");
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    int count = (int)self.photos.count;
    for (int i = 0; i <count; i++){
        DPPhoto *pic = [[DPPhoto alloc] init];
        pic = self.photos[i];
        // 之前出错主要就是错误认为self.photos里面是url 其实是DGPhoto对象
        //DGLog(@"%@",self.photos[i]);
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", pic.bmiddle_pic]];
        //设置来源于哪一个UIImageView
        photo.srcImageView = self.subviews[i];
        
        [photos addObject:photo];
    }
    
    browser.photos = photos;
    
    // 3.设置默认显示的图片索引
    browser.currentPhotoIndex = recognizer.view.tag;
    
    // 4.显示浏览器
    [browser show];
    
}

+ (CGSize)SizeWithCount:(int)count {
    // 最大列数
    int maxCols = DPStatusPhotoMaxCol(count);
    // 列数
    int cols = (count >= maxCols) ? maxCols : count;
    CGFloat photosWidth = cols * DPStatusPhotoWH + (cols - 1) * DPStatusPhotoMargin;
    
    // 行数
    int rows = (count + maxCols - 1) / maxCols;
    CGFloat photosHeight = rows * DPStatusPhotoWH + (rows - 1) * DPStatusPhotoMargin;
    
    return CGSizeMake(photosWidth, photosHeight);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    // 设置图片和尺寸
    int photosCount = (int)self.photos.count;
    int maxCol = DPStatusPhotoMaxCol(photosCount);
    for (int i = 0; i < photosCount; i++) {
        DPStatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (DPStatusPhotoWH + DPStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (DPStatusPhotoWH + DPStatusPhotoMargin);
        photoView.width = DPStatusPhotoWH;
        photoView.height = DPStatusPhotoWH;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
