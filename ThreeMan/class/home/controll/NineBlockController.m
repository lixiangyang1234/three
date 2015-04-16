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
   
    
 
    
    _scrollView = [[UIScrollView alloc]init];
    if (_categoryArray.count%3==1) {
        _scrollView.frame =CGRectMake(YYBORDERH, 0, kWidth-16,( _categoryArray.count+2)/3*44+YYBORDERH);
        //底部线条
        UIView *topView =[[UIView alloc]initWithFrame:CGRectMake(YYBORDERH+(kWidth-YYBORDERH)/3-2,_scrollView.frame.size.height-44 ,(kWidth-YYBORDERH)/3*2,43)];
        [_scrollView addSubview:topView];
        topView.backgroundColor =HexRGB(0xffffff);
        
    }else if(_categoryArray.count%3==2){
        _scrollView.frame =CGRectMake(YYBORDERH, 0, kWidth-16,( _categoryArray.count+1)/3*44+YYBORDERH);
        //底部线条
        UIView *topView =[[UIView alloc]initWithFrame:CGRectMake(YYBORDERH+(kWidth-YYBORDERH)/3*2-3,_scrollView.frame.size.height-44 ,(kWidth-YYBORDERH)/3,43)];
        [_scrollView addSubview:topView];
        topView.backgroundColor =HexRGB(0xffffff);
    }else{
        _scrollView.frame =CGRectMake(YYBORDERH, 0, kWidth-16, _categoryArray.count/3*44+YYBORDERH);
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _categoryArray.count/3*44+10);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor =HexRGB(0xeaebec);
    
    [self.view addSubview:_scrollView];
    //底部线条
    UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, YYBORDERH)];
    [_scrollView addSubview:topLie];
    topLie.backgroundColor =HexRGB(0xffffff);
    
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
        titleBtn.frame =CGRectMake(nineBorderWH+i%3*((kWidth-nineBorderWH*2)/3), YYBORDERH+i/3*(nineH), (kWidth-nineBorderWH*2)/3-1, nineH-1);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.backgroundColor =[UIColor whiteColor];        
        [titleBtn addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.tag =300+i;
        
        
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
