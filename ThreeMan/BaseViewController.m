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
#import "VideoCenterController.h"
#import "SettingController.h"
#import "AccountController.h"
#import "MessageController.h"

@interface BaseViewController ()<TYPopoverViewDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    [self loadNavItems];
    

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
        if ([subView isKindOfClass:[SearchViewController class]]) {
            [self.navigationController popToViewController:subView animated:NO];
            return;
        }
    }
    
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


- (void)navItemRight:(UIButton *)btn
{
    CGPoint point = CGPointMake(kWidth-60, btn.frame.origin.y + btn.frame.size.height+15);
    
    NSArray * titles = @[@"我的成长", @"账户", @"消息",@"设置"];
    NSArray *  images = @[@"video", @"account", @"message", @"setting"];
    
    TYPopoverView *popView = [[TYPopoverView alloc] initWithPoint:point titles:titles images:images];
    popView.delegate = self;
    popView.selectRowAtIndex = ^(NSInteger index)
    {
        NSLog(@"select index:%ld", (long)index);
    };
    
    [popView show];
}

- (void)TYPopoverViewTouch:(UIButton *)btn view:(TYPopoverView *)view
{
    NSArray *array = self.navigationController.viewControllers;
    switch (btn.tag) {
        case -1:
        {
            
        }
            break;
        case -2:
        {
            
        }
            break;
        case 0:
        {
            VideoCenterController *center = [[VideoCenterController alloc] init];
            [self.navigationController pushViewController:center animated:YES];
        }
            break;
        case 1:
        {
            for (UIViewController *subVC in array) {
                if ([subVC isKindOfClass:[AccountController class]]) {
                    [self.navigationController popToViewController:subVC animated:NO];
                    return;
                }
            }
            AccountController *account = [[AccountController alloc] init];
            [self.navigationController pushViewController:account animated:YES];
        }
            break;
        case 2:
        {
            for (UIViewController *subVC in array) {
                if ([subVC isKindOfClass:[MessageController class]]) {
                    [self.navigationController popToViewController:subVC animated:NO];
                    return;
                }
            }
            MessageController *message = [[MessageController alloc] init];
            [self.navigationController pushViewController:message animated:YES];
        }
            break;
        case 3:
        {
            for (UIViewController *subVC in array) {
                if ([subVC isKindOfClass:[SettingController class]]) {
                    [self.navigationController popToViewController:subVC animated:NO];
                    return;
                }
            }
            SettingController *set = [[SettingController alloc] init];
            [self.navigationController pushViewController:set animated:YES];
        }
            break;
            
        default:
            break;
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
