//
//  VideoCenterController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "VideoCenterController.h"

@implementation VideoCenterController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"视频中心";
    [self addUI];
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


@end
