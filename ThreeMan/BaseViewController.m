//
//  BaseViewController.m
//  ThreeMan
//
//  Created by tianj on 15/3/31.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchViewController.h"
#import "TYPopoverView.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    [self loadNavItems];
    

}

- (void)loadNavItems
{
    UIButton * searchItem =[UIButton buttonWithType:UIButtonTypeCustom];
    searchItem.frame =CGRectMake(kWidth-50-40, 8, 30, 30);
    [searchItem setImage:[UIImage imageNamed:@"nav_search_btn"] forState:UIControlStateNormal];
    [searchItem addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1= [[UIBarButtonItem alloc] initWithCustomView:searchItem];
    
    UIButton * menuItem =[UIButton buttonWithType:UIButtonTypeCustom];
    menuItem.frame =CGRectMake(kWidth-50, 8, 30, 30);
    [menuItem setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:menuItem];
    [menuItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:item2,item1, nil];
}

- (void)search
{
    NSArray *arr = self.navigationController.viewControllers;
    for (UIViewController *subView in arr) {
        [subView isKindOfClass:[SearchViewController class]];
        [self.navigationController popToViewController:subView animated:NO];
        return;
    }
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


- (void)navItemRight:(UIButton *)btn
{
    CGPoint point = CGPointMake(kWidth-60, btn.frame.origin.y + btn.frame.size.height+15);
    
    NSArray * titles = @[@"登陆", @"| 注销", @"分享",@"建议",@"建议"];
    NSArray *  images = @[@"nav_return_pre", @"nav_return_pre", @"nav_return_pre", @"nav_return_pre", @"nav_return_pre"];
    
    TYPopoverView *popView = [[TYPopoverView alloc] initWithPoint:point titles:titles images:images];
    popView.selectRowAtIndex = ^(NSInteger index)
    {
        NSLog(@"select index:%ld", (long)index);
    };
    
    [popView show];

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
