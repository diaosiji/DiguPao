//
//  DPTextViw.h
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/17.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  带有占位文字的TextView

#import <UIKit/UIKit.h>

@interface DPTextViw : UITextView
/** NSString 占位符文字 */
@property (nonatomic, copy) NSString *placeholder;
/** UIColor 占位符文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
