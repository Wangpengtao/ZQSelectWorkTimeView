//
//  UIView+Extend.h
//  PGJOA
//
//  Created by QzydeMac on 16/9/5.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign,readonly) CGFloat maxY;
@property (nonatomic,assign,readonly) CGFloat minY;
@property (nonatomic,assign,readonly) CGFloat maxX;
@property (nonatomic,assign,readonly) CGFloat minX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGSize size;


// 添加灰色的线条
- (void)addLineWithFrame:(CGRect)frame;
- (void)addLineWithFrame:(CGRect)frame color:(UIColor *)color;

// 获取渐变色图片
+ (UIImage *)getNavBackImage;

// 获取外勤的黄色标记
+ (UIView *)getOutsideTagWithFrame:(CGRect)frame;

// 获取浮动的按钮
+ (UIButton *)getFloatAddButton;// 加号
+ (UIButton *)getFloatLightningButton;// 闪电

+ (UIButton *)getFloatAddButton:(CGFloat)bottom;// 加号
+ (UIButton *)getFloatLightningButton:(CGFloat)bottom;// 闪电

+ (UIButton *)getFloatButtonWithImgName:(NSString *)imgName;// 根据图片获取浮动按钮
+ (UIButton *)getFloatButtonWithImgName:(NSString *)imgName bottom:(CGFloat)bottom;// 根据图片获取浮动按钮

// 获取上图下字的按钮
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title imageNormalName:(NSString *)imageNormalName imageSelectName:(NSString *)imageSelectName tag:(NSInteger)tag;

@end
