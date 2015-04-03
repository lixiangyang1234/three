//
//  VideoCenterController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "VideoCenterController.h"
#import "SettingController.h"
#import "AccountController.h"
#import "MessageController.h"


@interface VideoCenterController ()
{
    BOOL isEditting;
}

@end

@implementation VideoCenterController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftTitle:@"视频中心"];
    [self addUI];
    [self loadRigthNavItems];
    
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

- (void)loadRigthNavItems
{
    UIButton * searchItem =[UIButton buttonWithType:UIButtonTypeCustom];
    searchItem.frame =CGRectMake(kWidth-50-40, 8, 44, 44);
    [searchItem setImage:[UIImage imageNamed:@"nav_delete"] forState:UIControlStateNormal];
    [searchItem setImage:[UIImage imageNamed:@"nav_delete_pre"] forState:UIControlStateSelected];
    [searchItem addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1= [[UIBarButtonItem alloc] initWithCustomView:searchItem];
    
    UIButton * menuItem =[UIButton buttonWithType:UIButtonTypeCustom];
    menuItem.frame =CGRectMake(kWidth-50, 8, 30, 30);
    [menuItem setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:menuItem];
    [menuItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:item2,item1, nil];

}


//添加容器
-(void)addUI{
    
    self.sliderSwitchView  =[[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    self.sliderSwitchView.tabItemNormalColor = [UIColor lightGrayColor];
    self.sliderSwitchView.tabItemSelectedColor = [UIColor colorWithRed:0.99f green:0.16f blue:0.17f alpha:1.00f];
    self.sliderSwitchView.shadowImage = [[UIImage imageNamed:@"redLine.png"]
                                         stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.sliderSwitchView.backgroundColor =[UIColor whiteColor];
    self.sliderSwitchView.slideSwitchViewDelegate=self;
    
    [self.view addSubview:self.sliderSwitchView];
    
    self.listVC =[[DownloadListController alloc]init];
    self.listVC.title =@"下载观看";
    self.favoriteVC =[[FavoriteViewController alloc]init];
    self.favoriteVC.title =@"我的收藏";
    self.recordVC =[[RecordController alloc]init];
    self.recordVC.title =@"浏览记录";
    [self.sliderSwitchView buildUI];
    self.selectedIndex = 0;
    
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 3;
}
-(UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    if (number==0) {
        return self.listVC;
    }else if (number==1){
        return self.favoriteVC;
    }else if (number==2){
        return self.recordVC;
    }
    return nil;
}

-(void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam{
    
}
-(void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number{
    RootViewController *rootVc=nil;
    switch (number) {
        case 0:
            rootVc =self.listVC;
            break;
        case 1 :
            rootVc=self.favoriteVC;
            break;
            
        case 2:
            rootVc=self.recordVC;
            
            
        default:
            break;
    }
    self.selectedIndex =number;
    rootVc.nav =(WBNavigationController *)self.navigationController;
    
    [rootVc loadCurrent];
}

//删除
- (void)delete:(UIButton *)btn
{
    btn.selected = !btn.selected;
    isEditting = !isEditting;
    if (isEditting) {
        self.sliderSwitchView.rootScrollView.scrollEnabled = NO;
        for (UIView *subView in self.sliderSwitchView.topScrollView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subView;
                btn.userInteractionEnabled = NO;
            }
        }
    }else{
        self.sliderSwitchView.rootScrollView.scrollEnabled = YES;
        for (UIView *subView in self.sliderSwitchView.topScrollView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subView;
                btn.userInteractionEnabled = YES;
            }
        }
    }
    
    switch (self.selectedIndex) {
        case 0:
        {
            [self.listVC edit:isEditting];
        }
            break;
        case 1:
        {
            [self.favoriteVC edit:isEditting];
        }
            break;
        case 2:
        {
            [self.recordVC edit:isEditting];
        }
            break;
    
        default:
            break;
    }
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
            for (UIViewController *subVC in array) {
                if ([subVC isKindOfClass:[VideoCenterController class]]) {
                    [self.navigationController popToViewController:subVC animated:NO];
                    return;
                }
            }
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


@end
