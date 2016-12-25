//
//  DPDetailStatusCell.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/11.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPDetailStatusCell.h"
#import "DPStatus.h"
#import "DPDetailStatusFrame.h"
#import "DPUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DPStatusPhotosView.h"

@interface DPDetailStatusCell ()
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
//@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) DPStatusPhotosView *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
//@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;

/* 转发微博 */
/** 转发微博整体 */
//@property (nonatomic, weak) UIView *retweetlView;
///** 转发配图 */
//@property (nonatomic, weak) DGStatusPhotosView *retweetPhotosView;
///** 转发正文 */
//@property (nonatomic, weak) UILabel *retweetContentLabel;
//

@end


@implementation DPDetailStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"detailStatus";
    DPDetailStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DPDetailStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
    
}

// cell的初始化方法 一个cell只会调用一次
// 一般在这里添加所有可能显示的子控件 及子控件的一次性设置
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 让整个cell透明 再让原创白色 转发灰色
        self.backgroundColor = [UIColor clearColor];
        // 点击不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 点击想要变成什么颜色用下面这个方法 但是要将style设为默认不能none
        //        UIView *selectedBackground = [[UIView alloc] init];
        //        selectedBackground.backgroundColor = [UIColor orangeColor];
        //        self.selectedBackgroundView = selectedBackground;
        
        // 初始化原创微博
        [self setupOriginal];
        
    }
    return self;
}

// 初始化原创微博
- (void)setupOriginal {
    
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 配图 */
    DPStatusPhotosView *photosView = [[DPStatusPhotosView alloc] init];
    [self.originalView addSubview:photosView];
    self.photosView = photosView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    // 字体要和DPStatusFrame中一致
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    // 字体要和DPStatusFrame中一致
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor orangeColor];
    [self.originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:14];
    // 设置为可换行
    contentLabel.numberOfLines = 0;
    [self.originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
}


- (void)setDetailStatusFrame:(DPDetailStatusFrame *)detailStatusFrame {
    _detailStatusFrame = detailStatusFrame;
    // 取出数据
    DPStatus *status = detailStatusFrame.status;
    DPUser *user = status.user;
    
    // 整体
    self.originalView.frame = detailStatusFrame.originalViewFrame;
    // 头像
    self.iconView.frame = detailStatusFrame.iconViewFrame;
    [self.iconView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    // 2句实现圆形头像
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width / 2;
    self.iconView.clipsToBounds = YES; // 是否按照尺寸裁剪多出边缘的图片
    // 昵称
    self.nameLabel.frame = detailStatusFrame.nameLabelFrame;
    self.nameLabel.text = user.name;
    // 创建时间
    self.timeLabel.frame = detailStatusFrame.timeLabelFrame;
    self.timeLabel.text = status.created_at;
//    NSLog(@"status.created_at %@", status.created_at);
    // 正文
    self.contentLabel.frame = detailStatusFrame.contentLabelFrame;
    self.contentLabel.text = status.text;
    // 配图
    if (status.pictures.count) {
        
        self.photosView.frame = detailStatusFrame.photosViewFrame;
        self.photosView.photos = status.pictures;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
