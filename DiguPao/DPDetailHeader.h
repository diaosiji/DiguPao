//
//  DPDetailHeader.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPDetailHeader;

// 枚举按钮类型
typedef enum {
    DetailHeaderBtnTypeApply, //回应
    DetailHeaderBtnTypeCollection, //收藏
    DetailHeaderBtnTypeAttitude //点赞
}DetailHeaderBtnType;

// 代理方法
@protocol DPDetailHeaderDelegate <NSObject>

@optional
/** 代理Header按钮点击方法 */
- (void)detailHeader:(DPDetailHeader *)header btnClick:(DetailHeaderBtnType)index;

@end

@interface DPDetailHeader : UIImageView

/** UIImageView 提示三角 */
@property (weak, nonatomic) IBOutlet UIImageView *hint;
/** UIButton 显示回应按钮 */
@property (weak, nonatomic) IBOutlet UIButton *apply;
/** UIButton 显示收藏人按钮 */
@property (weak, nonatomic) IBOutlet UIButton *collection;
/** UIButton 显示点赞人按钮 */
@property (weak, nonatomic) IBOutlet UIButton *attitude;
/** DetailHeaderBtnType枚举 当前用户选择的按钮类型 */
@property (nonatomic, assign, readonly)DetailHeaderBtnType currentType;
/** DPDetailHeaderDelegate 代理 */
@property (nonatomic, weak)id<DPDetailHeaderDelegate> delegate;

/** 返回cell对象 */
+ (instancetype)header;
/** 点击按钮方法 3个按钮都触发 */
- (IBAction)btnClick:(UIButton *)sender;

@end









