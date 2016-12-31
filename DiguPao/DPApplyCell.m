//
//  DPApplyCell.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/31.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPApplyCell.h"
#import "DPApply.h"
#import "DPApplyFrame.h"
#import "DPUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DPIconView.h"

@interface DPApplyCell()

/** 回应整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) DPIconView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation DPApplyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"apply";
    DPApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DPApplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    DPIconView *iconView = [[DPIconView alloc] init];
    [self.originalView addSubview:iconView];
    self.iconView = iconView;
    
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

- (void)setApplyFrame:(DPApplyFrame *)applyFrame {
    
    _applyFrame = applyFrame;
    // 取出数据
    DPApply *apply = applyFrame.apply;
    DPUser *user = apply.user;
    
    // 整体
    self.originalView.frame = applyFrame.originalViewFrame;
    // 头像
    self.iconView.frame = applyFrame.iconViewFrame;
    self.iconView.user = user;
    // 句实现圆形头像
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width / 2;
    
    // 昵称
    self.nameLabel.frame = applyFrame.nameLabelFrame;
    self.nameLabel.text = user.name;
    // 创建时间
    self.timeLabel.frame = applyFrame.timeLabelFrame;
    self.timeLabel.text = apply.created_at;
    // 正文
    self.contentLabel.frame = applyFrame.contentLabelFrame;
    self.contentLabel.text = apply.text;
    
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
