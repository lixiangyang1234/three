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
#define KStartY 20
#define BannerH  195
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface CompanyHomeControll ()<UITableViewDataSource,UITableViewDelegate>
{
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
    [self addUIBannerView];
    [self addTableView];
    
    // Do any additional setup after loading the view.
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
    //    [animationBtn setTitle:@"animationBtn" forState:UIControlStateNormal];
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
    headerImg.image =[UIImage imageNamed:@"img"];
    headerImg.layer.masksToBounds =YES;
    
    animationView =[[UIView alloc]initWithFrame:CGRectMake(0, 107, kWidth, 88)];
    [bannerImage addSubview:animationView];
    animationView.backgroundColor =[UIColor clearColor];
    
    
    
    UILabel * titleLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-210)/2, 5, 210, 20)];
    titleLabel.numberOfLines =1;
    [animationView addSubview:titleLabel];
    titleLabel.text =@"卡卡姐看了卡拉卡积";
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
    
    
    contentLabel.text =@"卡卡姐看了卡拉卡积分离开的房间卡了附近垃圾地方卡上辣椒粉考虑到看来；桑德菲杰卢卡斯看大家说；卡了附近磕掉了交罚款了舒服肯定放假阿喀琉斯； 抵抗力交罚款了舒抵抗力交罚款了舒抵抗力交罚款了舒服；";
    
    alpha =[[UIImageView alloc]initWithFrame:CGRectMake(0, 32, kWidth, 80)];
    [animationView addSubview:alpha];
    alpha.image =[UIImage imageNamed:@"alphabg"];
    alpha.hidden =NO;
    alpha.backgroundColor =[UIColor clearColor];
    
    UIButton *animationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    animationBtn.frame =CGRectMake((kWidth-110)/2, bannerImage.frame.size.height-45, 100, 30);
    animationBtn.backgroundColor =[UIColor clearColor];
    [bannerImage addSubview:animationBtn];
    [animationBtn setImage:[UIImage imageNamed:@"animationBtn"] forState:UIControlStateNormal];
    [animationBtn addTarget:self action:@selector(animationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, BannerH-8, kWidth, 8)];
    [lineView setBackgroundColor:HexRGB(0xe0e0e0)];
    [bannerImage addSubview:lineView];
    NSLog(@"1111/////------>%f",animationView.frame.origin.y);
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, BannerH, kWidth, kHeight-BannerH) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView setBackgroundColor:HexRGB(0xe0e0e0)];
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    CompanyHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[CompanyHomeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    
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
        CourseDetailController *xqVC = [[CourseDetailController alloc]init];
        
//        XQgetInfoDetailModel *comID =[[XQArray objectAtIndex:0]objectAtIndex:0];
//        xqVC.companyName = comID.company_name;
//        xqVC.companyID =comID.company_id;
        
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
        NSLog(@"222221/////------>%f",animationView.frame.origin.y);

        [UIView commitAnimations];
        
        
        
         NSLog(@"25555551/////------>%f",animationView.frame.origin.y);
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
-(void)notNetFailView{
    NetFailView *failView =[[NetFailView alloc]initWithFrame:self.view.bounds backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"对不起，网络不给力!请检查您的网络设置! "];
    [self.view addSubview:failView];
}
//没有需求
-(void)notCompanyStatuse{
    NetFailView *failView =[[NetFailView alloc]initWithFrame:self.view.bounds backImage:[UIImage imageNamed:@"netFailImg_1"] promptTitle:@"对不起，该企业还未发布需求！去其他企业看看吧! "];
    [self.view addSubview:failView];
}
#pragma mark 控件将要显示
- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

-(void)returnNavItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
@end
