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
    [self setLeftTitle:@"我的成长"];
    [self addUI];
    [self loadRigthNavItems];
    
}

- (void)setLeftTitle:(NSString *)leftTitle
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,44)];
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-15, 0, 150, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HexRGB(0xffffff);
    label.text = leftTitle;
    [titleView addSubview:label];
    self.navigationItem.titleView = titleView;
}

- (void)loadRigthNavItems
{
    
    UIButton *deleteItem =[UIButton buttonWithType:UIButtonTypeCustom];
    deleteItem.frame =CGRectMake(kWidth-50-40, 8, 44, 44);
    [deleteItem setImage:[UIImage imageNamed:@"nav_delete"] forState:UIControlStateNormal];
    [deleteItem setImage:[UIImage imageNamed:@"nav_delete_pre"] forState:UIControlStateSelected];
    [deleteItem addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1= [[UIBarButtonItem alloc] initWithCustomView:deleteItem];
    
    NSArray *array = self.navigationItem.rightBarButtonItems;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
    [arr addObject:item1];
    self.navigationItem.rightBarButtonItems = arr;
}


//添加容器
-(void)addUI{
    
    self.sliderSwitchView  =[[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    self.sliderSwitchView.tabItemNormalColor = [UIColor lightGrayColor];
    self.sliderSwitchView.tabItemSelectedColor = [UIColor colorWithRed:0.99f green:0.16f blue:0.17f alpha:1.00f];
    self.sliderSwitchView.shadowImage = [[UIImage imageNamed:@"BlueLine"]
                                         stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.sliderSwitchView.backgroundColor =[UIColor whiteColor];
    self.sliderSwitchView.slideSwitchViewDelegate=self;
    
    [self.view addSubview:self.sliderSwitchView];
    
    self.listVC =[[DownloadListController alloc]init];
    self.listVC.title =@"下载观看";
    self.favoriteVC =[[FavoriteViewController alloc]init];
    self.favoriteVC.title =@"我的收藏";
    self.recordVC =[[RecordController alloc]init];
    self.recordVC.title =@"成长记录";
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

@end
