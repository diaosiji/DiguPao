//
//  DPDropdownMenu.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/12.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPDropdownMenu.h"
#import "UIView+Extension.h"

@interface DPDropdownMenu()
// 将来用来显示具体内容的容器
@property (nonatomic, weak) UIImageView *containerView;

@end

@implementation DPDropdownMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 清除颜色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// 懒加载
- (UIImageView *)containerView {
    
    if (!_containerView) {
        // 添加灰色图片
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage imageNamed:@"popover_background"];
        // 改变思路 宽高由外部指定
        //        containerView.width = 217;
        //        containerView.height = 217;
        containerView.userInteractionEnabled = YES; //开启交互功能
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    
    return _containerView;
}

+ (instancetype)menu {
    
    return [[self alloc] init];
}

// 显示菜单
- (void)showFrom:(UIView *)from {
    // 获得最上面窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 将自己添加到窗口
    [window addSubview:self];
    // 设置尺寸
    self.frame = window.bounds;
    // 设置自己灰色图片的位置
    // 这里要用到转换坐标系的知识
    // 默认情况下frame是相对于父控件的左上角为原点的 bounds是相对于自己左上角来算的
    // 但是可以通过转换坐标系来该改变frame的参考原点
    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    // 也可用
    //CGRect newFrame = [from convertRect:from.bounds toView:window];
    
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    // 通知外界自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        // 去Home控制器
        [self.delegate dropdownMenuDidShow:self];
    }
    
}



// 消除菜单
- (void)dismiss {
    
    [self removeFromSuperview];
    
    // 通知外界自己被销毁了
    // 方便标题的箭头翻转
    // 使用代理方法
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        // 去Home控制器
        [self.delegate dropdownMenuDidDismiss:self];
    }
    
    
    
}

// 这个方法是自带方法 是监听整个View点击的 当监听到占据屏幕的cover被点击时让菜单小时
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touchesBegan");
    [self dismiss];
}

- (void)setContent:(UIView *)content {
    _content = content;
    // 设置内容的位置 是根据灰色图片的边界和灰色部分的距离的
    content.x = 10;
    content.y = 15;
    
    // 调整内容的宽度
    // 因为containerView的宽度是由灰色图片决定为固定的217 所以可以根据它来算
    // 改变思路 宽度还是由外部指定
    //content.width = self.containerView.width - 2 * content.x;
    
    // 设置灰色图片的尺寸
    self.containerView.height = CGRectGetMaxY(content.frame) + 10;
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    
    // 添加内容到灰色图片处
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController {
    // 先赋值防止销毁
    _contentController = contentController;
    
    self.content = contentController.view;
    
}


@end
