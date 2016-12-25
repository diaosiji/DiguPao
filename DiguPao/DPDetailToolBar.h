//
//  DPDetailToolBar.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/21.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import <UIKit/UIKit.h>

// 用枚举来表示工具条上的按钮类型
typedef enum {
    
    DPDetailToolBarButtonTypeApply, //回应
    DPDetailToolBarButtonTypeCollection, //收藏
    DPDetailToolBarButtonTypeAltitude, //点赞
    
    
} DPDetailToolBarButtonType;

@class DPDetailToolBar;

@protocol DPDetailToolBarDelegate <NSObject>

@optional
- (void)detailToolBar:(DPDetailToolBar *)toolBar didClickButton:(DPDetailToolBarButtonType)buttonType;

@end

@interface DPDetailToolBar : UIView

@property (nonatomic, weak) id<DPDetailToolBarDelegate> delegate;

@end
