//
//  ZQSelectWorkTimeView.m
//  erp
//
//  Created by ZQ on 2019/1/7.
//  Copyright © 2019年 PT. All rights reserved.
//

#import "ZQSelectWorkTimeView.h"
#import <MJExtension.h>
#import <Masonry.h>
#import "UIView+Extend.h"

#define kScale 5
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kKeyWindow          [UIApplication sharedApplication].keyWindow

#define kw(R)   (R) * (kScreenWidth) / 375.0
#define MP_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define MP_IS_IPHONE_X (MP_IS_IPHONE && [[UIApplication sharedApplication] statusBarFrame].size.height == 44)
#define kHeight_Bottom (MP_IS_IPHONE_X ? 34 : 0)
#define kFont(F)            [UIFont fontWithName:@"PingFangSC-Regular" size:((F) * (kScreenWidth) / 375.0)]

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define COLOR_GLOBAL_TEXT_BLACK HEXCOLOR(0x223243)      //黑色字体主颜色
#define COLOR_GLOBAL_BLUE_Light HEXCOLOR(0x38b1fd)      //稍微浅一些的蓝色
#define COLOR_GLOBAL_TEXT_Gray HEXCOLOR(0x757f8a)       //次要内容颜色


@interface ZQSelectWorkTimeView ()<UIScrollViewDelegate>
@property (nonatomic, copy) void (^blockAction)(NSString *time);
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation ZQSelectWorkTimeView

+ (void)showSelectWorkTime:(NSString *)time blockAction:( void(^)(NSString *time) )blockAction{
    
    ZQSelectWorkTimeView *timeView = [[ZQSelectWorkTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    timeView.alpha = 0;
    timeView.blockAction = blockAction;
    timeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [timeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:timeView action:@selector(dismiss)]];
    [kKeyWindow addSubview:timeView];
    
    [timeView bulidContentView];
    [timeView setWorkTime:time];
    
    [UIView animateWithDuration:0.25 animations:^{
      
        timeView.alpha = 1;
        timeView.contentView.transform = CGAffineTransformMakeTranslation(0, -timeView.contentView.height);
    }];
}

- (void)bulidContentView{
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kw(220)+kHeight_Bottom)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [_contentView addLineWithFrame:CGRectMake(0, kw(50), _contentView.width, 1)];
    [self addSubview:_contentView];
    
    [self bulidBasicsView];
    [self bulidDateView];
    [self bulidScrollView];
    [self bulidPointer];
}

- (void)setWorkTime:(NSString *)time{
    
    if (!time || [time floatValue] <= 0) {
        _dateLabel.text = @"0.0";
    }else if ([time floatValue] >= 24){
        _dateLabel.text = @"24.0";
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - self.width, 0)];
    }else{
        CGFloat x = [[NSString stringWithFormat:@"%.1f",[time floatValue]] floatValue]*10;
        [_scrollView setContentOffset:CGPointMake(x*kScale, 0)];
    }
}

- (void)bulidBasicsView{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请选择工时";
    titleLabel.font = kFont(15);
    titleLabel.textColor = COLOR_GLOBAL_TEXT_BLACK;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView.mas_top).offset(kw(25));
    }];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.titleLabel.font = kFont(13);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:COLOR_GLOBAL_BLUE_Light forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.centerY.mas_equalTo(titleLabel);
        make.centerX.mas_equalTo(self.contentView.mas_left).offset(kw(30));
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.titleLabel.font = kFont(13);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:COLOR_GLOBAL_BLUE_Light forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(titleLabel);
        make.centerX.mas_equalTo(self.contentView.mas_right).offset(-kw(30));
    }];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureAction{
    [self dismiss];
    
    if (self.blockAction) self.blockAction(self.dateLabel.text);
}

// 工时
- (void)bulidDateView{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"工时(小时)";
    label.font = kFont(14);
    label.textColor = COLOR_GLOBAL_TEXT_Gray;
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(kw(65));
    }];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.text = @"0.0";
    _dateLabel.font = [UIFont boldSystemFontOfSize:kw(36)];
    _dateLabel.textColor = COLOR_GLOBAL_BLUE_Light;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(label.mas_bottom).offset(kw(30));
    }];
}

// 刻度表
- (void)bulidScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentView.height - kw(70) - kHeight_Bottom, kScreenWidth, kw(50))];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth + kScale*10*24, _scrollView.height);
    [_scrollView addLineWithFrame:CGRectMake(kScreenWidth/2, _scrollView.height-kw(1), kScale*10*24, kw(1)) color:[UIColor colorWithRed:0.82f green:0.81f blue:0.82f alpha:1.00f]];
    [self.contentView addSubview:_scrollView];
    
    // 刻度值
    for (int i = 0; i < 25; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kw(20), kw(15))];
        label.font = kFont(13);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",i];
        label.textColor = [UIColor colorWithRed:0.76f green:0.76f blue:0.77f alpha:1.00f];
        label.center = CGPointMake(kScreenWidth/2 + i*(kScale*10) + 0.5, _scrollView.height - kw(20));
        [_scrollView addSubview:label];
    }
    
    // 刻度线
    for (int i = 0; i < 24*10+1; i++) {
        
        CGFloat h = kw(4);
        if (i%5 == 0) {
            h = kw(8);
        }
        [_scrollView addLineWithFrame:CGRectMake(kScreenWidth/2 + i*kScale, _scrollView.height-h, 1, h) color:[UIColor colorWithRed:0.82f green:0.81f blue:0.82f alpha:1.00f]];
    }
}

// 蓝色的指针
- (void)bulidPointer{
    
    CGFloat y = _scrollView.y;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.width/2 - kw(3) + 0.5, y, kw(6), kw(6)) cornerRadius:kw(3)];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(self.width/2, y + kw(3), 1, _scrollView.height - kw(3))];
    
    NSArray *arr = @[path,path1];
    for (UIBezierPath *path in arr) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = [UIColor colorWithRed:0.29f green:0.72f blue:0.99f alpha:1.00f].CGColor;
        [self.contentView.layer addSublayer:layer];
    }
}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self controlOffset];
}

// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        [self controlOffset];
    }
}

// scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger x = _scrollView.contentOffset.x;
    if (x < 0)
    {// 避免工时计算为负数
        x = 0;
    }else if (x >= _scrollView.contentSize.width - _scrollView.width)
    {// 避免工时计算大于24小时
        x = _scrollView.contentSize.width - _scrollView.width;
    }
    
    if (x%kScale >= kScale/2) {
        x = x - x%kScale + kScale;
    }else{
        x = x - x%kScale;
    }
    
    _dateLabel.text = [NSString stringWithFormat:@"%.1f",x/kScale/10.0];
}

// 控制滑动结束时的偏移, 是指针精确指向最靠近的刻度
- (void)controlOffset{
    
    NSInteger x = _scrollView.contentOffset.x;
    if (x%kScale >= kScale/2) {
        x = x - x%kScale + kScale;
    }else{
        x = x - x%kScale;
    }
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

@end
