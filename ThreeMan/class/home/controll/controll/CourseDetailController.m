//
//  CourseDetailController.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseDetailController.h"

@interface CourseDetailController ()
{
    UIScrollView *_scrollView;
}
@property(nonatomic,strong)UIScrollView *backScrollView;
@end

@implementation CourseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self addUIBannerView];
    [self addUICategoryView];
    [self addUIDownloadView];
    // Do any additional setup after loading the view.
}
//添加广告图片
-(void)addUIBannerView{
    
    UIImageView *bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 180)];
    [self.view addSubview:bannerImage];
    bannerImage.backgroundColor =[UIColor purpleColor];
    bannerImage.userInteractionEnabled=YES;
    
    //添加滑动背景
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 150, kWidth, kHeight-150)];
    self.backScrollView.backgroundColor =[UIColor cyanColor];
    [self.view addSubview:self.backScrollView];
    self.backScrollView.contentSize =CGSizeMake(kWidth, 730);
    self.backScrollView.bounces=NO;
    self.backScrollView.showsHorizontalScrollIndicator =NO;
    self.backScrollView.showsVerticalScrollIndicator=NO;
    
    
    
}
//添加分类  download  buyCourse collect
-(void)addUICategoryView{
    
}
//添加底部下载
-(void)addUIDownloadView{
    UIView *downloadView =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-64-50, kWidth, 50)];
    [self.view addSubview:downloadView];
    downloadView.backgroundColor =[UIColor yellowColor];
    for (int i=0; i<3; i++) {
        UIButton *categoryBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [downloadView addSubview:categoryBtn];
        categoryBtn.backgroundColor =[UIColor greenColor];
        if (i==0) {
            categoryBtn.frame =CGRectMake(20, 5, 80, 40) ;
        }if (i==1) {
            categoryBtn.frame =CGRectMake(120, 5, 100, 40) ;
        }if (i==2) {
            categoryBtn.frame =CGRectMake(280, 5, 80, 40) ;
        }
        
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
