//
//  DPEmotionTextView.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/20.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//  继承自

#import "DPEmotionTextView.h"
#import "DPEmotion.h"
#import "NSString+Emoji.h"

@implementation DPEmotionTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)insertEmotion:(DPEmotion *)emotion {
    
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        // 在光标处插入
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
        // 拼接之前的文字（包含图片和普通文字）
        [attributedText appendAttributedString:self.attributedText];
        // 加载图片
        UIImage *image = [UIImage imageNamed:emotion.png];
        NSTextAttachment *attc = [[NSTextAttachment alloc] init];
        CGFloat attcWH = self.font.lineHeight;
        attc.image = image;
        // -4是根据视觉效果调整的
        attc.bounds = CGRectMake(0, -4, attcWH, attcWH);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attc];
        // 拼接图片
        //        [attributedText appendAttributedString:imageStr];
        NSUInteger loc = self.selectedRange.location;
        [attributedText insertAttributedString:imageStr atIndex:loc];
        
        // 设置字体
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        // 移除光标到表情后面
        self.selectedRange = NSMakeRange(loc + 1, 0);
        
        self.attributedText = attributedText;
    };

}

@end
