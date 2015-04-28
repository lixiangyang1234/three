//
//  HomeViewController.m
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "HomeViewController.h"
#import "CourseEightController.h"
#import "KDCycleBannerView.h"
#import "NineBlockController.h"
#import "NeedViewController.h"
#import "BusinessController.h"
#import "ThreeBlockController.h"
#import "homeViewControllTool.h"
#import "homeViewArrayModel.h"
#import "homeViewControllModel.h"
#define BANNER    135           //banner高度
#define EIGHTH    87          //八大课程体系
#define NEEDH     135         //按需求
#define BUSINESS  182       //按行业
#define NEEDTAG  200

#define kcourseFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"course.data"]
#define kcategoryFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"category.data"]
#define ktradeFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"trade.data"]
#define kadsImageFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"adsImage.data"]


@interface HomeViewController ()<KDCycleBannerViewDataource,KDCycleBannerViewDelegate>
{
}
@property(nonatomic,strong)KDCycleBannerView *bannerView;

@end

@implementation HomeViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    _courseArray =[[NSMutableArray alloc]initWithCapacity:0];
    _categoryArray =[[NSMutableArray alloc]initWithCapacity:0];
    _tradeArray =[[NSMutableArray alloc]initWithCapacity:0];
    _slideImages =[[NSMutableArray alloc]initWithCapacity:0];
    _adsImage =[[NSMutableArray alloc]initWithCapacity:0];

    self.courseArrayOffLine =[NSMutableArray array];
    self.categoryArrayOffLine =[NSMutableArray array];
    self.tradeArrayOffLine =[NSMutableArray array];
    self.adsImageOffLine =[NSMutableArray array];
    [self addADSimageBtn:_adsImageOffLine];
    [self addUIBanner];//1区
    [self addUICourse:_courseArrayOffLine];//2区添加八大课程体系
    
    [self addUICategory:_categoryArrayOffLine];
    [self addUITrade:_tradeArrayOffLine];
    [self addMBprogressView];
        [self addLoadStatus];
    
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

}

//添加数据
-(void)addLoadStatus{

    [homeViewControllTool statusesWithSuccess:^(NSMutableArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        homeViewArrayModel * homeArrayModel =[statues objectAtIndex:0];
        for (NSDictionary *dict in homeArrayModel.ads) {
            
            homeViewControllModel *homeModel =[[homeViewControllModel alloc]initWithDictionaryForHomeAds:dict];
            [_adsImage addObject:homeModel];
            
        }
        
        for (NSDictionary *couseDict in homeArrayModel.course) {
            homeViewControllModel *homeModel =[[homeViewControllModel alloc]initWithDictionaryForHomeCourse:couseDict];
            [_courseArray addObject:homeModel];
        }
        
        for (NSDictionary *categoryDict in homeArrayModel.category) {
            homeViewControllModel *homeModel =[[homeViewControllModel alloc]initWithDictionaryForHomeCategory:categoryDict];
            [_categoryArray addObject:homeModel];
        }
        
        for (NSDictionary *tradeDict in homeArrayModel.trade) {
            homeViewControllModel *homeModel =[[homeViewControllModel alloc]initWithDictionaryForHomeTrade:tradeDict];
            [_tradeArray addObject:homeModel];
        }
//        //归档离线数据
        [NSKeyedArchiver archiveRootObject:_adsImage toFile:kadsImageFilePath];
        [NSKeyedArchiver archiveRootObject:_courseArray toFile:kcourseFilePath];
        [NSKeyedArchiver archiveRootObject:_categoryArray toFile:kcategoryFilePath];
        [NSKeyedArchiver archiveRootObject:_tradeArray toFile:ktradeFilePath];
        
        [self addADSimageBtn:_adsImage];
        [self addUIBanner];//1区
        [self addUICourse:_courseArray];//2区添加八大课程体系
       
        [self addUICategory:_categoryArray];
        [self addUITrade:_tradeArray];
//        NSLog(@"--------%d",_tradeArray.count);

    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
 //        //反归档数据
        self.adsImageOffLine = [NSKeyedUnarchiver unarchiveObjectWithFile:kadsImageFilePath];
        self.courseArrayOffLine =[NSKeyedUnarchiver unarchiveObjectWithFile:kcourseFilePath];
        self.tradeArrayOffLine =[NSKeyedUnarchiver unarchiveObjectWithFile:ktradeFilePath];
        self.categoryArrayOffLine =[NSKeyedUnarchiver unarchiveObjectWithFile:kcategoryFilePath];
        [self addUIBanner];//1区
        [self addADSimageBtn:_adsImageOffLine];
        [self addUICourse:_courseArrayOffLine];//2区添加八大课程体系
        [self addUICategory:_categoryArrayOffLine];
        [self addUITrade:_tradeArrayOffLine];
        


    }];
}

//1区
#pragma mark 创建scrollView
-(void)addUIBanner{
    //添加滑动背景
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-104)];
    self.backScrollView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.backScrollView];
    self.backScrollView.contentSize =CGSizeMake(kWidth, 608+EIGHTH);
    self.backScrollView.bounces=NO;
    self.backScrollView.showsHorizontalScrollIndicator =NO;
    self.backScrollView.showsVerticalScrollIndicator=NO;
    //顶部广告视图
    _bannerView = [[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0,kWidth,BANNER)];
    _bannerView.delegate = self;
    _bannerView.datasource = self;
    _bannerView.continuous = YES;
    _bannerView.autoPlayTimeInterval = 3;
    [self.backScrollView addSubview:_bannerView];
    
    UIView *topLine =[[UIView alloc]initWithFrame:CGRectMake(0, BANNER, kWidth, .5)];
    [self.backScrollView addSubview:topLine];
    topLine.backgroundColor =HexRGB(0xe9eaec);
    
}
//2八大课程体系
-(void)addUICourse:(NSMutableArray *)course{
   
//    NSLog(@"ffffffff%@",course);

   
    for (int c=0; c<course.count; c++)
    {
        homeViewControllModel *homeModel =[course objectAtIndex:c];
//        NSLog(@"-----%@",homeModel.courseImgurl);

        CGFloat courseBorderW = 35;//边界宽
        CGFloat courseBorderH = 5;//边界高
        CGFloat betweenW = 39;// 间距宽
        CGFloat imageWith =(kWidth-courseBorderW*2-betweenW *3)/4; //图片宽
        
        UIImageView *courseImage =[[UIImageView alloc]init];
        courseImage.frame =CGRectMake(courseBorderW+c%4*(betweenW+imageWith),4+courseBorderH+ BANNER+c/4*(23+courseBorderH+(kWidth-courseBorderW*2-betweenW*3)/4), imageWith,imageWith);
        [courseImage setBackgroundColor:[UIColor lightGrayColor]];
        courseImage.layer.cornerRadius =(kWidth-courseBorderW*2-betweenW*3)/8;
        courseImage.layer.masksToBounds=YES;
        courseImage.image =placeHoderImage1;
        
        [_backScrollView addSubview:courseImage];
        
        UIButton *courseButtTitle =[UIButton buttonWithType:UIButtonTypeCustom];
        
        courseButtTitle.frame =CGRectMake(courseBorderW-5+c%4*(courseImage.frame.size.width+betweenW), courseImage.frame.origin.y+30+c/4, imageWith+10, 30);
        [self.backScrollView addSubview:courseButtTitle];
        [courseButtTitle setTitle:homeModel.courseName forState:UIControlStateNormal];
        [courseButtTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        courseButtTitle.titleLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [courseButtTitle setTitleColor:HexRGB(0x404040) forState:UIControlStateNormal];
        [courseButtTitle setBackgroundColor:[UIColor clearColor]];
        
        
        UIButton *courseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        courseBtn.frame =CGRectMake(courseBorderW-10+c%4*(imageWith+betweenW), courseImage.frame.origin.y+c/4, 50,60);
        [courseBtn setTitle:self.noticeArray[c] forState:UIControlStateNormal  ];
        [courseBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_backScrollView addSubview:courseBtn];
        courseBtn.tag =100+c;
        courseImage.userInteractionEnabled = NO;
        [courseImage setImageWithURL:[NSURL URLWithString:homeModel.courseImgurl]placeholderImage:placeHoderImage1];
        [courseBtn addTarget:self action:@selector(eightCourseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
}
//2、八大课程体系按钮
-(void)eightCourseBtnClick:(UIButton *)cate{
    if (_courseArray.count ==0) {
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }else{
   
    homeViewControllModel *homeModel =[_courseArray objectAtIndex:cate.tag-100];
    
    CourseEightController *courseEightVc=[[CourseEightController alloc]init];
    courseEightVc.courseID =[NSString stringWithFormat:@"%d",homeModel.courseId];
    [self.nav pushViewController:courseEightVc animated:YES];
    }
}
//
//3、添加需求
-(void)addUICategory:(NSMutableArray *)category
{
    CGFloat needHeight =45+BANNER+EIGHTH;
    for (int l=0; l<3; l++) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, needHeight+l%2*(NEEDH+24+27), kWidth, 12)];
        
        if (l==2) {
            lineView.frame =CGRectMake(0, _backScrollView.contentSize.height-12, kWidth, 12);
        }
        [self.backScrollView addSubview:lineView];
        lineView.backgroundColor =HexRGB(0xeeeee9);
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, .5)];
        [lineView addSubview:line];
        line.backgroundColor =HexRGB(0xcacaca);
        
        
    }
    for (int t=0; t<2; t++) {
        NSArray *titleArray =@[@" 按需求 ",@" 按行业"];
        NSArray *imgArray =@[[UIImage imageNamed:@"needImg"],[UIImage imageNamed:@"businessImg"]];
        UIButton* titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame =CGRectMake(15, needHeight+12+t%2*(NEEDH+24+27), kWidth-20, 37 );
        [self.backScrollView addSubview:titleBtn];
        [titleBtn setImage:imgArray[t] forState:UIControlStateNormal];
        [titleBtn setTitle:titleArray[t] forState:UIControlStateNormal];
        [titleBtn setTitleColor:HexRGB(0x404040) forState:UIControlStateNormal];
        titleBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:PxFont(18)]];
        [titleBtn setBackgroundColor:[UIColor clearColor]];
        
    }
    
    UIView *needBackView =[[UIView alloc]initWithFrame:CGRectMake(0, needHeight+50-0.5, kWidth, NEEDH+1.5)];
    [self.backScrollView addSubview:needBackView];
    needBackView.backgroundColor =HexRGB(0xeaebec);
//    needBackView.backgroundColor =[UIColor redColor];
    for (int i=0; i<category.count; i++) {
        
        homeViewControllModel *homeModel =[category objectAtIndex:i];

        UIButton* needBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.backScrollView addSubview:needBtn];
        [needBtn setImage:placeHoderImage2 forState:UIControlStateNormal];
        [needBtn .titleLabel setFont:[UIFont systemFontOfSize:PxFont(18)]];
        [needBtn setImageWithURL:[NSURL URLWithString:homeModel.categoryImgurl] forState:UIControlStateNormal placeholderImage:placeHoderImage2];
        [needBtn setTitle:homeModel.categoryName forState:UIControlStateNormal];
        [needBtn setTitleColor:HexRGB(0x404040) forState:UIControlStateNormal];
        needBtn.backgroundColor =[UIColor whiteColor];
        
        
        UILabel *  needLabel =[[UILabel alloc]init];
        needLabel.backgroundColor =[UIColor clearColor];
        needLabel.text =homeModel.categorySubTitle;
        [self.backScrollView addSubview:needLabel];
        needLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        needLabel.textColor =HexRGB(0x9a9a9a);
        needLabel.textAlignment=NSTextAlignmentRight;
        
        if (i==0) {
            needBtn.frame =CGRectMake(0, needHeight+50, kWidth-150, 90);
            [needBtn .titleLabel setFont:[UIFont systemFontOfSize:PxFont(25)]];
            needBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 30, 0);
            needLabel.frame =CGRectMake(0, needHeight+90, kWidth-160, 20);
            [needBtn setImage:placeHoderImage4 forState:UIControlStateNormal];

            
        }else if (i==1){
            needBtn.frame =CGRectMake(kWidth-149.25, needHeight+50, 150, 44.5);
            needBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 20, 0);
            needLabel.frame =CGRectMake(kWidth-149.25, needHeight+70, 130, 20);

        }else if (i==2){
            needBtn.frame =CGRectMake(kWidth-149.5, needHeight+50+45, 150, 45);
            needBtn.titleEdgeInsets =UIEdgeInsetsMake(0, -80, 0, 0);
            needBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 80, 0, 0);

            
        }else{
            needBtn.frame =CGRectMake(i%3*(kWidth/3+.5), needHeight+50+90.5, kWidth/3, 45.5);
        }
        [needBtn addTarget:self action:@selector(needBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        needBtn.tag =i+NEEDTAG;
        
    }
    
    
    
}
//4、添加行业
-(void)addUITrade:(NSMutableArray *)trade{
    
    UIView *needBackView =[[UIView alloc]initWithFrame:CGRectMake(0, NEEDH+BANNER+EIGHTH+144, kWidth, BUSINESS-.5)];
    [self.backScrollView addSubview:needBackView];
    needBackView.backgroundColor =HexRGB(0xeaebec);
//        needBackView.backgroundColor =[UIColor redColor];
    for (int i=0; i<trade.count; i++) {
        homeViewControllModel *homeModel =[trade objectAtIndex:i];
//        NSLog(@"%@---%2----%@---%@",homeModel.tradeImgurl,homeModel.tradeName,homeModel.tradeSubTitle);
        UIButton* businessBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        businessBtn.frame =CGRectMake(i%2*(kWidth/2+.5),NEEDH+ BANNER+EIGHTH+144.5+i/2*60.5, (kWidth)/2, 60 );
        [self.backScrollView addSubview:businessBtn];
        businessBtn.titleEdgeInsets =UIEdgeInsetsMake(-10, -(kWidth)/3, 0, 0);
        businessBtn.imageEdgeInsets =UIEdgeInsetsMake(0, (kWidth)/4, 0, 0);
        [businessBtn setImage:placeHoderImage2 forState:UIControlStateNormal];
        [businessBtn setImageWithURL:[NSURL URLWithString:homeModel.tradeImgurl] forState:UIControlStateNormal placeholderImage:placeHoderImage2];
        [businessBtn setTitle:homeModel.tradeName forState:UIControlStateNormal];
        [businessBtn setTitleColor:HexRGB(0x404040) forState:UIControlStateNormal];
        [businessBtn .titleLabel setFont:[UIFont systemFontOfSize:PxFont(19)]];
        businessBtn.backgroundColor =[UIColor whiteColor];
        
        [businessBtn addTarget:self action:@selector(businessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        businessBtn.tag =i+50;
        
        UILabel *subTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(42+i%2*(kWidth/2), NEEDH+BANNER+EIGHTH+158+i/2*60, kWidth/2, 60)];
        [self.backScrollView addSubview:subTitleLabel];
        subTitleLabel.text =homeModel.tradeSubTitle;
        [subTitleLabel setTextColor:HexRGB(0x9a9a9a)];
        subTitleLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        subTitleLabel.backgroundColor =[UIColor clearColor];
        

    }
    
}
//3、需求
-(void)needBtnClick:(UIButton *)more{
    if (_categoryArray.count==0) {
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }else{
        homeViewControllModel *homeModel =[_categoryArray objectAtIndex:more.tag-NEEDTAG];
        if (more.tag==NEEDTAG) {
            NineBlockController *nineVc =[[NineBlockController alloc]init];
            nineVc.nineBlockID =[NSString stringWithFormat:@"%d",homeModel.categoryId];
            nineVc.navTitle =homeModel.categoryName;
            [self.nav pushViewController:nineVc animated:YES];
        }else if (more.tag ==NEEDTAG+1 ){
            ThreeBlockController *ThreeVc =[[ThreeBlockController alloc]init];
            ThreeVc.threeId =[NSString stringWithFormat:@"%d",homeModel.categoryId];
            ThreeVc.navTitle =homeModel.categoryName;
            [self.nav pushViewController:ThreeVc animated:YES];
        }else{
            NeedViewController *needVc =[[NeedViewController alloc]init];
            needVc.categoryId =[NSString stringWithFormat:@"%d",homeModel.categoryId];
            needVc.navTitle =homeModel.categoryName;
            [self.nav pushViewController:needVc animated:YES];
        }
    }
   
}
//行业
-(void)businessBtnClick:(UIButton *)sender{
    if (_tradeArray.count==0) {
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }else{
    homeViewControllModel *homeModel =[_tradeArray objectAtIndex:sender.tag-50];
    
    BusinessController *businessVC=[[BusinessController alloc]init];
    businessVC.tradeId =[NSString stringWithFormat:@"%d",homeModel.tradeId];
        businessVC.navTitle =homeModel.tradeName;
    [self.nav pushViewController:businessVC animated:YES];
    }
}
#pragma mark KDCycleBannerView_delegate

-(void)addADSimageBtn:(NSMutableArray *)tody
{
    // 创建图片 imageview
    for (int i = 0;i<[tody count];i++)
    {
        homeViewControllModel *ads =[tody objectAtIndex:i];
        [_slideImages addObject:ads.imgurl];
        
    }
}
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return _slideImages;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index
{
    return UIViewContentModeScaleAspectFill;
}

//广告占位图
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index
{
    return placeHoderImage;
}

//选中广告的第几张图片
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
//        homeViewControllModel *item = [_adsImage objectAtIndex:index];
//        BannerDetailController *detail = [[BannerDetailController alloc] init];
//        detail.urlStr = item.content;
//        [self.navigationController pushViewController:detail animated:YES];
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
