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

}

- (void)setLeftTitle:(NSString *)leftTitle
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,44)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-30, 0, 150, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HexRGB(0xffffff);
    label.text = leftTitle;
    label.font = [UIFont systemFontOfSize:16];
    [titleView addSubview:label];
    
    
    
   
    self.navigationItem.titleView = titleView;
    //企业首页
    

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
