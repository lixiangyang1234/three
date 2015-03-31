//
//  CompanyHomeControll.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompanyHomeControll.h"
#import "CompanyHomeViewCell.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

@interface CompanyHomeControll ()<UITableViewDataSource,UITableViewDataSource>
{
    UIImageView *headerImage;
    UILabel *titleLabel;
    UILabel *contentLabel;
    UITableView *_tableView;
}
@end

@implementation CompanyHomeControll

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addUIBannerView];
    [self addTableView];
    
    // Do any additional setup after loading the view.
}
-(void)addUIBannerView{
    UIImageView *bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 180)];
    [self.view addSubview:bannerImage];
    bannerImage.backgroundColor =[UIColor purpleColor];
    bannerImage.userInteractionEnabled=YES;
    
    headerImage =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-60)/2, 10, 60, 60)];
    headerImage.layer.cornerRadius =30;
    [bannerImage addSubview:headerImage];
    headerImage.backgroundColor =[UIColor redColor];
    headerImage.image =[UIImage imageNamed:@"img"];
    headerImage.layer.masksToBounds =YES;

    titleLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-210)/2, 100, 210, 20)];
    titleLabel.numberOfLines =1;
    [bannerImage addSubview:titleLabel];
    titleLabel.text =@"卡卡姐看了卡拉卡积";
    titleLabel.textColor =[UIColor cyanColor];
    
    contentLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-210)/2, 120, 210, 25)];
    contentLabel.numberOfLines =5;
    [bannerImage addSubview:contentLabel];
    contentLabel.text =@"卡卡姐看了卡拉卡积分离开的房间卡了附近垃圾地方卡上辣椒粉考虑到看来；桑德菲杰卢卡斯看大家说；卡了附近磕掉了交罚款了舒服肯定放假阿喀琉斯； 抵抗力交罚款了舒服；";
    contentLabel.textColor =[UIColor cyanColor];
    
    UIButton *animationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    animationBtn.frame =CGRectMake((kWidth-110)/2, 150, 100, 30);
    animationBtn.backgroundColor =[UIColor purpleColor];
    
    [bannerImage addSubview:animationBtn];
    [animationBtn setTitle:@"animationBtn" forState:UIControlStateNormal];
    
    [animationBtn addTarget:self action:@selector(animationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 180, kWidth, kHeight-64-180) style:UITableViewStylePlain];
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
        
        titleLabel.frame =CGRectMake((kWidth-210)/2, 10, 210, 20);
 
        contentLabel.frame =CGRectMake((kWidth-210)/2, 25, 210, 80);
       

        headerImage.frame =CGRectMake((kWidth-60)/2, -100, 60, 60);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"label" context:nil];
        [UIView setAnimationDuration:2];
       
        titleLabel.frame =CGRectMake((kWidth-210)/2, 100, 210, 20);
        contentLabel.frame =CGRectMake((kWidth-210)/2, 120, 210, 25);

        headerImage.frame =CGRectMake((kWidth-60)/2, 10, 60, 60);
        [UIView animateWithDuration:0.001 animations:^{
            headerImage.transform = CGAffineTransformRotate(headerImage.transform, DEGREES_TO_RADIANS(180));
        }];
        [UIView commitAnimations];
    }
    
    
    NSLog(@"ddddd;;");
    
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
