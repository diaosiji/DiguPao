//
//  DPStatusCell.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/27.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPStatusCell.h"
#import "DPStatus.h"
#import "DPStatusFrame.h"
#import "DPUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DPStatusToolbar.h"
#import "DPStatusPhotosView.h"
#import "DPIconView.h"


@interface DPStatusCell()
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) DPIconView *iconView;
/** 会员图标 */
//@property (nonatomic, weak) UIImageView *vipView;

/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
//@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 配图 */
@property (nonatomic, weak) DPStatusPhotosView *photosView;

/* 转发微博 */
/** 转发微博整体 */
//@property (nonatomic, weak) UIView *retweetlView;
///** 转发配图 */
//@property (nonatomic, weak) DGStatusPhotosView *retweetPhotosView;
///** 转发正文 */
//@property (nonatomic, weak) UILabel *retweetContentLabel;
//

/* 工具条 */
@property (nonatomic, weak) DPStatusToolbar *toolBar;

@end

@implementation DPStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"status";
    DPStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DPStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        
        
        // 初始化工具条
        [self setupToolbar];

    }
    return self;
}

// 初始化工具条
- (void)setupToolbar {
    
    DPStatusToolbar *toolbar = [DPStatusToolbar toolbar];
    
    [self.contentView addSubview:toolbar];
    self.toolBar = toolbar;
}

// 初始化原创微博
- (void)setupOriginal {
    
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    DPIconView *iconView = [[DPIconView alloc] init];
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

-(void)setStatusFrame:(DPStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    // 取出数据
    DPStatus *status = statusFrame.status;
    DPUser *user = status.user;
    
    // 整体
    self.originalView.frame = statusFrame.originalViewFrame;
    // 头像
    self.iconView.frame = statusFrame.iconViewFrame;
    self.iconView.user = user;
    // 句实现圆形头像
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width / 2;
    
    // 昵称
    self.nameLabel.frame = statusFrame.nameLabelFrame;
    self.nameLabel.text = user.name;
    // 创建时间
    self.timeLabel.frame = statusFrame.timeLabelFrame;
    self.timeLabel.text = status.created_at;
    NSLog(@"%@", status.created_at);
    // 正文
    self.contentLabel.frame = statusFrame.contentLabelFrame;
    self.contentLabel.text = status.text;
    // 配图
    if (status.pictures.count) {
        
        self.photosView.frame = statusFrame.photosViewFrame;
        self.photosView.photos = status.pictures;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    // 工具条
    self.toolBar.frame = statusFrame.toolbarFrame;
    
    
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
