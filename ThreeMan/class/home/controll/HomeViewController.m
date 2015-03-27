//
//  HomeViewController.m
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "HomeViewController.h"
#import "NeedViewControll.h"
#import "IndustryViewControll.h"
#import "CourseEightController.h"

#define BANNER 150//banner高度
#define BORDERH 10//边界高度
#define BTNHEIGHT 40 //按钮的高度

@interface HomeViewController ()
@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,copy)NSArray *noticeArray;

@end

@implementation HomeViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self addUIBanner];//1区
//    [self addUICourse];//2区添加八大课程体系
//    [self addUICategory];//3添加分类

}
//1区
-(void)addUIBanner{
    //添加滑动背景
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-104)];
    self.backScrollView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.backScrollView];
    self.backScrollView.contentSize =CGSizeMake(kWidth, 1000);
    self.backScrollView.bounces=NO;
    
    
    UIImageView *bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, BANNER)];
    [self.backScrollView addSubview:bannerImage];
    [bannerImage setBackgroundColor:[UIColor cyanColor]];
//    bannerImage.image=[UIImage imageNamed:@"<#string#>"];
    
    
//    UIImageView *headerImag =[[UIImageView alloc]initWithFrame:CGRectMake(130, 20, 40, 40)];
//    
//    [bannerImage addSubview:headerImag];
//    headerImag.backgroundColor=[UIColor redColor];
//    headerImag.image =[UIImage imageNamed:@"img"];
    
    
}
//2八大课程体系
-(void)addUICourse{

    
    self.noticeArray=@[@"陈打开都",@"陈打开都",@"陈打开都",@"陈打开都",@"陈打开都",@"陈打开都",@"陈打开都",@"陈打开都"];
    for (int c=0; c<self.noticeArray.count; c++)
    {
        
        
        
        
        UIButton *courseButtTitle =[UIButton buttonWithType:UIButtonTypeCustom];
        
        courseButtTitle.frame =CGRectMake(10+c%4*(65+((kWidth-20)-64*4)/3), 200+c/4*(40+40), 65, 30);
        [self.backScrollView addSubview:courseButtTitle];
        [courseButtTitle setTitle:self.noticeArray[c] forState:UIControlStateNormal];
        [courseButtTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        courseButtTitle.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [courseButtTitle setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        
        
        
        UIImageView *courseImage =[[UIImageView alloc]init];
        courseImage.frame =CGRectMake(10+c%4*(50+((kWidth-25)-50*4)/3), 152+c/4*(50+30), 50,50);
        
        
        [_backScrollView addSubview:courseImage];
        
        UIButton *courseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        courseBtn.frame =CGRectMake(10+c%4*(70+((kWidth-25)-70*4)/3), 152+c/4*(40+40), 50,70);
        [courseBtn setTitle:self.noticeArray[c] forState:UIControlStateNormal  ];
        [courseBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_backScrollView addSubview:courseBtn];
        
//        CategoryButt.tag=[hotCategoryModel.cateid intValue]+100;
        
        courseImage.tag = courseBtn.tag+10000;
        courseButtTitle.tag =courseImage.tag ;
        
        courseImage.userInteractionEnabled = NO;
        courseImage.image =[UIImage imageNamed:@"img"];
//        [findImage setImageWithURL:[NSURL URLWithString:hotCategoryModel.image]  placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
        
        [courseBtn addTarget:self action:@selector(courseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
    }


//    for (int c=0; c<self.noticeArray.count; c++)
//    {
//        
//        UIButton *noticeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        
//        noticeBtn.frame =CGRectMake(0+c%4*(39+40), 190+c/4*(45), 80, 30);
//        [self.backScrollView addSubview:noticeBtn];
//        [noticeBtn setTitle:self.noticeArray[c] forState:UIControlStateNormal];
//        [noticeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [noticeBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
////        [noticeBtn setBackgroundColor:[UIColor purpleColor]];
//        noticeBtn. titleLabel.font =[UIFont systemFontOfSize:12];
//        [noticeBtn setImage:[UIImage imageNamed:@"img"] forState:UIControlStateNormal];
//        [noticeBtn addTarget: self action:@selector(noticeBtn:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
    
    
}
//2、八大课程体系按钮
-(void)courseBtnClick:(UIButton *)cate{
    CourseEightController *courseEightVc=[[CourseEightController alloc]init];
    [self.nav pushViewController:courseEightVc animated:YES];
}
//
//3、添加分类
-(void)addUICategory
{
    for (int l=0; l<3; l++) {
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, BANNER+160+l%3*130, kWidth, 1)];
        if (l==2) {
            line.frame =CGRectMake(0, BANNER+10+l%3*130, kWidth, 1);
        }
        [self.backScrollView addSubview:line];
        line.backgroundColor =[UIColor lightGrayColor];
        
        
    }
    for (int t=0; t<2; t++) {
        NSArray *titleArray =@[@"  需求                    更多   ",@"  行业                    更多   "];
        UIButton* titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame =CGRectMake(0, BANNER+160+t%3*130, kWidth, 30 );
        [self.backScrollView addSubview:titleBtn];
        [titleBtn setImage:[UIImage imageNamed:@"img"] forState:UIControlStateNormal];
        [titleBtn setTitle:titleArray[t] forState:UIControlStateNormal];
        [titleBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        
        UIImageView *moreImage =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-40, 5, 20, 20)];
        [titleBtn addSubview:moreImage];
        moreImage.image =[UIImage imageNamed:@"img"];
        titleBtn.tag =100+t;
        moreImage.userInteractionEnabled = YES;
        [titleBtn addTarget:self action:@selector(categoryMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        

    }
    
        for (int i=0; i<6; i++) {
            UIButton* ImageBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            ImageBtn.frame =CGRectMake(BORDERH+i%3*(90+10), BANNER+200+i/3*140, 90, 50 );
            [self.backScrollView addSubview:ImageBtn];
            [ImageBtn setImage:[UIImage imageNamed:@"img"] forState:UIControlStateNormal];
//            [ImageBtn setTitle:@"课程推荐" forState:UIControlStateNormal];
//            [ImageBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
            ImageBtn.backgroundColor =[UIColor redColor];
            [ImageBtn addTarget:self action:@selector(categoryImageBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            ImageBtn.tag =i+10;
           
        
        

    }
    
    
}
//3、分类事件
-(void)categoryMoreBtn:(UIButton *)more{
    if (more.tag==100) {
        NeedViewControll *needVC=[[NeedViewControll alloc]init];
        [self.nav pushViewController:needVC animated:YES];
    }else {
        IndustryViewControll *industryVC=[[IndustryViewControll alloc]init];
        [self.nav pushViewController:industryVC animated:YES];
    }
    NSLog(@"%d",more.tag);
    
}
-(void)categoryImageBtn:(UIButton *)category{
    NSLog(@"%d",category.tag);
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
