//
//  ZQSelectWorkTimeView.h
//  erp
//
//  Created by ZQ on 2019/1/7.
//  Copyright © 2019年 PT. All rights reserved.
//  选择工时的弹框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQSelectWorkTimeView : UIView

+ (void)showSelectWorkTime:(NSString *)time blockAction:( void(^)(NSString *time) )blockAction;

@end

NS_ASSUME_NONNULL_END
