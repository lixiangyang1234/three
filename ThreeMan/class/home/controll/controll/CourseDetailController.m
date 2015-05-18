//
//  CourseDetailController.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseDetailController.h"
#import "CompanyHomeControll.h"
#import "CourseRecommendViewCell.h"
#import "CourseAnswerViewCell.h"
#import "byCourseView.h"
#import "courseDetailModel.h"
#import "DownloadManager.h"
#import "PayViewController.h"
#import "AdaptationSize.h"
#define pageSize 6
#define BANNERH         167   //banner高度
#define YYBORDERWH        8  //外边界
#define borderw            5 //内边界
#define BUTTONH           40  //按钮高度
#define  NETFAILIMGWH  165   //没有数据的图片宽高
@interface CourseDetailController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,byCourseViewDelegate,UIWebViewDelegate,MJRefreshBaseViewDelegate>
{
    NetFailView *failView;
    UIView *_orangLin;
    UIScrollView *_scrollView;
    UIView *categoryView;
    UIButton *_selectedBtn;
    UIScrollView *categoryScrollView;
    CGFloat bannerHeightLine   ;
    
    UIScrollView * detailScrollView;
    UITableView *recommendTableView;
    UITableView * answerTableView;
    
    byCourseView *byCourse;
    byCourseView *bySuccessCourse;
    byCourseView *byFailCourse;
    byCourseView *byCompanyCourse;
    
    
    CGFloat webh;
    CGFloat cellContentH;
    CGFloat RecommandCellH;
    NSString *recommendCount;
    BOOL isRefresh;
    MJRefreshHeaderView *refreshHeaderView;
    MJRefreshFooterView *refreshFooterView;
    
}

@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,strong)NSString *douNumber;
@property(nonatomic,strong)UIWebView *courseWeb;

@end

@implementation CourseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe0e0e0);
    refreshFooterView =[[MJRefreshFooterView alloc]init];
    refreshFooterView.delegate =self;
    
    refreshHeaderView =[[MJRefreshHeaderView alloc]init];
    refreshHeaderView.delegate =self;
    
    [self setLeftTitle:@"课程详情"];
    self.detailArray =[NSMutableArray array];
    self.recommendArray =[NSMutableArray array];
    self.answerArray =[NSMutableArray array];
    _bySuccessCode =0;
    _byFailStr=@"";
    _bySuccessStr=@"";
    
    [self addMBprogressView];
    [self addRecommendLoadStatus];
    [self addLoadStatus];
    
    NSLog(@"%f------%f",kWidth,kHeight);
    // Do any additional setup after loading the view.
}
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        isRefresh =YES;
        [self addRecommendLoadStatus];
        [self refreshFooterView];
        
    }else{
        isRefresh =NO;
        [self addRecommendLoadStatus];
        [self refreshFooterView];
        
        
    }
}
#pragma mark ---添加数据
-(void)addLoadStatus{
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:_courseDetailID,@"id", nil];
    [HttpTool postWithPath:@"getNeedDetail" params:paramDic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [failView removeFromSuperview];
        
        NSLog(@"%@",JSON);
        if (code==100) {
            [failView removeFromSuperview];
            
            NSDictionary *dict =JSON[@"data"][@"subject_detail"];
            if (![dict isKindOfClass:[NSNull class]]) {
                courseDetailModel *courseModel =[[courseDetailModel alloc]initWithDictnoaryForCourseDetail:dict];
                [_detailArray addObject:courseModel];
            }
        }
        
        [failView removeFromSuperview];
        
        [self addUIBannerView];
        [self addUICategoryView];
        [self addUIDownloadView];
        [self addCategoryBackScrollView];
        
    } failure:^(NSError *error) {
        //        NSLog(@"%@",error);
        [failView removeFromSuperview];
        
        [self notNetFailView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}
-(void)addRecommendLoadStatus{
    NSDictionary *param;
    if (isRefresh) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_recommendArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID};
    }else{
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID,};
    }
    if (!isRefresh) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    
    [HttpTool postWithPath:@"getRecommendList" params:param success:^(id JSON, int code, NSString *msg) {
                NSLog(@"------>%@",JSON);
        if (isRefresh) {
            [refreshFooterView endRefreshing];
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [refreshHeaderView endRefreshing];
            [_recommendArray removeAllObjects];
            
        }
        
        
        if (code == 100) {
            NSDictionary *dic = [JSON objectForKey:@"data"];
            NSArray *array = [dic objectForKey:@"recommend_list"];
            recommendCount=[dic objectForKey:@"recommend_count"];
            //            NSLog(@"----->%@",array);
            
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    courseDetailModel *item = [[courseDetailModel alloc] initWithDictnoaryForCourseRecommend:dict];
                    [_recommendArray addObject:item];
                    if (array.count<pageSize) {
                        refreshFooterView.hidden = YES;
//                        [RemindView showViewWithTitle:@"数据加载完毕！" location:BELLOW];
                    }else{
                        refreshFooterView.hidden = NO;
                    }
                }
            }else{
                refreshFooterView.hidden =NO;
            }
            [recommendTableView reloadData];
        }
        if (_recommendArray.count<=0) {
            [failView removeFromSuperview];
            [self notByRecommend];
            [recommendTableView setHidden:YES];
        }
        //        [self addUICategoryView];
    } failure:^(NSError *error) {
        if (isRefresh) {
            [refreshFooterView endRefreshing];
        }else{
            [refreshHeaderView endRefreshing];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
    }];
}
-(void)refreshFooterView{
    NSDictionary *param;
    if (isRefresh) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_answerArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID};
    }else{
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID,};
    }
    if (!isRefresh) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    
    
    [HttpTool postWithPath:@"getQuestionList" params:param success:^(id JSON, int code, NSString *msg) {
        if (isRefresh) {
            [refreshFooterView endRefreshing];
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [refreshHeaderView endRefreshing];
            
            
            [_answerArray removeAllObjects];
        }
        
        NSLog(@"-----ddddddddd----》%@",JSON);
        
        if (code == 100) {
            NSDictionary *dic = [JSON objectForKey:@"data"];
            NSArray *array = [dic objectForKey:@"question_list"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    
                    courseDetailModel *item = [[courseDetailModel alloc] initWithDictnoaryForCourseAnswer:dict];
                    [_answerArray addObject:item];
                    if (array.count<pageSize) {
                        refreshFooterView.hidden = YES;
//                        [RemindView showViewWithTitle:@"数据加载完毕！" location:BELLOW];
                    }else{
                        refreshFooterView.hidden = NO;
                    }
                }
            }else{
                refreshFooterView.hidden = NO;
                
            }
            
            [answerTableView reloadData];
        }
        if (_answerArray.count<=0) {
            [failView removeFromSuperview];
            [self notByAnswer];
            [answerTableView setHidden:YES];
        }
    } failure:^(NSError *error) {
        if (isRefresh) {
            [refreshFooterView endRefreshing];
        }else{
            [refreshHeaderView endRefreshing];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}


//添加广告图片
-(void)addUIBannerView{
    courseDetailModel *courseModel =[_detailArray objectAtIndex:0];
    //添加滑动背景
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(YYBORDERWH, YYBORDERWH, kWidth-YYBORDERWH*2, kHeight-YYBORDERWH)];
    self.backScrollView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.backScrollView];
    self.backScrollView.bounces=NO;
    self.backScrollView.showsHorizontalScrollIndicator =NO;
    self.backScrollView.showsVerticalScrollIndicator=NO;
    self.backScrollView.tag =998;
    self.backScrollView.delegate =self;
    
    UIImageView *bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderw, borderw, self.backScrollView.frame.size.width-borderw*2, BANNERH)];
    [self.backScrollView addSubview:bannerImage];
    bannerImage.backgroundColor =[UIColor clearColor];
    bannerImage.userInteractionEnabled=YES;
    [bannerImage setImageWithURL:[NSURL URLWithString:courseModel.courseImgurl] placeholderImage:placeHoderImage];
    //添加8像素高度灰条
    
    UIView *eightView =[[UIView alloc]initWithFrame:CGRectMake(0, borderw*2+BANNERH, kWidth-YYBORDERWH*2, 8)];
    [self.backScrollView addSubview:eightView];
    eightView.backgroundColor =HexRGB(0xeeeee9);
    
    bannerHeightLine =eightView.frame.size.height+eightView.frame.origin.y;
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-YYBORDERWH*2, 1)];
    [eightView addSubview:line];
    line.backgroundColor =HexRGB(0xcacaca);
    
    
    
    self.backScrollView.contentSize =CGSizeMake(kWidth-YYBORDERWH*2, kHeight+bannerHeightLine);
    
    
    
    
}
#pragma  mark =====添加分类滑动
-(void)addUICategoryView{
    
    
    categoryView =[[UIView alloc]initWithFrame:CGRectMake(0, bannerHeightLine, kWidth-YYBORDERWH*2, BUTTONH)];
    [self.backScrollView addSubview:categoryView];
    categoryView.backgroundColor =HexRGB(0xf8f8f8);
    
    UIView *categoryLine =[[UIView alloc]initWithFrame:CGRectMake(0, BUTTONH-1, kWidth, 1)];
    categoryLine.backgroundColor =HexRGB(0xe9eaec);
    
    [categoryView addSubview:categoryLine];
    NSString *recommendStr =[NSString stringWithFormat:@"推荐（%@）",recommendCount==nil ? @"0" :recommendCount];
    NSArray *companyArr =@[@"详情",recommendStr,@"答疑"];
    for (int p=0; p<3; p++)
    {
        
        UIButton *companyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [categoryView addSubview:companyBtn];
        
        [companyBtn setTitleColor:HexRGB(0x9a9a9a) forState:UIControlStateNormal];
        [companyBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateSelected];
        
        [companyBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
        companyBtn.frame =CGRectMake(0+p%3*kWidth/3, 0, (kWidth-YYBORDERWH*2)/3, BUTTONH);
        companyBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [companyBtn setTitle:companyArr[p] forState:UIControlStateNormal];
        
        companyBtn.tag =20+p;
        
        if (companyBtn.tag ==20)
        {
            companyBtn.selected = YES;
            _selectedBtn = companyBtn;
            
        }
        [companyBtn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    _orangLin =[[UIView alloc]init];
    [self.backScrollView addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, bannerHeightLine+BUTTONH-2, (kWidth-YYBORDERWH*2)/3, 2);
    _orangLin.backgroundColor =HexRGB(0x1c8cc6);
}
#pragma mark分类背景CategoryScrollview
-(void)addCategoryBackScrollView
{
    categoryScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, bannerHeightLine+BUTTONH, kWidth, kHeight-BUTTONH-50-64)];
    categoryScrollView.contentSize = CGSizeMake(kWidth*3, kHeight-BUTTONH-50-64-YYBORDERWH);
    categoryScrollView.showsHorizontalScrollIndicator = NO;
    categoryScrollView.showsVerticalScrollIndicator = NO;
    categoryScrollView.pagingEnabled = YES;
    categoryScrollView.bounces = YES;
    categoryScrollView.tag = 9999;
    categoryScrollView.userInteractionEnabled = YES;
    categoryScrollView.backgroundColor =HexRGB(0xffffff);
    categoryScrollView.backgroundColor =[UIColor clearColor];
    
    categoryScrollView.delegate = self;
    [self.backScrollView addSubview:categoryScrollView];
    [self addDetailView];
    
}
#pragma mark----详情
-(void)addDetailView{
    courseDetailModel *courseModel =[_detailArray objectAtIndex:0];
    detailScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth-YYBORDERWH*2, categoryScrollView.frame.size.height)];
    detailScrollView.contentSize = CGSizeMake(kWidth-YYBORDERWH*2, 500);
    detailScrollView.showsHorizontalScrollIndicator = NO;
    detailScrollView.showsVerticalScrollIndicator = NO;
    detailScrollView.pagingEnabled = YES;
    //        detailScrollView.bounces = NO;
    detailScrollView.userInteractionEnabled = YES;
    detailScrollView.backgroundColor =HexRGB(0xffffff);
    //    detailScrollView.backgroundColor =[UIColor cyanColor];
    detailScrollView.delegate = self;
    [categoryScrollView addSubview:detailScrollView];
    detailScrollView.scrollEnabled =NO;
    detailScrollView.tag =990;
    CGFloat detailWH =9;
    //添加标题
    UILabel *detailTitle =[[UILabel alloc]initWithFrame:CGRectMake(detailWH, detailWH, kWidth-detailWH*2-YYBORDERWH*2, 20)];
    [detailScrollView addSubview:detailTitle];
    detailTitle.text =courseModel.courseTitle;
    detailTitle.font =[UIFont systemFontOfSize:PxFont(18)];
    detailTitle.textColor=HexRGB(0x323232);
    detailTitle.backgroundColor =[UIColor clearColor];
    CGFloat titleDetailH =detailTitle.frame.size.height+detailTitle.frame.origin.y+5;
    //添加蜕变豆
    //    RecommandCellH =[recommendModel.recommendContent sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(self.view.frame.size.width-33, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ].height;
    
    CGFloat douW =[[NSString stringWithFormat:@"%d", courseModel.coursePrice] sizeWithFont:[UIFont systemFontOfSize:PxFont(24)]constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width;
    UIButton *detailDou =[UIButton buttonWithType:UIButtonTypeCustom];
    detailDou.frame =CGRectMake(detailWH, titleDetailH, douW+30, 30);
    [detailDou setImage:[UIImage imageNamed:@"browser_number_icon"] forState:UIControlStateNormal];
    [detailDou setTitle:[NSString stringWithFormat:@"%d", courseModel.coursePrice] forState:UIControlStateNormal];
    [detailScrollView addSubview:detailDou];
    detailDou.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, 0);
    detailDou.backgroundColor =[UIColor clearColor];
    [detailDou setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [detailDou.titleLabel setFont:[UIFont systemFontOfSize:PxFont(24)]];
    detailDou.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    CGFloat douDetailW =detailDou.frame.size.width+detailDou.frame.origin.x;
    UILabel *detailDouLabel =[[UILabel alloc]initWithFrame:CGRectMake(douDetailW, titleDetailH+3, 45, 30)];
    [detailScrollView addSubview:detailDouLabel];
    detailDouLabel.text =@"蜕变豆";
    detailDouLabel.font =[UIFont systemFontOfSize:PxFont(14)];
    detailDouLabel.textColor=HexRGB(0x323232);
    detailDouLabel.backgroundColor =[UIColor clearColor];
    
    CGFloat companyHomeW =douDetailW+detailDouLabel.frame.size.width;
    //企业首页
    CGFloat homeNameW =[courseModel.courseCompanyname sizeWithFont:[UIFont systemFontOfSize:PxFont(14)]constrainedToSize:CGSizeMake(MAXFLOAT, 19)].width;
    
    UIButton *companyHomeDetail =[UIButton buttonWithType:UIButtonTypeCustom];
    companyHomeDetail.frame =CGRectMake(companyHomeW, titleDetailH+6, homeNameW+10, 19);
    [detailScrollView addSubview:companyHomeDetail];
    [companyHomeDetail setTitle:courseModel.courseCompanyname forState:UIControlStateNormal];
    companyHomeDetail.titleEdgeInsets =UIEdgeInsetsMake(0, 20, 0, 5);
    [companyHomeDetail setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [companyHomeDetail.titleLabel setFont:[UIFont systemFontOfSize:PxFont(12)]];
    companyHomeDetail.backgroundColor =[UIColor clearColor];
    companyHomeDetail.layer.masksToBounds =YES;
    companyHomeDetail.layer.borderColor =HexRGB(0x178ac5).CGColor;
    companyHomeDetail.layer.borderWidth=0.8f;
    companyHomeDetail.layer.cornerRadius =10;
    //banner图片
    UIImageView *companyHomeImg =[[UIImageView alloc]initWithFrame:CGRectMake(-1, 0,19 , 19)];
    [companyHomeDetail addSubview:companyHomeImg];
    companyHomeImg.userInteractionEnabled=YES;
    companyHomeImg.image =[UIImage imageNamed:@"company_name"];
    [companyHomeDetail addTarget:self action:@selector(companyhomeDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat eightH =detailDou.frame.size.height+detailDou.frame.origin.y+borderw;
    //添加8像素高度灰条
    UIView *eightView =[[UIView alloc]initWithFrame:CGRectMake(0, eightH, kWidth-YYBORDERWH*2, 8)];
    [detailScrollView addSubview:eightView];
    eightView.backgroundColor =HexRGB(0xeeeee9);
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-YYBORDERWH*2, 1)];
    [eightView addSubview:line];
    line.backgroundColor =HexRGB(0xcacaca);
    webh =eightH+borderw+8;
    
    //添加WebView
    _courseWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, webh, kWidth-YYBORDERWH*2, kHeight-webh-64)];
    
    [_courseWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    _courseWeb.userInteractionEnabled = NO;
    _courseWeb.delegate =self;
    [detailScrollView addSubview:_courseWeb];
    //    NSLog(@"1111-----%f----%f",_courseWeb.frame.size.height,detailScrollView.contentSize.height);
    
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGFloat webheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    
    _courseWeb.frame = CGRectMake(0, webh, kWidth-YYBORDERWH*2, webheight);
    
    detailScrollView.contentSize = CGSizeMake(kWidth-YYBORDERWH*2,webheight+webh);
    
    //    NSLog(@"-----%f-%f---%f",_courseWeb.frame.size.height,detailScrollView.frame.size.height,webheight);
    
}

#pragma mark ----推荐
-(void)addRecommendTableview
{
    recommendTableView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth-YYBORDERWH*2, 0, kWidth,categoryScrollView.frame.size.height ) style:UITableViewStylePlain];
    recommendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [categoryScrollView addSubview:recommendTableView];
    recommendTableView.backgroundColor =HexRGB(0xe0e0e0);
    recommendTableView.showsHorizontalScrollIndicator =NO;
    recommendTableView.showsVerticalScrollIndicator= NO;
    recommendTableView.delegate =self;
    recommendTableView.dataSource = self;
    recommendTableView.hidden =NO;
//    recommendTableView.scrollEnabled =NO;
    refreshHeaderView.scrollView=recommendTableView;
    refreshFooterView.scrollView =recommendTableView;
    
}



#pragma mark----- 答疑
-(void)addAnswerTableview
{
    //    [self notByAnswer];
    answerTableView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, categoryScrollView.frame.size.height) style:UITableViewStylePlain];
    answerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [categoryScrollView addSubview:answerTableView];
    answerTableView.backgroundColor =HexRGB(0xe0e0e0);
    answerTableView.delegate =self;
    answerTableView.dataSource = self;
    answerTableView.showsHorizontalScrollIndicator =NO;
    answerTableView.showsVerticalScrollIndicator= NO;
    answerTableView.hidden =NO;
//    answerTableView.scrollEnabled =NO;
    refreshFooterView.scrollView =answerTableView;
    refreshHeaderView.scrollView =answerTableView;
    
}
#pragma mark ----分类的点击事件
//添加分类
-(void)categoryBtnClick:(UIButton *)sender{
    //    NSLog(@"dddd;;");
    _selectedBtn = sender;
    if (sender.tag == 20)
    {
        [self addDetailView];
        [self addLoadStatus];
        //        _footer.scrollView = _allTableView;
        [categoryScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(sender.tag ==21)
    {isRefresh =NO;
        [self addRecommendTableview];
        //        [self addMBprogressView];
        [self addRecommendLoadStatus];
        //        _footer.scrollView = recommendTableView;
        [categoryScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
    }
    else if(sender.tag ==22)
    {
        [self addAnswerTableview];
        
        //        [self addMBprogressView];
        isRefresh =NO;
        [self refreshFooterView];
        //        _footer.scrollView = answerTableView;
        [categoryScrollView setContentOffset:CGPointMake(kWidth*2, 0) animated:YES];
    }
    
    
}


//添加底部下载  download  buyCourse collect
-(void)addUIDownloadView{
    courseDetailModel *couseModel =[_detailArray objectAtIndex:0];
    UIView *downloadView =[[UIView alloc]initWithFrame:CGRectMake(YYBORDERWH, kHeight-64-50, kWidth-YYBORDERWH*2, 50)];
    [self.view addSubview:downloadView];
    downloadView.backgroundColor =[UIColor whiteColor];
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-YYBORDERWH*2, 1)];
    [downloadView addSubview:line];
    line.backgroundColor =HexRGB(0xd1d1d1);
    
    //添加标题
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 27, 50, 20)];
    [downloadView addSubview:titleLabel];
    titleLabel.font =[UIFont systemFontOfSize:PxFont(16)];
    titleLabel.textColor =HexRGB(0x1c8cc6);
    titleLabel.backgroundColor =[UIColor clearColor];
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.text =[NSString stringWithFormat:@"(%d)",couseModel.courseDownloadnum];
    
    
    for (int i=0; i<3; i++) {
        courseDetailModel *coureseModel =[_detailArray objectAtIndex:0];
        
        UIButton *categoryBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [downloadView addSubview:categoryBtn];
        categoryBtn.backgroundColor =[UIColor clearColor];
        if (i==0) {
            categoryBtn.frame =CGRectMake(20, 5, 40, 40) ;
            [categoryBtn setImage:[UIImage imageNamed:@"tab_download"] forState:UIControlStateNormal];
            categoryBtn.enabled =NO;
            
            categoryBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 0, 10, 0);
        }if (i==1) {
            categoryBtn.frame =CGRectMake(80, 9, kWidth-160, 32) ;
            categoryBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
            [categoryBtn setBackgroundImage:[UIImage imageNamed:@"buy_img"] forState:UIControlStateNormal];
            NSLog(@"------111111-----》%d",coureseModel.courseIsbuy);
            if (coureseModel.coursePrice <=0||coureseModel.courseIsbuy==1) {
                [categoryBtn setTitle:@"立即下载" forState:UIControlStateNormal];
            }else{
                [categoryBtn setTitle:@"购买课程" forState:UIControlStateNormal];
                
            }
            [categoryBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
            
        }if (i==2) {
            categoryBtn.frame =CGRectMake(kWidth-66, 5, 40, 40) ;
            [categoryBtn setImage:[UIImage imageNamed:@"tab_collect"] forState:UIControlStateNormal];
            [categoryBtn setImage:[UIImage imageNamed:@"tab_collect_pre"] forState:UIControlStateSelected];
            if (coureseModel.iscollect ==1) {
                categoryBtn.selected =YES;
            }else if (coureseModel.iscollect ==0){
                categoryBtn.selected =NO;
                
            }
        }
        [categoryBtn addTarget:self action:@selector(categoryBtnItem:) forControlEvents:UIControlEventTouchUpInside];
        categoryBtn.tag =i+30;
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectedBtn.tag==21) {
        return _recommendArray.count;
    }if (_selectedBtn.tag==22) {
        return _answerArray.count;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%d",_selectedBtn.tag);
    static NSString *cellIndex =@"cellIndexfier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cellIndex) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndex];
    }
    if (_selectedBtn.tag ==21) {
        static NSString *cellIndexfider =@"RecommendCell";
        
        CourseRecommendViewCell *RecommandCell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
        if (!RecommandCell) {
            RecommandCell =[[CourseRecommendViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            [RecommandCell setBackgroundColor:HexRGB(0xe0e0e0)];
            RecommandCell.selectionStyle =UITableViewCellSelectionStyleNone;
            
        }
        
        courseDetailModel *recommendModel =[_recommendArray objectAtIndex:indexPath.row];
        [RecommandCell setObjectRecommendItem:recommendModel];
        return RecommandCell;
        
    }else if (_selectedBtn.tag ==22){
        static NSString *cellIndexfider =@"AnswerCell";
        
        CourseAnswerViewCell *answerCell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
        if (!answerCell) {
            answerCell =[[CourseAnswerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            [answerCell setBackgroundColor:HexRGB(0xe0e0e0)];
            answerCell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        courseDetailModel *answerModel =[_answerArray objectAtIndex:indexPath.row];
        [answerCell setObjectCell:answerModel ];
        
        return answerCell;
        
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectedBtn.tag ==21) {
        return [self getCellHeight:indexPath typeStr:1];
    }else if(_selectedBtn.tag ==22){
        return [self getCellHeight:indexPath typeStr:2];
    }
    return 0;
}
#pragma mark 获取cell的高度
- (CGFloat)getCellHeight:(NSIndexPath *)indexPath typeStr:(NSInteger)type
{      if (type==1){
        CGFloat cellHeight = 0;
        courseDetailModel *recomModel =[_recommendArray objectAtIndex:indexPath.row];
        CGSize size = [AdaptationSize getSizeFromString:recomModel.recommendContent Font:[UIFont systemFontOfSize:PxFont(16)] withHight:CGFLOAT_MAX withWidth:kWidth-33];
     CGSize nameRecommendSize =[AdaptationSize getSizeFromString:recomModel.recommendUseame Font:[UIFont systemFontOfSize:PxFont(18)] withHight:CGFLOAT_MAX withWidth:kWidth-YYBORDERWH*2-130];
        //        NSLog(@"fffff------11111------>>>%f",size.height);
        cellHeight =55+size.height+nameRecommendSize.height;
        return cellHeight;
    }
    if (type==2) {
        CGFloat cellHeight = 0;
        courseDetailModel *answerModel =[_answerArray objectAtIndex:indexPath.row];
        CGSize size = [AdaptationSize getSizeFromString:answerModel.answerContent Font:[UIFont systemFontOfSize:PxFont(18)] withHight:CGFLOAT_MAX withWidth:kWidth-33];
        cellHeight =80+size.height;
        return cellHeight;
        
    }
    return 0;
}

#pragma mark  ------scrollview_delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag ==998) {
        //        NSLog(@"%f----%f",scrollView.contentOffset.y,bannerHeightLine);
        if (scrollView.contentOffset.y>=175) {
            //            scrollView.contentOffset =CGPointMake(0, 0);
            detailScrollView.scrollEnabled =YES;
//            recommendTableView.scrollEnabled =YES;
//            answerTableView.scrollEnabled =YES;
        }else{
            detailScrollView.scrollEnabled =NO;
//            recommendTableView.scrollEnabled =NO;
//            answerTableView.scrollEnabled =NO;
            
        }
        
        
    }
    
    if (scrollView.tag ==9999) {
        if (scrollView.contentOffset.x <=0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (scrollView.contentOffset.x >= kWidth*2) {
            scrollView.contentOffset = CGPointMake(kWidth*2, 0);
        }
        [UIView animateWithDuration:0.01 animations:^{
            _orangLin.frame = CGRectMake(scrollView.contentOffset.x/3,bannerHeightLine+BUTTONH-2, kWidth/3, 2);
        }];
        
        
        if (scrollView.contentOffset.x==0) {
            
            //            _footer.scrollView = _allTableView;
            for (UIView *subView in categoryView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==20) {
                        _selectedBtn=btn;
                        _selectedBtn.selected = YES;
                        [self addLoadStatus];
                    }else{
                        btn.selected = NO;
                    }
                }
            }
            
        }else if(scrollView.contentOffset.x==kWidth){
            //            _footer.scrollView = recommendTableView;
            for (UIView *subView in categoryView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==21) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                        [self addRecommendTableview];
                        //                        [self addMBprogressView];
                        isRefresh =NO;
                        [self addRecommendLoadStatus];
                        
                        
                    }else{
                        btn.selected = NO;
                    }
                    
                }
            }
        }
        else if(scrollView.contentOffset.x==kWidth*2){
            
            //            _footer.scrollView = answerTableView;
            for (UIView *subView in categoryView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==22) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                        [self addAnswerTableview];
                        //                        [self addMBprogressView];
                        isRefresh =NO;
                        [self refreshFooterView];
                    }else{
                        btn.selected = NO;
                    }
                    
                }
            }
        }
        //        [self addLoadStatus];
        
    }
    
}
#pragma mark -----topView

//购买支付
-(void)addByTopView{
    NSArray *titleArr =@[@"取消",@"支付"];
    courseDetailModel *courseModel =[_detailArray objectAtIndex:0];
    NSString *str =[NSString stringWithFormat:@"您本次需要支付%d蜕变豆，确认支付吗？",courseModel.coursePrice];
    byCourse =[[byCourseView alloc]initWithFrame:self.view.bounds byTitle:@"购买提示" contentLabel:str buttonTitle:titleArr TagType:333 ];
    byCourse.delegate =self;
    [self.view addSubview:byCourse];
    byCourse.hidden =NO;
}

#pragma mark---购买课程
-(void)categoryBtnItem:(UIButton *)item{
    courseDetailModel *courseModel =[_detailArray objectAtIndex:0];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:courseModel.courseImgurl,@"imgurl",[NSString stringWithFormat:@"%d",courseModel.courseId],@"id",courseModel.courseTitle,@"title" ,nil];
    
    if (item.tag ==30) {
        
    }else if (item.tag ==31){
        if (![SystemConfig sharedInstance].isUserLogin) {
            [RemindView showViewWithTitle:@"抱歉，请先点击右上角注册或登录！" location:BELLOW] ;
            
            
        }else if([[SystemConfig sharedInstance].uid isEqualToString:[NSString stringWithFormat:@"%d", courseModel.companyId]]){
            [RemindView showViewWithTitle:@"抱歉，请以普通会员身份购买！" location:BELLOW] ;
        }else if (courseModel.coursePrice <=0||courseModel.courseIsbuy==1) {
            
            [DownloadManager downloadFileWithUrl:courseModel.courseDownloadurl type:[NSString stringWithFormat:@"%d",courseModel.courseType] fileInfo:dic];
            //            [RemindView showViewWithTitle:@"已经加入下载列表" location:BELLOW];
        }
        else{
            [self addByTopView];
            
        }
        
    }else if(item.tag ==32){
        
        if (![SystemConfig sharedInstance].isUserLogin ) {
            [RemindView showViewWithTitle:@"抱歉，请先点击右上角注册或登录！" location:BELLOW];
        }else{
            if (item.selected ==YES)  // uncollectSubject   collectSubject
            {
                
                NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].uid,@"uid",_courseDetailID,@"id" ,nil];
                [HttpTool postWithPath:@"uncollectSubject" params:paramDic success:^(id JSON, int code, NSString *msg) {
                    //                NSLog(@"%@",JSON);
                    if (code ==100) {
                        [RemindView showViewWithTitle:@"取消收藏成功!" location:BELLOW];
                        item.selected =NO;
                    }
                } failure:^(NSError *error) {
                    
                }];
            }  else{
                NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].uid,@"uid",_courseDetailID,@"id" ,nil];
                [HttpTool postWithPath:@"collectSubject" params:paramDic success:^(id JSON, int code, NSString *msg) {
                    //              NSLog(@"-----%@",JSON);
                    if (code ==100) {
                        [RemindView showViewWithTitle:@"收藏成功!" location:BELLOW];
                        item.selected =YES;
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
            
            
        }
    }
}
-(void)chooseBtn:(UIButton *)choose chooseTag:(NSInteger)tag{
    [UIView animateWithDuration:.3 animations:^{
        byCourse.center =CGPointMake(kWidth/2, kHeight);
        
    } completion:^(BOOL finished) {
        byCourse.hidden =YES;
    }];
    
    if (tag==333) {
        
    }else if (tag==334){
        NSDictionary *parmDic =[NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].uid,@"uid",_courseDetailID,@"id", nil];
        NSLog(@"%@",[SystemConfig sharedInstance].uid);
        [HttpTool postWithPath:@"buySubject" params:parmDic success:^(id JSON, int code, NSString *msg) {
            self.bySuccessCode =code;
            if (code==100) {
                
                _bySuccessStr =JSON[@"msg"];
                NSArray *titleArr =@[@"取消",@"确定"];
                bySuccessCourse =[[byCourseView alloc]initWithFrame:self.view.bounds byTitle:@"购买提示" contentLabel:_bySuccessStr buttonTitle:titleArr TagType:444 ];
                bySuccessCourse.delegate =self;
                [self.view addSubview:bySuccessCourse];
                bySuccessCourse.hidden =NO;
            }else  {
                _byFailStr =JSON[@"msg"];
                NSArray *titleArr =@[@"取消",@"立即充值"];
                byFailCourse =[[byCourseView alloc]initWithFrame:self.view.bounds byTitle:@"购买失败" contentLabel:_byFailStr buttonTitle:titleArr TagType:555];
                byFailCourse.delegate =self;
                [self.view addSubview:byFailCourse];
                byFailCourse.hidden =NO;
            }
        } failure:^(NSError *error) {
            
        }];
        
        
        
    }if (tag ==444) {
        [UIView animateWithDuration:.3 animations:^{
            bySuccessCourse.center =CGPointMake(kWidth/2, kHeight);
            
        } completion:^(BOOL finished) {
            bySuccessCourse.hidden =YES;
        }];
    }else if (tag ==445){
        NSLog(@"ddddddddd");
        [self viewDidLoad];
        
        [UIView animateWithDuration:.3 animations:^{
            bySuccessCourse.center =CGPointMake(kWidth/2, kHeight);
            
        } completion:^(BOOL finished) {
            bySuccessCourse.hidden =YES;
            
        }];
        
    }
    if (tag ==555) {
        [UIView animateWithDuration:.3 animations:^{
            byFailCourse.center =CGPointMake(kWidth/2, kHeight);
            
        } completion:^(BOOL finished) {
            byFailCourse.hidden =YES;
        }];
    }else if (tag ==556){
        PayViewController *payVc =[[PayViewController alloc]init];
        [self.navigationController pushViewController:payVc animated:YES];
        [UIView animateWithDuration:.3 animations:^{
            byFailCourse.center =CGPointMake(kWidth/2, kHeight);
            
        } completion:^(BOOL finished) {
            byFailCourse.hidden =YES;
        }];
    }if (tag ==666) {
        [UIView animateWithDuration:.3 animations:^{
            byCompanyCourse.center =CGPointMake(kWidth/2, kHeight);
            
        } completion:^(BOOL finished) {
            byCompanyCourse.hidden =YES;
        }];
    }else if (tag ==667){
        [UIView animateWithDuration:.3 animations:^{
            byCompanyCourse.center =CGPointMake(kWidth/2, kHeight);
            
        } completion:^(BOOL finished) {
            byCompanyCourse.hidden =YES;
        }];
    }
    
}


-(void)companyhomeDetailBtnClick:(UIButton *)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    courseDetailModel *courseModel =[_detailArray objectAtIndex:0];
    
    CompanyHomeControll *companyHomeVC=[[CompanyHomeControll alloc]init];
    companyHomeVC.companyId =[NSString stringWithFormat:@"%d", courseModel.companyId];
    [self.navigationController pushViewController:companyHomeVC animated:YES];
}
// 推荐 没有推荐
-(void)notByRecommend{
    
    failView =[[NetFailView alloc]initWithFrameForDetail:CGRectMake((kWidth-NETFAILIMGWH-YYBORDERWH*2)/2+kWidth, 15, NETFAILIMGWH, NETFAILIMGWH) backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"抱歉！该需求暂时还没有推荐！"];
    if (kHeight>500) {
        failView.frame =CGRectMake((kWidth-NETFAILIMGWH-YYBORDERWH*2)/2+kWidth, 100, NETFAILIMGWH, NETFAILIMGWH);
    }
    [categoryScrollView addSubview:failView];
}
// 答疑 没有购买课程
-(void)notByAnswer{
    courseDetailModel *courseModel =[_detailArray objectAtIndex:0];
    if (courseModel.courseIsbuy==1||courseModel.coursePrice==0) {
        failView =[[NetFailView alloc]initWithFrameForDetail:CGRectMake((kWidth-NETFAILIMGWH-YYBORDERWH*2)/2+kWidth*2, 15, NETFAILIMGWH, NETFAILIMGWH) backImage:[UIImage imageNamed:@"netFailImg_2"] promptTitle:@"抱歉！该需求暂时还没有答疑！"];
    }else {
        failView =[[NetFailView alloc]initWithFrameForDetail:CGRectMake((kWidth-NETFAILIMGWH-YYBORDERWH*2)/2+kWidth*2, 15, NETFAILIMGWH, NETFAILIMGWH) backImage:[UIImage imageNamed:@"netFailImg_2"] promptTitle:@"抱歉！您还未购买该课程！点击下方“购买”按钮购买！"];
    }
    if (kHeight>500) {
        failView.frame =CGRectMake((kWidth-NETFAILIMGWH-YYBORDERWH*2)/2+kWidth*2, 100, NETFAILIMGWH, NETFAILIMGWH);
    }
    
    [categoryScrollView addSubview:failView];
}
//没有网络
-(void)notNetFailView{
    failView =[[NetFailView alloc]initWithFrame:self.view.bounds backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"对不起，网络不给力!请检查您的网络设置! "];
    [self.view addSubview:failView];
}
@end
