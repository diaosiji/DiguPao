//
//  DPComposeAlbumView.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/18.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPComposeAlbumView.h"
#import "UIView+Extension.h"

@interface DPComposeAlbumView()
// View中的图片的数组
@property (nonatomic, strong) NSMutableArray *addedPhotos;

@end

@implementation DPComposeAlbumView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)addPhoto:(UIImage *)photo {
    
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [self addSubview:photoView];
    // 存储图片
    [self.addedPhotos addObject:photo];

}

// 排列图片
- (void)layoutSubviews {
    
    [super layoutSubviews];
    // 设置图片和尺寸
    int count = (int)self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    
    for (int i = 0; i < count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (imageWH + imageMargin);
        
        int row = i / maxCol;
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
    
}

// 返回相册中的图片
- (NSArray *)photos {
    
    return self.addedPhotos;
}


@end
