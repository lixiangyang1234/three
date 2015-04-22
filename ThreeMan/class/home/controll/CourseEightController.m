//
//  CourseEightController.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseEightController.h"
#import "courseEightModel.h"
#import "homeViewControllTool.h"
#define YYBORDERWH 8
#define borderw 5
#define BANNERH 167
@interface CourseEightController ()<UIWebViewDelegate>
{
    ErrorView *networkError;
    CGFloat bannerHeightLine;
    CGFloat webh;
}
@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,strong)NSMutableArray *courseEightArray;
@property(nonatomic,strong)UIWebView *courseWeb;
@end

@implementation CourseEightController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    [self setLeftTitle:@"课程详情"];
    _courseEightArray =[NSMutableArray array];
    [self addErrorView];
    [self addMBprogressView];
    [self addLoadStatus];
    
}
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
}
#pragma mark ---添加数据
-(void)addLoadStatus{
   [homeViewControllTool statusesWithCourseEightID:_courseID Success:^(NSMutableArray *statues) {
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

       for (NSDictionary *dict in statues) {
           [_courseEightArray addObject:dict];
       }
       [self addUICourseDetail];
   } failure:^(NSError *error) {
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

       networkError.hidden =NO;
   }];
}
-(void)addUICourseDetail{
    courseEightModel *courseModel =[_courseEightArray objectAtIndex:0];
    //添加滑动背景
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(YYBORDERWH, YYBORDERWH, kWidth-YYBORDERWH*2, kHeight-YYBORDERWH)];
    self.backScrollView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.backScrollView];
    self.backScrollView.bounces=NO;
    self.backScrollView.showsHorizontalScrollIndicator =NO;
    self.backScrollView.showsVerticalScrollIndicator=NO;
    //banner图片
    UIImageView *bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderw, borderw, self.backScrollView.frame.size.width-borderw*2, BANNERH)];
    [self.backScrollView addSubview:bannerImage];
    bannerImage.backgroundColor =HexRGB(0xe8e8e8);
    [bannerImage setImageWithURL:[NSURL URLWithString:courseModel.courseImgurl] placeholderImage:placeHoderImage];
    bannerImage.userInteractionEnabled=YES;
    
    //1添加8像素高度灰条
    UIView *eightView =[[UIView alloc]initWithFrame:CGRectMake(0, borderw*2+BANNERH, kWidth-YYBORDERWH*2, 8)];
    [self.backScrollView addSubview:eightView];
    eightView.backgroundColor =HexRGB(0xeeeee9);
    bannerHeightLine =eightView.frame.size.height+eightView.frame.origin.y+borderw*2;
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-YYBORDERWH*2, 1)];
    [eightView addSubview:line];
    line.backgroundColor =HexRGB(0xcacaca);
    
    //添加标题
    CGFloat titleH =[courseModel.courseTitle sizeWithFont:[UIFont systemFontOfSize:PxFont(22)] constrainedToSize:CGSizeMake(kWidth-YYBORDERWH*2-borderw*2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(borderw*2, bannerHeightLine, kWidth-YYBORDERWH*2-borderw*4, titleH)];
    titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
    [self.backScrollView addSubview:titleLabel];
    titleLabel.textColor =HexRGB(0x323232);
    titleLabel.backgroundColor =[UIColor clearColor];
    titleLabel.textAlignment =NSTextAlignmentLeft;
    titleLabel.numberOfLines =0;
    titleLabel.text =courseModel.courseTitle;
    CGFloat titleLabelH =titleLabel.frame.origin.y+titleH;
    
    //添加浏览量
    UILabel *redLabel =[[UILabel alloc]initWithFrame:CGRectMake(borderw*2, titleLabelH+borderw, 200, 20)];
    redLabel.font =[UIFont systemFontOfSize:PxFont(16)];
    [self.backScrollView addSubview:redLabel];
    redLabel.textColor =HexRGB(0x959595);
    
    redLabel.backgroundColor =[UIColor clearColor];
    redLabel.textAlignment =NSTextAlignmentLeft;
    redLabel.text=[NSString stringWithFormat:@"浏览量:%d",courseModel.courseHits];
    CGFloat redLabelH =redLabel.frame.size.height+redLabel.frame.origin.y+borderw;

    //2添加8像素高度灰条
    UIView *eightView1 =[[UIView alloc]initWithFrame:CGRectMake(0, redLabelH, kWidth-YYBORDERWH*2, 8)];
    [self.backScrollView addSubview:eightView1];
    eightView1.backgroundColor =HexRGB(0xeeeee9);
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-YYBORDERWH*2, 1)];
    [eightView1 addSubview:line1];
    line1.backgroundColor =HexRGB(0xcacaca);
    
     webh =eightView1.frame.size.height+eightView1.frame.origin.y+borderw;
    
    //添加WebView
    _courseWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, webh, kWidth-YYBORDERWH*2, kHeight-webh-64)];
    
    [_courseWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    _courseWeb.userInteractionEnabled = NO;
    _courseWeb.delegate =self;
    _courseWeb.backgroundColor =[UIColor clearColor];
    _courseWeb.scrollView.bounces =NO;
    [_backScrollView addSubview:_courseWeb];

    
    


    
    
    
   
    

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGFloat webheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    
    _courseWeb.frame = CGRectMake(0, webh, kWidth-YYBORDERWH*2, webheight);
    
    _backScrollView.contentSize = CGSizeMake(kWidth-YYBORDERWH*2,webheight+webh+64);
    
    
    
}
//没有网络
-(void)addErrorView{
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    
}




@end
