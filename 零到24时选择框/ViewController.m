//
//  ViewController.m
//  零到24时选择框
//
//  Created by ZQ on 2019/1/11.
//  Copyright © 2019年 ZQ. All rights reserved.
//

#import "ViewController.h"
#import "ZQSelectWorkTimeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [ZQSelectWorkTimeView showSelectWorkTime:@"6.6" blockAction:^(NSString * _Nonnull time) {
        
        NSLog(@"%@",time);
    }];
}


@end
