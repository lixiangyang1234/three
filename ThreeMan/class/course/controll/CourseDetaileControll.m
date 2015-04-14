//
//  CourseDetaileControll.m
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseDetaileControll.h"
#import "CourseViewVCTool.h"
#import "CourseViewVCModel.h"
#define YYBORDER  8
#define BANNERH 150
@interface CourseDetaileControll ()
@property(nonatomic,strong)UIScrollView *backScrollView;

@end

@implementation CourseDetaileControll
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =HexRGB(0xe0e0e0);
    _courseDetailArray =[[NSMutableArray alloc]initWithCapacity:0];
    [self addLoadStatus];
}
-(void)addLoadStatus
{
    [CourseViewVCTool statusesWithCourseID:_courseIndex CourseSuccess:^(NSMutableArray *statues) {
        for (NSDictionary *dict in statues) {
            [_courseDetailArray addObject:dict];

        }
        [self addUIBackScrollView];

    } failure:^(NSError *error) {
        
    }];
}

    #pragma mark 创建scrooView
-(void)addUIBackScrollView{
    //添加滑动背景
    CourseViewVCModel *courseModel =[_courseDetailArray objectAtIndex:0];
    [self setLeftTitle:courseModel.detailTitle];
    CGFloat contentH =[courseModel.detailDescription sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(kWidth-YYBORDER*4, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    NSLog(@"%f",contentH);
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    self.backScrollView.backgroundColor =HexRGB(0xe0e0e0);
    [self.view addSubview:self.backScrollView];
    self.backScrollView.contentSize =CGSizeMake(kWidth, BANNERH+YYBORDER*5+contentH);
    self.backScrollView.bounces=NO;
    self.backScrollView.showsHorizontalScrollIndicator =NO;
    self.backScrollView.showsVerticalScrollIndicator=NO;
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(YYBORDER, YYBORDER, kWidth-YYBORDER*2, contentH+BANNERH+YYBORDER*5)];
    [self.backScrollView addSubview:backView];
    backView.backgroundColor =[UIColor whiteColor];
    
    
   UIImageView * bannerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBORDER+ 5,YYBORDER+ 5, backView.frame.size.width-10, BANNERH)];
    [self.backScrollView addSubview:bannerImage];
    bannerImage.backgroundColor =[UIColor redColor];
    bannerImage.userInteractionEnabled =YES;
    [bannerImage setImageWithURL:[NSURL URLWithString:courseModel.detaileImgurl]placeholderImage:placeHoderImage];
    
    NSLog(@"qqqqqqq%@",courseModel.detailContent);
    CGFloat bannerh =BANNERH+bannerImage.frame.origin.y+5;
    UIView *backLine =[[UIView alloc]initWithFrame:CGRectMake(0, bannerh, kWidth, YYBORDER)];
    [self.backScrollView addSubview:backLine];
    backLine.backgroundColor =HexRGB(0xe0e0e0);

  UILabel *  contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBORDER*2, bannerh+15, backView.frame.size.width*2, contentH )];
    contentLabel.backgroundColor =[UIColor clearColor];
    contentLabel.text =courseModel.detailDescription;
    [self.backScrollView addSubview:contentLabel];
    contentLabel.font =[UIFont systemFontOfSize:PxFont(20)];
    contentLabel.textColor =HexRGB(0x737373);
    contentLabel.textAlignment =NSTextAlignmentLeft;
    contentLabel.numberOfLines =0;
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.size.height-1, kWidth-YYBORDER*2, 1)];
    [backView addSubview:line];
    line.backgroundColor =HexRGB(0xcacaca);
 

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