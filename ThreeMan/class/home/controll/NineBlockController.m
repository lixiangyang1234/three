//
//  NineBlockController.m
//  ThreeMan
//
//  Created by YY on 15-3-27.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "NineBlockController.h"
#import "NeedViewController.h"
#import "nineBlockModel.h"
#import "homeViewControllTool.h"
#define YYBORDERH  8
@interface NineBlockController ()
{
    ErrorView *networkError;
    UIScrollView *_scrollView;
    NSMutableArray *_categoryArray;
}
@end

@implementation NineBlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    _categoryArray =[[NSMutableArray alloc]init];
    [self.view setBackgroundColor:HexRGB(0xffffff)];
    [self setLeftTitle:self.navTitle];
    // Do any additional setup after loading the view.
    [self addErrorView];
    [self addMBprogressView];
    [self addLoadStatus];
   
    
}
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
}
-(void)addLoadStatus{
   [homeViewControllTool statusesWithNineBlockID:self.nineBlockID Success:^(NSMutableArray *statues) {
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

       for (NSArray *dict in statues) {
           [_categoryArray addObjectsFromArray:dict];
           
//           NSLog(@"fffff----%@",_categoryArray);
       }
//       [self addCateGoryButton:_categoryArray];
       [self addScrollView];

       [self addCateGoryButton];
   } failure:^(NSError *error) {
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

       NSLog(@"网络错误");
       networkError.hidden =NO;
   }];
}
-(void)addScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, (_categoryArray.count+2)/3*44);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor =HexRGB(0xeaebec);
    [self.view addSubview:_scrollView];
    //底部线条
    UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, YYBORDERH)];
    [_scrollView addSubview:topLie];
    topLie.backgroundColor =HexRGB(0xffffff);
    //成长不再孤单底图 图片
    UIImageView *backImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-115)/2, kHeight-70-64, 115, 35)];
    [_scrollView addSubview:backImg];
    backImg.backgroundColor =[UIColor clearColor];
    backImg.userInteractionEnabled=YES;
    backImg.image =[UIImage imageNamed:@"title@2x.png"];
    
}
-(void)addCateGoryButton
{
    CGFloat nineH =43; //按钮高
    CGFloat nineBorderWH =0;//边界高宽
    

    for (int i=0; i<_categoryArray.count; i++) {
        NSDictionary *dict =[_categoryArray objectAtIndex:i];
        nineBlockModel *nineModel =[[nineBlockModel alloc]init];
        nineModel.nineTitle =dict[@"title"];
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:nineModel.nineTitle forState:UIControlStateNormal];
        [_scrollView addSubview:titleBtn];
        titleBtn .titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        titleBtn.frame =CGRectMake(nineBorderWH+i%3*((kWidth-nineBorderWH*2)/3), i/3*(nineH), (kWidth-nineBorderWH*2)/3-.5, nineH);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.backgroundColor =[UIColor whiteColor];        
        [titleBtn addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag =300+i;
        
        
    }
    
        for (int h=0; h<_categoryArray.count/3; h++) {
            //底部线条
            UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(YYBORDERH, nineH+h%(_categoryArray.count/3)*nineH, kWidth-YYBORDERH*2, .5)];
            [_scrollView addSubview:topLie];
            topLie.backgroundColor =HexRGB(0xeaebec);
    }
   
    
    
    
}
-(void)itemsClick:(UIButton *)sender{
    NeedViewController *needVC =[[NeedViewController alloc]init];
    NSDictionary *dict =[_categoryArray objectAtIndex:sender.tag-300];
    nineBlockModel *nineModel =[[nineBlockModel alloc]init];
    nineModel.nineID =dict[@"id"];
    nineModel.nineTitle =dict[@"title"];

    needVC.categoryId =nineModel.nineID;
    needVC.navTitle =nineModel.nineTitle;
    
    [self.navigationController pushViewController:needVC animated:YES];
}
//没有网络
-(void)addErrorView{
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    
}

@end
