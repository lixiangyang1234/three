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
    UIScrollView *_scrollView;
    NSMutableArray *_categoryArray;
}
@end

@implementation NineBlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    _categoryArray =[[NSMutableArray alloc]init];
    [self.view setBackgroundColor:HexRGB(0xffffff)];
    // Do any additional setup after loading the view.
    [self addLoadStatus];
   
    
}
-(void)addLoadStatus{
   [homeViewControllTool statusesWithNineBlockID:self.nineBlockID Success:^(NSMutableArray *statues) {
       for (NSArray *dict in statues) {
           [_categoryArray addObjectsFromArray:dict];
           
//           NSLog(@"fffff----%@",_categoryArray);
       }
//       [self addCateGoryButton:_categoryArray];
       [self addScrollView];

       [self addCateGoryButton];
   } failure:^(NSError *error) {
       NSLog(@"网络错误");
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
//    if (_categoryArray.count%3==1) {
//        topLie.frame =CGRectMake(YYBORDERH, YYBORDERH, kWidth-YYBORDERH*2, (_categoryArray.count+2)/3*44);
//        
//    }else if(_categoryArray.count%3==2){
//        topLie.frame =CGRectMake(YYBORDERH, YYBORDERH, kWidth-YYBORDERH*2, (_categoryArray.count+1)/3*44);
//
//    }else {
//        topLie.frame =CGRectMake(YYBORDERH, YYBORDERH, kWidth-YYBORDERH*2, _categoryArray.count/3*44);
//
//    }
    
    
    
    //banner图片
    UIImageView *backImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-115)/2, kHeight-70-64, 115, 35)];
    [_scrollView addSubview:backImg];
    backImg.backgroundColor =[UIColor clearColor];
    backImg.userInteractionEnabled=YES;
    backImg.image =[UIImage imageNamed:@"title@2x.png"];
    
}
-(void)addCateGoryButton
{
    CGFloat nineH =44; //按钮高
    CGFloat nineBorderWH =0;//边界高宽

    for (int i=0; i<_categoryArray.count; i++) {
        NSDictionary *dict =[_categoryArray objectAtIndex:i];
        nineBlockModel *nineModel =[[nineBlockModel alloc]init];
        nineModel.nineTitle =dict[@"title"];
//        NSLog(@"fffffff%@",nineModel.nineTitle);
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:nineModel.nineTitle forState:UIControlStateNormal];
        [_scrollView addSubview:titleBtn];
        titleBtn .titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        titleBtn.frame =CGRectMake(nineBorderWH+i%3*((kWidth-nineBorderWH*2)/3), YYBORDERH+i/3*(nineH), (kWidth-nineBorderWH*2)/3-1, nineH);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.backgroundColor =[UIColor whiteColor];        
        [titleBtn addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag =300+i;
        
        
    }
    
        for (int h=0; h<_categoryArray.count/3; h++) {
            //底部线条
            UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(YYBORDERH, YYBORDERH+nineH+h%_categoryArray.count/3*nineH, kWidth-YYBORDERH*2, 1)];
            [_scrollView addSubview:topLie];
            topLie.backgroundColor =HexRGB(0xeaebec);
    }
   
    
    
    
}
-(void)itemsClick:(UIButton *)sender{
    NeedViewController *needVC =[[NeedViewController alloc]init];
    NSDictionary *dict =[_categoryArray objectAtIndex:sender.tag-300];
    nineBlockModel *nineModel =[[nineBlockModel alloc]init];
    nineModel.nineID =dict[@"id"];
    needVC.categoryId =nineModel.nineID;
    
    
    [self.navigationController pushViewController:needVC animated:YES];
}

@end
