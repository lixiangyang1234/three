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
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface CompanyHomeControll ()<UITableViewDataSource,UITableViewDelegate>
{
    ErrorView *networkError;
    UIImageView *headerImage;
    
    UITableView *_tableView;
    CGFloat starY;
    UIImageView *alpha;
    UIView *animationView;
    
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
    [self addUIBannerView];
    [self addTableView];
    [self addErrorView];
    [self addMBprogressView];

    [self addLoadStatus];
    // Do any additional setup after loading the view.
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
}

#pragma mark=====添加数据
-(void)addLoadStatus{
    NSDictionary *paraDic =[NSDictionary dictionaryWithObjectsAndKeys:_companyId,@"id", nil];
    [HttpTool postWithPath:@"getCompanyCourseList" params:paraDic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSDictionary *dict =JSON[@"data"];
        NSArray *arr =dict[@"subject_list"];
        if (code==100) {
            for (NSDictionary *dicArr in arr) {
                companyListModel *businessModel =[[companyListModel alloc]initWithDictonaryForCompanyList:dicArr];
                [_companyArray addObject:businessModel];
            }
            
        }
               NSLog(@"%@",JSON);
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        networkError.hidden =NO;
    }];
}
-(void)addUIBannerView{
    UIImageView *bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, BannerH)];
    [self.view addSubview:bannerImage];
    //    bannerImage.backgroundColor =[UIColor purpleColor];
    bannerImage.userInteractionEnabled=YES;
    bannerImage.image =[UIImage imageNamed:@"companyBackImg"];
    //    bannerImage.image =[UIImage imageNamed:@"alphabg"];companyBackImg
    
    UIButton *returnItem =[UIButton buttonWithType:UIButtonTypeCustom];
    returnItem.frame =CGRectMake(5,20,44,44);
    returnItem.backgroundColor =[UIColor clearColor];
    [bannerImage addSubview:returnItem];
    [returnItem setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [returnItem addTarget:self action:@selector(returnNavItem) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    [headerImg setImageWithURL:[NSURL URLWithString:self.companyImag] placeholderImage:placeHoderImage];
    headerImg.layer.masksToBounds =YES;
    
    animationView =[[UIView alloc]initWithFrame:CGRectMake(0, 107, kWidth, 88)];
    [bannerImage addSubview:animationView];
    animationView.backgroundColor =[UIColor clearColor];
    
    
    
    UILabel * titleLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-180)/2, 5, 180, 20)];
    titleLabel.numberOfLines =1;
    [animationView addSubview:titleLabel];
    titleLabel.text =self.companyTitel;
    titleLabel.textColor =[UIColor cyanColor];
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
    
    UILabel * contentLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-210)/2, 20, 210, 80)];
    contentLabel.font =[UIFont systemFontOfSize:PxFont(18)];
    titleLabel.textColor =HexRGB(0xffffff);
    contentLabel.textColor =HexRGB(0xf1f1f1);
    contentLabel.shadowColor =HexRGB(0xa2a2a2);
    contentLabel.shadowOffset =CGSizeMake(0, 3);
    contentLabel.numberOfLines =5;
    [animationView addSubview:contentLabel];
    NSLog(@"%f---%f",headerImage.frame.size.height,headerImage.frame.origin.y);
    
    
    contentLabel.text =self.companyContent;
    
    alpha =[[UIImageView alloc]initWithFrame:CGRectMake(0, 32, kWidth, 80)];
    [animationView addSubview:alpha];
    alpha.image =[UIImage imageNamed:@"alphabg"];
    alpha.hidden =NO;
    alpha.backgroundColor =[UIColor clearColor];
    
    UIButton *animationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    animationBtn.frame =CGRectMake((kWidth-110)/2, bannerImage.frame.size.height-36, 100, 30);
    animationBtn.backgroundColor =[UIColor clearColor];
    [bannerImage addSubview:animationBtn];
    [animationBtn setImage:[UIImage imageNamed:@"animationBtn"] forState:UIControlStateNormal];
    [animationBtn addTarget:self action:@selector(animationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, BannerH-8, kWidth, 8)];
//    [lineView setBackgroundColor:HexRGB(0xe0e0e0)];
//    [bannerImage addSubview:lineView];
//    NSLog(@"1111/////------>%f",animationView.frame.origin.y);
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
    cell.companyHomeTitle.frame =CGRectMake(135, 9, kWidth-156, titleH);
    cell.companyHomeTitle.text =[NSString stringWithFormat:@"   %@",companyModel.companyTitle];
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
        alpha.frame =CGRectMake(0, 32, kWidth, 80);
        
        
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
    NetFailView *failView =[[NetFailView alloc]initWithFrame:self.view.bounds backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"对不起，该企业还未发布需求！去其他企业看看吧! "];
    [self.view addSubview:failView];
}
#pragma mark 控件将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

-(void)returnNavItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
@end
