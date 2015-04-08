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
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,44)];
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-15, 0, 150, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = leftTitle;
    [titleView addSubview:label];
    self.navigationItem.titleView = titleView;
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
