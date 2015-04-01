//
//  CompanyHomeControll.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompanyHomeControll.h"
#import "CompanyHomeViewCell.h"
#define KStartY 20

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface CompanyHomeControll ()<UITableViewDataSource,UITableViewDataSource>
{
    UIImageView *headerImage;
    UILabel *titleLabel;
    UILabel *contentLabel;
    UITableView *_tableView;
    CGFloat starY;
    UIImageView *alpha;

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

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addUIBannerView];
    [self addTableView];
    
    // Do any additional setup after loading the view.
}
-(void)addUIBannerView{
    UIImageView *bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 195)];
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

    titleLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-210)/2, headerImage.frame.size.height+headerImage.frame.origin.y+7, 210, 20)];
    titleLabel.numberOfLines =1;
    [bannerImage addSubview:titleLabel];
    titleLabel.text =@"卡卡姐看了卡拉卡积";
    titleLabel.textColor =[UIColor cyanColor];
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
    
    contentLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-210)/2, headerImage.frame.size.height+headerImage.frame.origin.y+7+20, 210, 25)];
    contentLabel.font =[UIFont systemFontOfSize:PxFont(18)];
//    contentLabel.textColor =HexRGB(0xa2a2a2);
    titleLabel.textColor =HexRGB(0xffffff);
    contentLabel.textColor =HexRGB(0xf1f1f1);
    contentLabel.numberOfLines =5;
    [bannerImage addSubview:contentLabel];
    NSLog(@"%f---%f",headerImage.frame.size.height,headerImage.frame.origin.y);
    
//    contentLabel.backgroundColor =[UIColor redColor];
//    titleLabel.backgroundColor =[UIColor redColor];
    contentLabel.text =@"卡卡姐看了卡拉卡积分离开的房间卡了附近垃圾地方卡上辣椒粉考虑到看来；桑德菲杰卢卡斯看大家说；卡了附近磕掉了交罚款了舒服肯定放假阿喀琉斯； 抵抗力交罚款了舒服；";
    
     alpha =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentLabel.frame.size.width, 80)];
    [contentLabel addSubview:alpha];
    alpha.image =[UIImage imageNamed:@"companyBackImg"];
    alpha.hidden =NO;
    alpha.backgroundColor =[UIColor redColor];
    
    UIButton *animationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    animationBtn.frame =CGRectMake((kWidth-110)/2, bannerImage.frame.size.height-45, 100, 30);
    animationBtn.backgroundColor =[UIColor clearColor];
    
    [bannerImage addSubview:animationBtn];
//    [animationBtn setTitle:@"animationBtn" forState:UIControlStateNormal];
    [animationBtn setImage:[UIImage imageNamed:@"animationBtn"] forState:UIControlStateNormal];
    [animationBtn addTarget:self action:@selector(animationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 180, kWidth, kHeight-180) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor =[UIColor whiteColor];
    
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
        cell.backgroundColor =[UIColor lightGrayColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    CourseDetailControll *courseDetailVC=[[CourseDetailControll alloc]init];
    //    [self.navigationController pushViewController:courseDetailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
        
        titleLabel.frame =CGRectMake((kWidth-210)/2, 45, 210, 20);
 
        contentLabel.frame =CGRectMake((kWidth-210)/2, 65, 210, 80);
       

        headerImage.frame =CGRectMake((kWidth-70)/2, -100, 70, 70);
        alpha.hidden =NO;

        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"label" context:nil];
        [UIView setAnimationDuration:2];
       
        titleLabel.frame =CGRectMake((kWidth-210)/2, 107, 210, 20);
        contentLabel.frame =CGRectMake((kWidth-210)/2, 127, 210, 25);
        headerImage.frame =CGRectMake((kWidth-70)/2, 30, 70, 70);
        
        alpha.hidden =YES;

        [UIView animateWithDuration:0.001 animations:^{
            headerImage.transform = CGAffineTransformRotate(headerImage.transform, DEGREES_TO_RADIANS(180));
        }];
        [UIView commitAnimations];
    }
    
    
    NSLog(@"ddddd;;");
    
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
@end
