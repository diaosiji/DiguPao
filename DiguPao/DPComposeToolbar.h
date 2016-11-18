//
//  DPComposeToolbar.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/17.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  发微博界面的工具条

#import <UIKit/UIKit.h>

// 用枚举来表示工具条上的按钮类型
typedef enum {
    
    DPComposeToolBarButtonTypeCamera, //拍照
    DPComposeToolBarButtonTypePicture, //相册
    DPComposeToolBarButtonTypeMention, //@
    DPComposeToolBarButtonTypeTrend, //#
    DPComposeToolBarButtonTypeEmotion, //表情
    
} DPComposeToolBarButtonType;

@class DPComposeToolbar;

@protocol DPComposeToolBarDelegate <NSObject>

@optional
- (void)composeToolBar:(DPComposeToolbar *)toolBar didClickButton:(DPComposeToolBarButtonType)buttonType;
@end

@interface DPComposeToolbar : UIView
@property (nonatomic, weak) id<DPComposeToolBarDelegate> delegate;
/** 表情按钮图标在表情和键盘之间切换 */
@property (nonatomic, assign) BOOL showEmotionButton;



@end
