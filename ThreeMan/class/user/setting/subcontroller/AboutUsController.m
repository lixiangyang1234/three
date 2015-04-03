//
//  AboutUsController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    
    [self buildUI];
}

- (void)buildUI
{
    CGFloat y = 54;
    //图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    iconImageView.image = [UIImage imageNamed:@"logo"];
    iconImageView.center = CGPointMake(kWidth/2, y+iconImageView.frame.size.height/2);
    [self.view addSubview:iconImageView];
    
    y+=iconImageView.frame.size.height+10;
    //名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,y, kWidth,25)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = HexRGB(0x323232);
    nameLabel.text = @"南京三身行";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    y+=nameLabel.frame.size.height+5;
    //版本信息
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kWidth,15)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = HexRGB(0x323232);
    versionLabel.text = @"1.1.0.2";
    versionLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:versionLabel];
    
    y+=versionLabel.frame.size.height+20;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 150,20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = HexRGB(0x9a9a9a);
    titleLabel.text = @"联系我们:";
    [self.view addSubview:titleLabel];
    
    y += titleLabel.frame.size.height+10;
    
    NSArray *array = [NSArray arrayWithObjects:@"邮箱:acai@vip.qq.com",@"传真:021-50124541",@"电话联系请周一至周五工作日内联系", nil];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, y,kWidth-8*2,[array count]*39)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i =0 ; i<array.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,39*i,bgView.frame.size.width-10,39)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = HexRGB(0x323232);
        label.text = [array objectAtIndex:i];
        [bgView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,38+39*i,bgView.frame.size.width,1)];
        line.backgroundColor = HexRGB(0xe0e0e0);
        [bgView addSubview:line];
    }
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
