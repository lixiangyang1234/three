//
//  CourseEightController.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseEightController.h"

@interface CourseEightController ()

@end

@implementation CourseEightController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);
//    self.title = @"详情";
    [self setLeftTitle:@"课程详情"];
    NetFailView *failView =[[NetFailView alloc]initWithFrame:self.view.bounds backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"对不起，网络不给力!请检查您的网络设置! "];
    [self.view addSubview:failView];
    
    
}




@end
