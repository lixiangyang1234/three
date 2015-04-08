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
    NSLog(@"让我旋转哪些方向");
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
    // Do any additional setup after loading the view.
    [self addUI];//添加容器
    [self addNavItem];//添加导航按钮
    
}
//添加导航按钮
-(void)addNavItem{

    UIView *backCollectView =[[UIView alloc]init];
    backCollectView.frame = CGRectMake(0, 10, kWidth-20, 44);
    backCollectView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = backCollectView;
    
    
    //    添加左边
    UIButton * logoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.frame =CGRectMake(0, 8, 30, 30);
    logoBtn. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [logoBtn setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
    [backCollectView addSubview:logoBtn];
    
    UIButton * titleItem =[UIButton buttonWithType:UIButtonTypeCustom];
    titleItem.frame =CGRectMake(30, 8, 60, 30);
    titleItem. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [titleItem setTitle:@"三身行" forState:UIControlStateNormal];
    [titleItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    titleItem.titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
    [backCollectView addSubview:titleItem];
    
    //    添加右边
    
//    UIButton * searchItem =[UIButton buttonWithType:UIButtonTypeCustom];
//    searchItem.frame =CGRectMake(kWidth-50-40, 8, 30, 30);
//    [searchItem setImage:[UIImage imageNamed:@"nav_search_btn"] forState:UIControlStateNormal];
//    [searchItem addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
//    [backCollectView addSubview:searchItem];
//    
//    UIButton * menuItem =[UIButton buttonWithType:UIButtonTypeCustom];
//    menuItem.frame =CGRectMake(kWidth-50, 8, 30, 30);
//    [menuItem setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
//    [menuItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
//    [backCollectView addSubview:menuItem];
    

    

//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_return_pre" highlightedSearch:@"nav_add" target:(self) action:@selector(navItemRight:)];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_return_pre" highlightedSearch:@"nav_add" target:(self) action:nil];

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
            frame.size.height = [UIScreen mainScreen].applicationFrame.size.height;
        }
        
        navigationController.view.frame = frame;
        
        // 3.添加左上角的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_return_pre" highlightedIcon:@"nav_return_pre.png" target:self action:@selector(backItem)];
        
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
