//
//  MainControllerViewController.m
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "MainControllerViewController.h"
#import "WBNavigationController.h"
#import "UIBarButtonItem+MJ.h"
#import "TYPopoverView.h"
#import "SearchViewController.h"
#import "VideoCenterController.h"
#import "SettingController.h"
#import "AccountController.h"
#import "MessageController.h"


@interface MainControllerViewController ()<UINavigationControllerDelegate>
{
    UIView *windowView;
}
@end

@implementation MainControllerViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}
- (BOOL)shouldAutorotate
{
    return NO;
    
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor greenColor];
    // Do any additional setup after loading the view.
    [self addUI];//添加容器
    [self addNavItem];//添加导航按钮
    
    
    
}
//添加导航按钮
-(void)addNavItem{


    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,78,27)];
    imageView.image = [UIImage imageNamed:@"logo"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
}
//添加容器
-(void)addUI{
    self.sliderSwitchView  =[[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    self.sliderSwitchView.tabItemNormalColor = [UIColor lightGrayColor];
    self.sliderSwitchView.tabItemSelectedColor = [UIColor colorWithRed:0.99f green:0.16f blue:0.17f alpha:1.00f];
    self.sliderSwitchView.shadowImage = [[UIImage imageNamed:@"BlueLine_pre.png"]
                                         stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.sliderSwitchView.backgroundColor =[UIColor whiteColor];
    self.sliderSwitchView.slideSwitchViewDelegate=self;
    
    [self.view addSubview:self.sliderSwitchView];
    
    self.home =[[HomeViewController alloc]init];
    self.home.title =@"首页";
    self.course =[[CourseViewController alloc]init];
    self.course.title =@"三身行";
    self.company =[[CompanyViewController alloc]init];
    self.company.title =@"标杆案例";
    [self.sliderSwitchView buildUI];
    

}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 3;
}
-(UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    if (number==0) {
        return self.home;
    }else if (number==1){
        return self.course;
    }else if (number==2){
        return self.company;
    }
    return nil;
}

-(void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam{
    
}
-(void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number{
    RootViewController *rootVc=nil;
    switch (number) {
        case 0:
            rootVc =self.home;
            break;
          case 1 :
            rootVc=self.course;
            break;

            case 2:
            rootVc=self.company;
            

        default:
            break;
    }
    self.selectedIndex =number;
    rootVc.nav =(WBNavigationController *)self.navigationController;
    rootVc.nav.delegate =self;

    [rootVc loadCurrent];
}

#pragma mark 实现导航控制器代理方法
// 导航控制器即将显示新的控制器
- (void)navigationController:(WBNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
        // 1.获得当期导航控制器的根控制器
    UIViewController *root = navigationController.viewControllers[0];
    if (root != viewController) { // 不是根控制器
        // {0, 20}, {320, 460}
        // 2.拉长导航控制器的view
        CGRect frame = navigationController.view.frame;
        if (IsIos7) {
            frame.size.height = [UIScreen mainScreen].applicationFrame.size.height+20;
        }else{
            frame.size.height = [UIScreen mainScreen].applicationFrame.size.height+20;
        }
        
        navigationController.view.frame = frame;
        // 3.添加左上角的返回按钮
        if (!viewController.navigationItem.leftBarButtonItem) {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithIcon:@"nav_back" title:@"" target:self action:@selector(backItem)];
        }
    }
}

- (void)backItem
{
    [self.navigationController popViewControllerAnimated:YES];
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
