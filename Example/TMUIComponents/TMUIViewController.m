//
//  TMUIViewController.m
//  TMUIComponents
//
//  Created by chengzongxin on 01/17/2023.
//  Copyright (c) 2023 chengzongxin. All rights reserved.
//

#import "TMUIViewController.h"
#import <TMUIComponents/TMUIComponents.h>

@interface TMUIViewController ()

@end

@implementation TMUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [TMUIPickerView showDatePickerWithConfigBlock:nil selectDateBlock:^(NSDate * _Nonnull date) {
        NSLog(@"%@",date);
    }];
    
}
@end
