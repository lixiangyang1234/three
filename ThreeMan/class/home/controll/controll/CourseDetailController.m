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

#define BANNERH         167   //banner高度
#define YYBORDERWH        8  //外边界
#define borderw            5 //内边界
#define BUTTONH           40  //按钮高度
#define  NETFAILIMGWH  165   //没有数据的图片宽高
@interface CourseDetailController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,byCourseViewDelegate,UIWebViewDelegate>
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
    
    UIButton *topBtn;
    byCourseView *byCourse;
    byCourseView *bySuccessCourse;
    byCourseView *byFailCourse;
    byCourseView *byCompanyCourse;

    CGFloat webh;
    CGFloat cellContentH;
}

@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,strong)NSString *douNumber;
@property(nonatomic,strong)UIWebView *courseWeb;

@end

@implementation CourseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe6e3e4);
    [self setLeftTitle:@"课程详情"];
    self.detailArray =[NSMutableArray array];
    self.recommendArray =[NSMutableArray array];
    self.answerArray =[NSMutableArray array];
    _bySuccessCode =0;
    _byFailStr=@"";
    _bySuccessStr=@"";
    [self addMBprogressView];
    [self addLoadStatus];
    
//    [self addRecommendLoadStatus];
    // Do any additional setup after loading the view.
}
-(void)addTopBtn
{
    //回顶部按钮
    topBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topBtn];
    topBtn.frame =CGRectMake(kWidth-50, kHeight-80-64, 30, 30);
    [topBtn setTitle:@"23" forState:UIControlStateNormal];
    topBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    topBtn.hidden =YES;
    [topBtn setImage:[UIImage imageNamed:@"nav_return_pre"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBtn setTitle:@"定都" forState:UIControlStateNormal];
    [topBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [topBtn.titleLabel setFont:[UIFont systemFontOfSize:PxFont(12)]];
    topBtn.tag =997;
    
}
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
}
#pragma mark ---添加数据
-(void)addLoadStatus{
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:_courseDetailID,@"id", nil];
    [HttpTool postWithPath:@"getNeedDetail" params:paramDic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSLog(@"%@",JSON);
        if (code==100) {
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
        [self addUICategoryView];
        [self addTopBtn];
    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
        [failView removeFromSuperview];

        [self notNetFailView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}
-(void)addRecommendLoadStatus{
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:_courseDetailID,@"id", nil];

    [HttpTool postWithPath:@"getRecommendList" params:paramDic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (code == 100) {
            NSDictionary *dic = [JSON objectForKey:@"data"];
            NSArray *array = [dic objectForKey:@"recommend_list"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    [_recommendArray removeAllObjects];
                    [_answerArray removeAllObjects];

                    courseDetailModel *item = [[courseDetailModel alloc] initWithDictnoaryForCourseRecommend:dict];
                    [_recommendArray addObject:item];
                }
            }
            [recommendTableView reloadData];
        }
        if (_recommendArray.count<=0) {
            [failView removeFromSuperview];
            [self notByRecommend];
            [recommendTableView setHidden:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
 
    }];
}
-(void)addAnswerLoadStatus{
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:_courseDetailID,@"id", nil];
    
    [HttpTool postWithPath:@"getQuestionList" params:paramDic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (code == 100) {
            NSDictionary *dic = [JSON objectForKey:@"data"];
            NSLog(@"%@",JSON);
            NSArray *array = [dic objectForKey:@"question_list"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    [_recommendArray removeAllObjects];
                    [_answerArray removeAllObjects];
                    courseDetailModel *item = [[courseDetailModel alloc] initWithDictnoaryForCourseAnswer:dict];
                    [_answerArray addObject:item];
                }
            }
            
            [answerTableView reloadData];
        }
        if (_answerArray.count<=0) {
            [failView removeFromSuperview];
            [self notByAnswer];
            [answerTableView setHidden:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
 
    }];
}
-(void)addByLoadStatus{
   
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
    
    for (int p=0; p<3; p++)
    {
        NSArray *companyArr =@[@"详情",@"推荐(88)",@"答疑"];
        UIButton *companyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [categoryView addSubview:companyBtn];
        
        [companyBtn setTitleColor:HexRGB(0x9a9a9a) forState:UIControlStateNormal];
        [companyBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateSelected];
        
        [companyBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
        companyBtn.frame =CGRectMake(0+p%3*kWidth/3, 0, (kWidth-YYBORDERWH*2)/3, BUTTONH);
        companyBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
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
    categoryScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, bannerHeightLine+BUTTONH, kWidth, kHeight-BUTTONH-50-64+YYBORDERWH)];
    categoryScrollView.contentSize = CGSizeMake(kWidth*3, categoryScrollView.frame.size.height);
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
    //    detailScrollView.bounces = NO;
    detailScrollView.userInteractionEnabled = YES;
    detailScrollView.backgroundColor =HexRGB(0xffffff);
    //    detailScrollView.backgroundColor =[UIColor cyanColor];
    detailScrollView.delegate = self;
    [categoryScrollView addSubview:detailScrollView];
    detailScrollView.tag =990;
    CGFloat detailWH =11;
    //添加标题
    UILabel *detailTitle =[[UILabel alloc]initWithFrame:CGRectMake(detailWH, detailWH, kWidth-detailWH*2-YYBORDERWH*2, 30)];
    [detailScrollView addSubview:detailTitle];
    detailTitle.text =courseModel.courseTitle;
    detailTitle.font =[UIFont systemFontOfSize:PxFont(22)];
    detailTitle.textColor=HexRGB(0x323232);
    
    CGFloat titleDetailH =detailTitle.frame.size.height+detailTitle.frame.origin.y;
    //添加蜕变豆
    
    UIButton *detailDou =[UIButton buttonWithType:UIButtonTypeCustom];
    detailDou.frame =CGRectMake(detailWH, titleDetailH, 50, 30);
    [detailDou setImage:[UIImage imageNamed:@"browser_number_icon"] forState:UIControlStateNormal];
    [detailDou setTitle:[NSString stringWithFormat:@"%d", courseModel.coursePrice] forState:UIControlStateNormal];
    [detailScrollView addSubview:detailDou];
    detailDou.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, 0);
    detailDou.backgroundColor =[UIColor clearColor];
    [detailDou setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [detailDou.titleLabel setFont:[UIFont systemFontOfSize:PxFont(28)]];
    detailDou.backgroundColor =[UIColor clearColor];
    detailDou.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    CGFloat douDetailW =detailDou.frame.size.width+detailDou.frame.origin.x+3;
    UILabel *detailDouLabel =[[UILabel alloc]initWithFrame:CGRectMake(douDetailW, titleDetailH, 45, 30)];
    [detailScrollView addSubview:detailDouLabel];
    detailDouLabel.text =@"蜕变豆";
    detailDouLabel.font =[UIFont systemFontOfSize:PxFont(18)];
    detailDouLabel.textColor=HexRGB(0x323232);
    detailDouLabel.backgroundColor =[UIColor clearColor];
    
    CGFloat companyHomeW =douDetailW+detailDouLabel.frame.size.width+10;
    //企业首页
    UIButton *companyHomeDetail =[UIButton buttonWithType:UIButtonTypeCustom];
    companyHomeDetail.frame =CGRectMake(companyHomeW, titleDetailH, kWidth-companyHomeW-detailWH*2, 25);
    [companyHomeDetail setBackgroundImage:[UIImage imageNamed:@"company_name"] forState:UIControlStateNormal];
    [detailScrollView addSubview:companyHomeDetail];
    [companyHomeDetail setTitle:courseModel.courseCompanyname forState:UIControlStateNormal];
    companyHomeDetail.titleEdgeInsets =UIEdgeInsetsMake(0, 28, 0, 10);
    companyHomeDetail.backgroundColor =[UIColor clearColor];
    [companyHomeDetail setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [companyHomeDetail.titleLabel setFont:[UIFont systemFontOfSize:PxFont(16)]];
    companyHomeDetail.backgroundColor =[UIColor clearColor];
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

#pragma mark 推荐
-(void)addRecommendTableview
{
    recommendTableView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth-YYBORDERWH*2, 0, kWidth,categoryScrollView.frame.size.height-8 ) style:UITableViewStylePlain];
    recommendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [categoryScrollView addSubview:recommendTableView];
    recommendTableView.backgroundColor =[UIColor whiteColor];
    recommendTableView.showsHorizontalScrollIndicator =NO;
    recommendTableView.showsVerticalScrollIndicator= NO;
    recommendTableView.delegate =self;
    recommendTableView.dataSource = self;
    recommendTableView.hidden =NO;
}



#pragma mark 答疑
-(void)addAnswerTableview
{
//    [self notByAnswer];
    answerTableView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, categoryScrollView.frame.size.height-8) style:UITableViewStylePlain];
    answerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [categoryScrollView addSubview:answerTableView];
    answerTableView.backgroundColor =[UIColor whiteColor];
    answerTableView.delegate =self;
    answerTableView.dataSource = self;
    answerTableView.showsHorizontalScrollIndicator =NO;
    answerTableView.showsVerticalScrollIndicator= NO;
    answerTableView.hidden =NO;
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
    {
        [self addRecommendTableview];
        [self addMBprogressView];
        [self addRecommendLoadStatus];
        //        _footer.scrollView = recommendTableView;
        [categoryScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
    }
    else if(sender.tag ==22)
    {
        [self addAnswerTableview];
        [self addMBprogressView];

        [self addAnswerLoadStatus];
        //        _footer.scrollView = answerTableView;
        [categoryScrollView setContentOffset:CGPointMake(kWidth*2, 0) animated:YES];
    }
    
    
}


//添加底部下载  download  buyCourse collect
-(void)addUIDownloadView{
    courseDetailModel *couseModel =[_detailArray objectAtIndex:0];
    UIView *downloadView =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-64-50, kWidth, 50)];
    [self.view addSubview:downloadView];
    downloadView.backgroundColor =[UIColor whiteColor];
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 1)];
    [downloadView addSubview:line];
    line.backgroundColor =HexRGB(0xd1d1d1);
    
    //添加标题
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(23, 27, 40, 20)];
    [downloadView addSubview:titleLabel];
    titleLabel.font =[UIFont systemFontOfSize:PxFont(16)];
    titleLabel.textColor =HexRGB(0x1c8cc6);
    titleLabel.backgroundColor =[UIColor clearColor];
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.text =[NSString stringWithFormat:@"( %d )",couseModel.courseDownloadnum];
    
    
    for (int i=0; i<3; i++) {
        UIButton *categoryBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [downloadView addSubview:categoryBtn];
        categoryBtn.backgroundColor =[UIColor clearColor];
        if (i==0) {
            categoryBtn.frame =CGRectMake(23, 5, 40, 40) ;
            [categoryBtn setImage:[UIImage imageNamed:@"tab_download"] forState:UIControlStateNormal];
            categoryBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 0, 10, 0);
        }if (i==1) {
            categoryBtn.frame =CGRectMake(83, 9, 160, 32) ;
            [categoryBtn setBackgroundImage:[UIImage imageNamed:@"buy_img"] forState:UIControlStateNormal];
            
            [categoryBtn setTitle:@"购买课程" forState:UIControlStateNormal];
            [categoryBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
            
        }if (i==2) {
            categoryBtn.frame =CGRectMake(kWidth-63, 5, 40, 40) ;
            [categoryBtn setImage:[UIImage imageNamed:@"tab_collect"] forState:UIControlStateNormal];
            [categoryBtn setImage:[UIImage imageNamed:@"tab_collect_pre"] forState:UIControlStateSelected];
            courseDetailModel *coureseModel =[_detailArray objectAtIndex:0];
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
    if (_selectedBtn.tag ==21) {
        static NSString *cellIndexfider =@"RecommendCell";
        
        CourseRecommendViewCell *RecommandCell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
        if (!RecommandCell) {
            RecommandCell =[[CourseRecommendViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            [RecommandCell setBackgroundColor:HexRGB(0xe0e0e0)];
            RecommandCell.selectionStyle =UITableViewCellSelectionStyleNone;

        }
        courseDetailModel *recommendModel =[_recommendArray objectAtIndex:indexPath.row];
        [RecommandCell.headerRecommendImage setImageWithURL:[NSURL URLWithString:recommendModel.recommendImg] placeholderImage:placeHoderImage1];
       
        RecommandCell.nameRecomendLabel.text =recommendModel.recommendUseame;
        RecommandCell.contentRecomendLabel.text =recommendModel.recommendContent;
        RecommandCell.timeRecomendLabel.text =recommendModel.recommednAddtime;
//        NSLog(@"----%@",recommendModel.recommednAddtime);
        
        
        if (indexPath.row>=8) {
            topBtn.hidden =NO;
        }else if (indexPath.row<=4){
            topBtn.hidden =YES;
        }
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
        answerCell.answerTitle.text =answerModel.answerTitle;
        [answerCell.companyAnswerImage setImageWithURL:[NSURL URLWithString:answerModel.answerImg] placeholderImage:placeHoderImage1];
         cellContentH =[answerModel.answerContent sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(self.view.frame.size.width-33, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping ].height;
        answerCell.contentAnswerLabel.frame =CGRectMake(11, 40, self.view.frame.size.width-33, cellContentH);
//        NSLog(@"---%f---->%f",cellContentH,self.view.frame.size.width-33);
        answerCell.timeAnswerLabel.text =answerModel.answerAddtime;
        answerCell.nameAnswerLabel.text =answerModel.answerName;
        answerCell.contentAnswerLabel.text =answerModel.answerContent;
        
        if (indexPath.row>=8) {
            topBtn.hidden =NO;
        }else if (indexPath.row<=4){
            topBtn.hidden =YES;
        }
        return answerCell;
        
    }
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CompanyHomeControll *companyHomeVC=[[CompanyHomeControll alloc]init];
    [self.navigationController pushViewController:companyHomeVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedBtn.tag ==21) {
        return 118;
    }else if(_selectedBtn.tag ==22){
        return 80+cellContentH;
    }
    return 118;
}

#pragma mark  ------scrollview_delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag ==998||scrollView.tag ==990) {
//        NSLog(@"%f----%f",scrollView.contentOffset.y,bannerHeightLine);
        if (scrollView.contentOffset.y>=bannerHeightLine) {
            //            scrollView.contentOffset =CGPointMake(0, 0);
            topBtn.hidden =NO;
            for (UIView *subView in self.view.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *top =(UIButton *)subView;
                    if (top.tag ==997) {
                        top.hidden =NO;
                        topBtn.hidden =NO;
                    }
                    
                }
            }
            
        }
        
        if (scrollView.contentOffset.y<=bannerHeightLine-20) {
            //            scrollView.contentOffset =CGPointMake(0, 0);
            topBtn.hidden =NO;
            for (UIView *subView in self.view.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *top =(UIButton *)subView;
                    if (top.tag ==997) {
                        top.hidden =YES;
                        topBtn.hidden =YES;
                    }
                    
                }
            }
            
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
                        [self addMBprogressView];
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
                        [self addMBprogressView];
                        [self addAnswerLoadStatus];
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
    if (item.tag ==30) {
        
    }else if (item.tag ==31){
        [self addByTopView];
 
    }else if(item.tag ==32){
    if (item.selected ==YES)  // uncollectSubject   collectSubject
      {
            NSString *str =@"23456";
            NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:str,@"uid",_courseDetailID,@"id" ,nil];
//        NSLog(@"%@",[SystemConfig sharedInstance].uid);
            [HttpTool postWithPath:@"uncollectSubject" params:paramDic success:^(id JSON, int code, NSString *msg) {
//                NSLog(@"%@",JSON);
                if (code ==100) {
                    [RemindView showViewWithTitle:@"取消收藏成功!" location:BELLOW];
                    item.selected =NO;
                }
            } failure:^(NSError *error) {
                
            }];
      }  else{
          NSString *str =@"23456";
          NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:str,@"uid",_courseDetailID,@"id" ,nil];
//          NSLog(@"%@",[SystemConfig sharedInstance].uid);
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

            }else if(code==206) {
                _byFailStr =JSON[@"msg"];
                NSArray *titleArr =@[@"取消",@"立即充值"];
                byFailCourse =[[byCourseView alloc]initWithFrame:self.view.bounds byTitle:@"购买失败" contentLabel:_byFailStr buttonTitle:titleArr TagType:555];
                byFailCourse.delegate =self;
                [self.view addSubview:byFailCourse];
                byFailCourse.hidden =NO;
            }else{
                _byFailStr =JSON[@"msg"];
                NSArray *titleArr =@[@"否",@"是"];
                byCompanyCourse =[[byCourseView alloc]initWithFrame:self.view.bounds byTitle:@"购买提示" contentLabel:_byFailStr buttonTitle:titleArr TagType:666];
                byCompanyCourse.delegate =self;
                [self.view addSubview:byCompanyCourse];
                byCompanyCourse.hidden =NO;
            }
//            NSLog(@"%@--000---%@------%d",_bySuccessStr,_byFailStr,_bySuccessCode);
        } failure:^(NSError *error) {
            
        }];

        
    }if (tag ==444) {
        [UIView animateWithDuration:.3 animations:^{
            bySuccessCourse.center =CGPointMake(kWidth/2, kHeight);
            
        } completion:^(BOOL finished) {
            bySuccessCourse.hidden =YES;
        }];
    }else if (tag ==445){
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
-(void)topBtnClick:(UIButton *)top{
    [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [detailScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    NSIndexPath *indePath =[NSIndexPath indexPathForRow:0 inSection:0];
    [recommendTableView scrollToRowAtIndexPath:indePath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [answerTableView scrollToRowAtIndexPath:indePath atScrollPosition:UITableViewScrollPositionNone animated:YES];

}

-(void)companyhomeDetailBtnClick:(UIButton *)sender{
    CompanyHomeControll *companyHomeVC=[[CompanyHomeControll alloc]init];
    [self.navigationController pushViewController:companyHomeVC animated:YES];
}
// 推荐 没有推荐
-(void)notByRecommend{
    

    failView =[[NetFailView alloc]initWithFrameForDetail:CGRectMake((kWidth-NETFAILIMGWH)/2, kHeight-64-165-50, NETFAILIMGWH, NETFAILIMGWH) backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"抱歉！该需求暂时还没有推荐！"];
    [self.view addSubview:failView];
}
// 答疑 没有购买课程
-(void)notByAnswer{
    failView =[[NetFailView alloc]initWithFrameForDetail:CGRectMake((kWidth-NETFAILIMGWH)/2, kHeight-64-165-50, NETFAILIMGWH, NETFAILIMGWH) backImage:[UIImage imageNamed:@"netFailImg_2"] promptTitle:@"抱歉！您还未购买该课程！点击下方“购买”按钮购买！"];
    [self.view addSubview:failView];
}
//没有网络
-(void)notNetFailView{
    NetFailView *failView =[[NetFailView alloc]initWithFrame:self.view.bounds backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"对不起，网络不给力!请检查您的网络设置! "];
    [self.view addSubview:failView];
}
@end
