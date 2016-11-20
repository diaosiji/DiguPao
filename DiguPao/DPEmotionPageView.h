//
//  DPEmotionPageView.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  scrollView里用来表示一页的表情（里面显示1-20个表情）的控件

#import <UIKit/UIKit.h>

@interface DPEmotionPageView : UIView
/** NSArray 该页显示的表情 里面都是DPEmotion模型 */
@property (nonatomic, strong) NSArray *emotionsInPage;
@end
