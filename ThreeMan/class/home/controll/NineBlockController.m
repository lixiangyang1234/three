//
//  NineBlockController.m
//  ThreeMan
//
//  Created by YY on 15-3-27.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "NineBlockController.h"
#import "CourseDetailController.h"
@interface NineBlockController ()
{
    UIScrollView *_scrollView;
    NSMutableArray *_categoryArray;
}
@end

@implementation NineBlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    _categoryArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    // Do any additional setup after loading the view.
    [self addScrollView];

    [self addCateGoryButton];
    self.rootNavView =[[RootNavView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44) withTitle:@"九大模块" withType:2];
    self.rootNavView.Rootdelegate =self;
    self.navigationItem.titleView = self.rootNavView;
}
-(void)addScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.view.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _categoryArray.count/3*(66+30)+10);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor =HexRGB(0xeaebec);
    
    [self.view addSubview:_scrollView];
    
}
-(void)addCateGoryButton
{
    CGFloat nineH =44; //按钮高
    CGFloat nineBorderWH =8;//边界高宽
//    UIView *needBackView =[[UIView alloc]initWithFrame:CGRectMake(nineBorderWH, nineBorderWH, kWidth-nineBorderWH*2, 21/3*nineH+nineBorderWH)];
//    [_scrollView addSubview:needBackView];
//    needBackView.backgroundColor =HexRGB(0xeaebec);
//    _categoryArray=@[@"还好还好",@"还好还好",@"还好还好",@"还好还好"];
    for (int i=0; i<21; i++) {
//        gategoryModel *cagegoryModel =[_categoryArray objectAtIndex:but];
        
        
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:@"和哈哈哈和" forState:UIControlStateNormal];
        [_scrollView addSubview:titleBtn];
        titleBtn .titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        titleBtn.frame =CGRectMake(nineBorderWH+i%3*((kWidth-nineBorderWH*2)/3), nineBorderWH+i/3*(nineH), (kWidth-nineBorderWH*2)/3-1, nineH-1);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.backgroundColor =[UIColor whiteColor];
//        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
//        
//        button.frame = CGRectMake(but%3*(70+37), 0+but/3*(60+35), kWidth/3, 96);
//        [_scrollView addSubview:button];
//        button.titleLabel.text = titleBtn.titleLabel.text;
//        
//        button.backgroundColor =[UIColor redColor];
        
        
        [titleBtn addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    
    
}
-(void)itemsClick:(UIButton *)sender{
    CourseDetailController *courseDetailVC =[[CourseDetailController alloc]init];
    [self.navigationController pushViewController:courseDetailVC animated:YES];
}
-(void)rootNavItemClick:(UIButton *)item withItemTag:(NSInteger)itemTag{
    NSLog(@"-----111111aaaaa%d----%d",item.tag,itemTag);
 
}

@end
