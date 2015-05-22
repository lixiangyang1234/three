
#import "WBNavigationController.h"
#import "AppMacro.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.appearance方法返回一个导航栏的外观对象
    // 修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *bar = [UINavigationBar appearance];
//    2.去除导航栏底部灰色线条
    [bar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    bar.shadowImage = [[UIImage alloc] init];
    // 3.设置导航栏的背景图片
//    bar.backgroundColor =RGBNAVbackGroundColor;
   
    if (IsIos7) {
        [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];

    }else{
        [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];

    }
   
    // 3.设置导航栏文字的主题
    [bar setTitleTextAttributes:@{
      UITextAttributeTextColor : [UIColor clearColor],
      UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero] ,UITextAttributeFont:[UIFont systemFontOfSize:18]
     }];
    
    // 4.修改所有UIBarButtonItem的外观
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
        // 修改item上面的文字样式
    NSDictionary *dict = @{
                           UITextAttributeTextColor : [UIColor whiteColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero]
                           };
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    
    // 5.设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}


- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
    
}


@end
