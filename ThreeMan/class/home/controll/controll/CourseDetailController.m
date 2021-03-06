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
#import "courseDetailView.h"
#define pageSize 6
#define BANNERH         167   //banner高度
#define YYBORDERWH        8  //外边界
#define borderw            5 //内边界
#define BUTTONH           40  //按钮高度
#define  NETFAILIMGWH  165   //没有数据的图片宽高
@interface CourseDetailController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,byCourseViewDelegate,UIWebViewDelegate,MJRefreshBaseViewDelegate,courseDetailViewDelegate>
{
    NetFailView *failView;
    UIView *_orangLin;
    UIScrollView *_scrollView;
    UIView *categoryView;
    UIButton *_selectedBtn;

    UIScrollView *categoryScrollView;
    CGFloat bannerHeightLine   ;
    
    courseDetailView * detailScrollView;
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
    
    BOOL isRefresh1;
    MJRefreshHeaderView *refreshHeaderView1;
    MJRefreshFooterView *refreshFooterView1;
}

@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,strong)NSString *douNumber;
@property(nonatomic,strong)UIWebView *courseWeb;

@end

@implementation CourseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe0e0e0);
   
    
    [self setLeftTitle:@"课程详情"];
    self.detailArray =[NSMutableArray array];
    self.recommendArray =[NSMutableArray array];
    self.answerArray =[NSMutableArray array];
    _bySuccessCode =0;
    _byFailStr=@"";
    _bySuccessStr=@"";
    [self  addBackScrollView];
    
   
    
   

   // Do any additional setup after loading the view.
}
//添加广告图片
-(void)addBackScrollView{
    
    
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(YYBORDERWH, YYBORDERWH, kWidth-YYBORDERWH*2, kHeight-YYBORDERWH)];
    self.backScrollView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.backScrollView];
    self.backScrollView.bounces=NO;
    self.backScrollView.showsHorizontalScrollIndicator =NO;
    self.backScrollView.showsVerticalScrollIndicator=NO;
    self.backScrollView.tag =998;
    self.backScrollView.delegate =self;
    
    
    [self addLoadStatus];
    [self performSelector:@selector(recommendLoad) withObject:nil afterDelay:0.0f];
    [self performSelector:@selector(answerLoad) withObject:nil afterDelay:0.1f];
    [self addCategoryBackScrollView];

    [self addRecommendTableview];
    [self addAnswerTableview];
    [self addRefreshView];

}
-(void)recommendLoad{
    [self addRecommendLoadStatus1];

}
-(void)answerLoad{
    [self addAnswerStates];

}
-(void)addRefreshView{
    refreshHeaderView =[[MJRefreshHeaderView alloc]init];
    refreshHeaderView.delegate =self;
    
    refreshFooterView =[[MJRefreshFooterView alloc]init];
    refreshFooterView.delegate =self;
    refreshFooterView.scrollView=recommendTableView;
    refreshHeaderView.scrollView =recommendTableView;
    
    refreshHeaderView1 =[[MJRefreshHeaderView alloc]init];
    refreshHeaderView1.delegate =self;
    
    refreshFooterView1 =[[MJRefreshFooterView alloc]init];
    refreshFooterView1.delegate =self;
    refreshFooterView1.scrollView=answerTableView;
    refreshHeaderView1.scrollView =answerTableView;
}
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
        if (_selectedBtn.tag ==21) {
            if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
            isRefresh =YES;
            [self addRecommendLoadStatus];
            }else{
                isRefresh =NO;
                [self addRecommendLoadStatus];
            }
        
        }if (_selectedBtn.tag ==22) {
            if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
                isRefresh1 =YES;
                [self addAnswerStates];
            }else{
                isRefresh1 =NO;
                [self addAnswerStates];
            }
            
        }
}
#pragma mark ---添加数据
-(void)addLoadStatus{
    [self addMBprogressView];

    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:_courseDetailID,@"id", nil];
    [HttpTool postWithPath:@"getNeedDetail" params:paramDic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [failView removeFromSuperview];
        
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
        [self addDetailView];
        [self addUIDownloadView];
        
      
    } failure:^(NSError *error) {
        //        NSLog(@"%@",error);
        [failView removeFromSuperview];
        
        [self notNetFailView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}
-(void)addRecommendLoadStatus1{
    NSDictionary *param;
    if (isRefresh) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_recommendArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID};
    }else{
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID,};
    }
    
    
    [HttpTool postWithPath:@"getRecommendList" params:param success:^(id JSON, int code, NSString *msg) {
        //                NSLog(@"------>%@",JSON);
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
        }
        
        
        [self addUICategoryView];

        [recommendTableView reloadData];
    } failure:^(NSError *error) {
        if (isRefresh) {
            [refreshFooterView endRefreshing];
        }else{
            [refreshHeaderView endRefreshing];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
    }];
}
-(void)addRecommendLoadStatus{
    NSDictionary *param;
    if (isRefresh) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_recommendArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID};
    }else{
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID,};
    }
    
    
    [HttpTool postWithPath:@"getRecommendList" params:param success:^(id JSON, int code, NSString *msg) {
//                NSLog(@"------>%@",JSON);
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
        }
        if (_recommendArray.count<=0) {
//            [failView removeFromSuperview];
            [self notByRecommend];
            [recommendTableView setHidden:YES];
        }
        

        [recommendTableView reloadData];
    } failure:^(NSError *error) {
        if (isRefresh) {
            [refreshFooterView endRefreshing];
        }else{
            [refreshHeaderView endRefreshing];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
    }];
}
-(void)addAnswerStates{
    NSDictionary *param;
    if (isRefresh1) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_answerArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID};
    }else{
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_courseDetailID,};
    }
    
    
    [HttpTool postWithPath:@"getQuestionList" params:param success:^(id JSON, int code, NSString *msg) {
        if (isRefresh1) {
            [refreshFooterView1 endRefreshing];
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [refreshHeaderView1 endRefreshing];
            
            
            [_answerArray removeAllObjects];
        }
        
//        NSLog(@"-----ddddddddd----》%@",JSON);
        
        if (code == 100) {
            NSDictionary *dic = [JSON objectForKey:@"data"];
            NSArray *array = [dic objectForKey:@"question_list"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    
                    courseDetailModel *item = [[courseDetailModel alloc] initWithDictnoaryForCourseAnswer:dict];
                    [_answerArray addObject:item];
                    if (array.count<pageSize) {
                        refreshFooterView1.hidden = YES;
//                        [RemindView showViewWithTitle:@"数据加载完毕！" location:BELLOW];
                    }else{
                        refreshFooterView1.hidden = NO;
                    }
                }
            }else{
                refreshFooterView1.hidden = NO;
                
            }
            
            
        }
        
        [answerTableView reloadData];
    } failure:^(NSError *error) {
        if (isRefresh1) {
            [refreshFooterView1 endRefreshing];
        }else{
            [refreshHeaderView1 endRefreshing];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}



-(void)addUIBannerView{
    if (_detailArray.count==0) {
        return;
    }
    courseDetailModel *courseModel =[_detailArray objectAtIndex:0];   //添加滑动背景
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
    
    
    categoryView =[[UIView alloc]initWithFrame:CGRectMake(0, 185, kWidth-YYBORDERWH*2, BUTTONH)];
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
    _orangLin.frame =CGRectMake(0, 185+BUTTONH-2, (kWidth-YYBORDERWH*4)/3, 2);
    _orangLin.backgroundColor =HexRGB(0x1c8cc6);
}
#pragma mark分类背景CategoryScrollview
-(void)addCategoryBackScrollView
{
    categoryScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 185+BUTTONH, kWidth, kHeight-BUTTONH-50-64)];
    categoryScrollView.contentSize = CGSizeMake(kWidth*3, kHeight-BUTTONH-50-64-YYBORDERWH);
    categoryScrollView.showsHorizontalScrollIndicator = NO;
    categoryScrollView.showsVerticalScrollIndicator = NO;
    categoryScrollView.pagingEnabled = YES;
    categoryScrollView.bounces = NO;
    categoryScrollView.tag = 9999;
    categoryScrollView.userInteractionEnabled = YES;
    categoryScrollView.backgroundColor =HexRGB(0xffffff);
    categoryScrollView.backgroundColor =[UIColor clearColor];
    
    categoryScrollView.delegate = self;
    [self.backScrollView addSubview:categoryScrollView];
    
}
#pragma mark----详情
-(void)addDetailView{
    if (_detailArray.count==0) {
        return;
    }
    courseDetailModel *courseModel =[_detailArray objectAtIndex:0];
    
    detailScrollView =[[courseDetailView alloc]initWithFrame:CGRectMake(0, 0, kWidth, categoryScrollView.frame.size.height) statusLoad:courseModel];
    detailScrollView.scroll =self;
    [categoryScrollView addSubview:detailScrollView];

}

#pragma mark ----推荐
-(void)addRecommendTableview
{
    recommendTableView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth,categoryScrollView.frame.size.height ) style:UITableViewStylePlain];
    recommendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [categoryScrollView addSubview:recommendTableView];
    recommendTableView.backgroundColor =HexRGB(0xe0e0e0);
    recommendTableView.showsHorizontalScrollIndicator =NO;
    recommendTableView.showsVerticalScrollIndicator= NO;
    recommendTableView.delegate =self;
    recommendTableView.dataSource = self;
    recommendTableView.hidden =NO;
    
}

#pragma mark----- 答疑
-(void)addAnswerTableview
{
    answerTableView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, categoryScrollView.frame.size.height) style:UITableViewStylePlain];
    answerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [categoryScrollView addSubview:answerTableView];
    answerTableView.backgroundColor =HexRGB(0xe0e0e0);
    answerTableView.delegate =self;
    answerTableView.dataSource = self;
    answerTableView.showsHorizontalScrollIndicator =NO;
    answerTableView.showsVerticalScrollIndicator= NO;
    answerTableView.hidden =NO;
    
}
#pragma mark ----分类的点击事件

//添加分类
-(void)categoryBtnClick:(UIButton *)sender{
    _selectedBtn.selected =NO;
    sender.selected =YES;
     _selectedBtn = sender;
    if (_selectedBtn.tag == 20)
    {
        [categoryScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

        self.backScrollView.contentOffset=CGPointMake(0, 0);
    }
    else if(_selectedBtn.tag ==21)
    {
         isRefresh =NO;
        if (_recommendArray.count<=0) {
            [failView removeFromSuperview];
            [self notByRecommend];
            [recommendTableView setHidden:YES];
        }
        [recommendTableView reloadData];
        [categoryScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
    }
    else if(_selectedBtn.tag ==22)
    {
         isRefresh1 =NO;
        if (_answerArray.count<=0) {
            [failView removeFromSuperview];
            [self notByAnswer];
            [answerTableView setHidden:YES];
        }
        [answerTableView reloadData];
        
       
        [categoryScrollView setContentOffset:CGPointMake(kWidth*2, 0) animated:YES];
    }
    
    NSLog(@"%d",_selectedBtn.selected);
   
}


//添加底部下载  download  buyCourse collect
-(void)addUIDownloadView{
    if (_detailArray.count==0) {
        return;
    }
    courseDetailModel *couseModel =[_detailArray objectAtIndex:0];
    UIView *downloadView =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-64-50, kWidth, 50)];
    [self.view addSubview:downloadView];
    downloadView.backgroundColor =[UIColor whiteColor];
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
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
    static NSString *cellIndex =@"cellIndexfier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (cell==nil) {
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
        
    } if (_selectedBtn.tag ==22){
        static NSString *cellIndexfider =@"AnswerCell";
        
        CourseAnswerViewCell *answerCell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
        if (!answerCell) {
            answerCell =[[CourseAnswerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            [answerCell setBackgroundColor:HexRGB(0xe0e0e0)];
            answerCell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        if (_answerArray.count<=0) {
            return nil;
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
    
        //        NSLog(@"fffff------11111------>>>%f",size.height);
        cellHeight =55+size.height+15;
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
        if (scrollView.contentOffset.y>=175) {
            detailScrollView.scrollEnabled =YES;
        }else{
            detailScrollView.scrollEnabled =NO;
            
        }
        
        
    }
    
    if (scrollView.tag ==9999) {
//        if (scrollView.contentOffset.x <=0) {
//
//            scrollView.contentOffset = CGPointMake(0, 0);
//        }
//        
//        if (scrollView.contentOffset.x >= kWidth*2) {
//
//            scrollView.contentOffset = CGPointMake(kWidth*2, 0);
//        }
        [UIView animateWithDuration:0.01 animations:^{
            _orangLin.frame = CGRectMake((scrollView.contentOffset.x-YYBORDERWH*2)/3,bannerHeightLine+BUTTONH-2, (kWidth-YYBORDERWH*2)/3, 2);
        }];
        
        if (scrollView.contentOffset.x==0) {
            for (UIView *subView in categoryView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==20) {
                        _selectedBtn=btn;
                        _selectedBtn.selected = YES;
                        self.backScrollView.contentOffset=CGPointMake(0, 0);
                    }
                    else{
                        btn.selected = NO;
                    }
                }
            }
            
        }else if(scrollView.contentOffset.x==kWidth){
            
            for (UIView *subView in categoryView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==21) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                        if (_recommendArray.count<=0) {
                            [failView removeFromSuperview];
                            [self notByRecommend];
                            [recommendTableView setHidden:YES];
                        }
                        [recommendTableView reloadData];
                        isRefresh =NO;
                       
                        
                    }else{
                        btn.selected = NO;
                    }
                    
                }
            }
        }
        else if(scrollView.contentOffset.x==kWidth*2){
            
            for (UIView *subView in categoryView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==22) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                        if (_answerArray.count<=0) {
                                        [failView removeFromSuperview];
                            [self notByAnswer];
                            [answerTableView setHidden:YES];
                        }
                        [answerTableView reloadData];
                        isRefresh1 =NO;
                        
                    }else{
                        btn.selected = NO;
                    }
                    
                }
            }
        }
        
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


-(void)companyHome{
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
    if (_detailArray.count>0) {
        courseDetailModel *courseModel =[_detailArray objectAtIndex:0];
        if (courseModel.courseIsbuy==1||courseModel.coursePrice==0) {
            failView =[[NetFailView alloc]initWithFrameForDetail:CGRectMake((kWidth-NETFAILIMGWH-YYBORDERWH*2)/2+kWidth*2, 15, NETFAILIMGWH, NETFAILIMGWH) backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"抱歉！该需求暂时还没有答疑！"];
        }else {
            failView =[[NetFailView alloc]initWithFrameForDetail:CGRectMake((kWidth-NETFAILIMGWH-YYBORDERWH*2)/2+kWidth*2, 15, NETFAILIMGWH, NETFAILIMGWH) backImage:[UIImage imageNamed:@"netFailImg_2"] promptTitle:@"抱歉！您还未购买该课程！点击下方“购买”按钮购买！"];
        }
        if (kHeight>500) {
            failView.frame =CGRectMake((kWidth-NETFAILIMGWH-YYBORDERWH*2)/2+kWidth*2, 100, NETFAILIMGWH, NETFAILIMGWH);
        }
        
        [categoryScrollView addSubview:failView];
    }
    
}
//没有网络
-(void)notNetFailView{
    failView =[[NetFailView alloc]initWithFrame:self.view.bounds backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"对不起，网络不给力!请检查您的网络设置! "];
    [self.view addSubview:failView];
}

@end
