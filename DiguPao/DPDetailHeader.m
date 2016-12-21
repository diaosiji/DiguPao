//
//  DPDetailHeader.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/10.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPDetailHeader.h"

@interface DPDetailHeader ()

/** UIButton 内部属性 被选中的按钮 */
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation DPDetailHeader

+ (instancetype)header {
    return [[NSBundle mainBundle] loadNibNamed:@"DPDetailHeader" owner:nil options:nil][0];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


#pragma mark 监听按钮点击
- (IBAction)btnClick:(UIButton *)sender {
    
    // 控制状态
    self.selectedButton.enabled = YES;
    sender.enabled = NO;
    self.selectedButton = sender;
    
    // 移动小三角形
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"移动小三角");
        CGPoint center = self.hint.center;
        center.x = sender.center.x;
        self.hint.center = center;
    }];
    
    // 确定当前被按钮选中的按钮
    if (sender == self.apply) { // 选择回应按钮
        
        DetailHeaderBtnType type = DetailHeaderBtnTypeApply;
        _currentType = type;
        
    } else if (sender == self.collection) { // 选择收藏按钮
        
        DetailHeaderBtnType type = DetailHeaderBtnTypeCollection;
        _currentType = type;
        
    } else if (sender == self.attitude) { // 选择点赞按钮
        
        DetailHeaderBtnType type = DetailHeaderBtnTypeAttitude;
        _currentType = type;
        
    }
//    NSLog(@"当前按钮类型:%u", self.currentType);
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(detailHeader:btnClick:)]) {
//        NSLog(@"在DPDetailHeader.m中调用了代理方法");
        [self.delegate detailHeader:self btnClick:self.currentType];
        
    }
    
    
}


@end



















