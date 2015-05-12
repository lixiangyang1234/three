//
//  CompanyHomeControll.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompanyHomeControll.h"
#import "CompanyHomeViewCell.h"
#import "CourseDetailController.h"
#import "companyListModel.h"
#define KStartY 20
#define BannerH  195
#define pageSize 6
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface CompanyHomeControll ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    ErrorView *networkError;
    NetFailView *failView;
    UIImageView *headerImage;
    
    UITableView *_tableView;
    CGFloat starY;
    UIImageView *alpha;
    UIView *animationView;
    MJRefreshFooterView *refreshFooterView;
    MJRefreshHeaderView *refreshHeaderView;
    BOOL isRefresh;
    
}
@end

@implementation CompanyHomeControll

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        starY = KStartY;
    }else
    {
        starY = 0;
    }
    
    [self.view setBackgroundColor:HexRGB(0xe0e0e0)];
    _companyArray =[NSMutableArray array];
    _companyLogeArray =[NSMutableArray array];
    isRefresh =NO;

    [self addErrorView];
    [self notCompanyStatuse];

    [self addRefreshView];

    [self addLoadStatus];
    // Do any additional setup after loading the view.
}
-(void)addRefreshView{
    refreshHeaderView =[[MJRefreshHeaderView alloc]init];
    refreshHeaderView.delegate =self;
    refreshHeaderView.scrollView =_tableView;
    
    refreshFooterView =[[MJRefreshFooterView alloc]init];
    refreshFooterView.delegate =self;
    refreshFooterView.scrollView=_tableView;
    
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        isRefresh =YES;
        [self addLoadStatus];
    }else{
        isRefresh =NO;
        [self addLoadStatus];
    }
}

#pragma mark=====添加数据
-(void)addLoadStatus{
    NSDictionary *paraDic;
    if (isRefresh) {
        paraDic =@{@"pageid" :[NSString stringWithFormat:@"%ld",(unsigned long)_companyArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_companyId };
    }else{
        paraDic =@{@"pageid" :@"0",@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"id":_companyId };
    }
    if (!isRefresh) {
        MBProgressHUD *progress =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progress.labelText =@"加载中。。。";
    }
//    NSDictionary *paraDic =[NSDictionary dictionaryWithObjectsAndKeys:_companyId,@"id", nil];
    NSLog(@"---->ffffff%@",paraDic);
    [HttpTool postWithPath:@"getCompanyCourseList" params:paraDic success:^(id JSON, int code, NSString *msg) {
        if (isRefresh) {
            [refreshFooterView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [refreshHeaderView endRefreshing];
            
        }
        if (!isRefresh) {
            [_companyArray removeAllObjects];
        }

                if (code==100) {
                    NSDictionary *dict =JSON[@"data"];
                    NSArray *arr =dict[@"subject_list"];
                    NSDictionary *dict1 =JSON[@"data"][@"company_info"];

            if (![arr isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dicArr in arr) {
                    companyListModel *businessModel =[[companyListModel alloc]initWithDictonaryForCompanyList:dicArr];
                    [_companyArray addObject:businessModel];
                    if (arr.count<pageSize) {
                        refreshFooterView.hidden =YES;
                        [RemindView showViewWithTitle:@"数据加载完毕！" location:MIDDLE];
                    }else{
                        refreshFooterView.hidden =NO;
                    }
                }
                companyListModel *businessModel =[[companyListModel alloc]initWithDictonaryForCompany_info:dict1];
                [_companyLogeArray addObject:businessModel];
                
                
            }
        }else{
            refreshFooterView.hidden =NO;
        }
            
//               NSLog(@"%@",JSON);
        [self addUIBannerView];
        [self addTableView];
        [_tableView reloadData];

        if (_companyArray.count<=0) {
            failView.hidden =NO;
        }else{
            failView.hidden =YES;
        }
    } failure:^(NSError *error) {
        if (isRefresh) {
            [refreshFooterView endRefreshing];
        }else{
            [refreshHeaderView endRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }
        
        networkError.hidden =NO;
    }];
}
-(void)addUIBannerView{
    UIImageView *bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, BannerH)];
    [self.view addSubview:bannerImage];
    bannerImage.userInteractionEnabled=YES;
    bannerImage.image =[UIImage imageNamed:@"companyBackImg"];
    companyListModel *companyModel =[_companyLogeArray objectAtIndex:0];

    for (int i=0; i<2; i++) {
        UIButton *returnItem =[UIButton buttonWithType:UIButtonTypeCustom];
        returnItem.frame =CGRectMake(5+i%2*(kWidth-54),20,44,44);
        returnItem.backgroundColor =[UIColor clearColor];
        [bannerImage addSubview:returnItem];
        returnItem.tag =55+i;
        [returnItem setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];

        if (i==1) {
            [returnItem setImage:[UIImage imageNamed:@"com_collect"] forState:UIControlStateNormal];
            [returnItem setImage:[UIImage imageNamed:@"com_collect_pre"] forState:UIControlStateSelected];
            if (companyModel.iscollect ==1) {
                returnItem.selected=YES;
            } if (companyModel.iscollect ==0){
                returnItem.selected=NO;

            }

        }
        [returnItem addTarget:self action:@selector(returnNavItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    headerImage =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-70)/2, 30, 70, 70)];
    headerImage.layer.cornerRadius =35;
    [bannerImage addSubview:headerImage];
    headerImage.backgroundColor =[UIColor clearColor];
    headerImage.layer.masksToBounds =YES;
    headerImage.layer.borderColor =[UIColor whiteColor].CGColor;
    headerImage.layer.borderWidth=1.0f;
    
    UIImageView *headerImg  =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
    headerImg.layer.cornerRadius =30;
    [headerImage addSubview:headerImg];
    [headerImg setImageWithURL:[NSURL URLWithString:companyModel.companyLogo] placeholderImage:placeHoderImage];
    headerImg.layer.masksToBounds =YES;
    
    animationView =[[UIView alloc]initWithFrame:CGRectMake(0, 107, kWidth, 88)];
    [bannerImage addSubview:animationView];
    animationView.backgroundColor =[UIColor clearColor];
    
    
    
    UILabel * titleLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-180)/2, 0, 180, 20)];
    titleLabel.numberOfLines =1;
    [animationView addSubview:titleLabel];
    titleLabel.text =companyModel.companyCompanyname;
    titleLabel.textColor =[UIColor cyanColor];
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
    
    UILabel * contentLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-260)/2, 20, 260, 80)];
    contentLabel.font =[UIFont systemFontOfSize:PxFont(14)];
    titleLabel.textColor =HexRGB(0xffffff);
    contentLabel.textColor =HexRGB(0xf1f1f1);
    contentLabel.shadowColor =HexRGB(0xa2a2a2);
    contentLabel.shadowOffset =CGSizeMake(0, 1);
    contentLabel.numberOfLines =5;
    [animationView addSubview:contentLabel];
    NSLog(@"%f---%f",headerImage.frame.size.height,headerImage.frame.origin.y);
    
    
    contentLabel.text =companyModel.companyIntroduce;
    
    alpha =[[UIImageView alloc]initWithFrame:CGRectMake(0, 42, kWidth, 80)];
    [animationView addSubview:alpha];
    alpha.image =[UIImage imageNamed:@"alphabg"];
    alpha.hidden =NO;
    alpha.backgroundColor =[UIColor clearColor];
    
    UIButton *animationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    animationBtn.frame =CGRectMake((kWidth-80)/2, bannerImage.frame.size.height-40, 80, 30);
    animationBtn.backgroundColor =[UIColor clearColor];
    [bannerImage addSubview:animationBtn];
    [animationBtn setImage:[UIImage imageNamed:@"animationBtn"] forState:UIControlStateNormal];
    [animationBtn addTarget:self action:@selector(animationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"%f",bannerImage.frame.size.height);
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, BannerH-8, kWidth, kHeight-BannerH+8) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView setBackgroundColor:HexRGB(0xe0e0e0)];
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
//    [self.view sendSubviewToBack:_tableView];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _companyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    CompanyHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[CompanyHomeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    companyListModel *companyModel =[_companyArray objectAtIndex:indexPath.row];
    [cell.companyHomeImage setImageWithURL:[NSURL URLWithString:companyModel.companyImgurl] placeholderImage:placeHoderImage2];
    CGFloat titleH =[companyModel.companyTitle sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(kWidth-156, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    cell.companyHomeTitle.frame =CGRectMake(100, 9, kWidth-156, titleH);
    cell.companyHomeTitle.text =[NSString stringWithFormat:@"        %@",companyModel.companyTitle];
    [cell.downLoadBtn setTitle:[NSString stringWithFormat:@"%d",companyModel.companyDownloadnum] forState:UIControlStateNormal];
     [cell.zanBtn setTitle:[NSString stringWithFormat:@"%d",companyModel.companyPrice] forState:UIControlStateNormal];
    [cell.companyHomeSmailImage typeID:companyModel.companyType];

    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.navigationController.viewControllers;
    

    int count = 0;
    for (UIViewController *viewController in array) {
        if ([viewController isKindOfClass:[CourseDetailController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
        count++;
       
    }
    if (count == array.count) {
        companyListModel *companyModel =[_companyArray objectAtIndex:indexPath.row];
        CourseDetailController *xqVC = [[CourseDetailController alloc]init];
        xqVC.courseDetailID =[NSString stringWithFormat:@"%d", companyModel.companyId ];
        
        [self.navigationController pushViewController:xqVC animated:YES];
      
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

-(void)animationBtnClick:(UIButton *)sender{
    NSLog(@"dddd");
    sender.selected=!sender.selected;
    [UIView animateWithDuration:0.001 animations:^{
    sender.transform = CGAffineTransformRotate(sender.transform, DEGREES_TO_RADIANS(180));
    }];
    if (sender.selected==YES) {
        [UIView beginAnimations:@"label" context:nil];
        [UIView setAnimationDuration:2];
        [UIView animateWithDuration:0.001 animations:^{
            headerImage.transform = CGAffineTransformRotate(headerImage.transform, DEGREES_TO_RADIANS(180));
        }];
        
        animationView.frame =CGRectMake(0, 45, kWidth, 88);
        alpha.frame =CGRectMake(0, 90, kWidth, 80);
        
        
        headerImage.frame =CGRectMake((kWidth-70)/2, -100, 70, 70);

        [UIView commitAnimations];
        
        
        
    }else{
        [UIView beginAnimations:@"label" context:nil];
        [UIView setAnimationDuration:2];
        
        headerImage.frame =CGRectMake((kWidth-70)/2, 30, 70, 70);
        
        animationView.frame =CGRectMake(0, 107, kWidth, 88);
        alpha.frame =CGRectMake(0, 42, kWidth, 80);
        
        
        [UIView animateWithDuration:0.001 animations:^{
            headerImage.transform = CGAffineTransformRotate(headerImage.transform, DEGREES_TO_RADIANS(180));
        }];
        [UIView commitAnimations];
        
    }
    
    NSLog(@"ddddd;;");
    
}

//没有网络
-(void)addErrorView{
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    
}
//没有需求
-(void)notCompanyStatuse{
     failView =[[NetFailView alloc]initWithFrame:self.view.bounds backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"对不起，该企业还未发布需求！去其他企业看看吧! "];
    [self.view addSubview:failView];
    failView.hidden =YES;
}
#pragma mark 控件将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

-(void)returnNavItem:(UIButton *)collect{
    if (collect.tag ==55) {
        [self.navigationController popViewControllerAnimated:YES];
  
    }else{
        if (![SystemConfig sharedInstance].isUserLogin ) {
            [RemindView showViewWithTitle:@"请登录" location:BELLOW];
        }else{
            if (collect.selected ==YES)
            {
                
                NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].uid,@"uid",_companyId,@"id" ,nil];
                [HttpTool postWithPath:@"uncollectCompany" params:paramDic success:^(id JSON, int code, NSString *msg) {
                    if (code ==100) {
                        [RemindView showViewWithTitle:@"取消收藏成功!" location:BELLOW];
                        collect.selected =NO;
                    }
                } failure:^(NSError *error) {
                    
                }];
            }  else{
                NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].uid,@"uid",_companyId,@"id" ,nil];
                [HttpTool postWithPath:@"collectCompany" params:paramDic success:^(id JSON, int code, NSString *msg) {
                    if (code ==100) {
                        [RemindView showViewWithTitle:@"收藏成功!" location:BELLOW];
                        collect.selected =YES;
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
            
            
        }

    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
@end
