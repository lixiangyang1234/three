//
//  LeftTitleController.m
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "LeftTitleController.h"

@interface LeftTitleController ()

@end

@implementation LeftTitleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,0,kWidth/2-44,44)];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.titleLabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.titleLabel removeFromSuperview];
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    self.titleLabel.text = leftTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
