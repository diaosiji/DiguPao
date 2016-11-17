//
//  DPTextViw.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/17.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPTextViw.h"

@implementation DPTextViw


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // 通过通知来监听文字输入
        // 当UITextView文字发生改变时 UITextView自己会发出一个
        // UITextViewTextDidChangeNotification通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    };
    return self;
}

// 第一种实现方案
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 如果有文字就返回 实现输入了文字就擦掉占位符 文字没有就出现占位符
    if (self.hasText) return;
    
    // 设置文字属性
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    attribute[NSFontAttributeName] = self.font;
    // 设置了默认为灰色
    // 不设置默认 外部placeholderColor为空的时候回出错
    attribute[NSForegroundColorAttributeName]= self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    // 画文字
    CGFloat x = 5;
    CGFloat width = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat height = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, width, height);
    // 画在某个区域内
    [self.placeholder drawInRect:placeholderRect withAttributes:attribute];
    
}

// 监听到TextView文字改变时调用该方法
- (void)textDidChange {
    // 重绘:重新调用drawRect方法
    // 每次调用drawRect会把之前东西擦掉
    [self setNeedsDisplay];

}

// 让自定义控件的属性改了马上就有反应
- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

// 让自定义控件的属性改了马上就有反应
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = [placeholderColor copy];
    [self setNeedsDisplay];
    
}

- (void)setText:(NSString *)text {
    
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)dealloc {
    // 控制器销毁后就撤销监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



















