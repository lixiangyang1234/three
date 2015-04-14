//
//  ThreeBlockController.m
//  ThreeMan
//
//  Created by YY on 15-4-1.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "ThreeBlockController.h"

#import "NeedViewCell.h"
#import "YYSearchButton.h"
#import "RootNavView.h"
#import "categoryView.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)


@interface ThreeBlockController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    YYSearchButton *_selectedItem;
    UIButton *topBtn;
}
@end

@implementation ThreeBlockController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:HexRGB(0xffffff)];
    //    [self addUINavView];
    [self addTableView];
    [self addUIChooseBtn];//添加筛选按钮
    [self addCategoryBtn];
    [self addTopBtn];
}
-(void)addTopBtn
{
    //回顶部按钮
    topBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topBtn];
    topBtn.frame =CGRectMake(kWidth-50, kHeight-80-64, 30, 30);
    [topBtn setTitle:@"23" forState:UIControlStateNormal];
    topBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    topBtn.hidden =YES;
    [topBtn setImage:[UIImage imageNamed:@"nav_return_pre"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topBtn setTitle:@"定都" forState:UIControlStateNormal];
    [topBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [topBtn.titleLabel setFont:[UIFont systemFontOfSize:PxFont(12)]];
    topBtn.tag =900;
    
}

//-(void)addUINavView{
//    RootNavView *rootView =[[RootNavView alloc ]init];
//    self.navigationItem.titleView =rootView;
//    rootView.backgroundColor =[UIColor redColor];
//
//}
//添加筛选按钮
-(void)addUIChooseBtn{
    NSArray *chooseTitleArray =@[@"全部",@"视频",@"文件"];
    
    for (int i=0; i<3; i++) {
        
        YYSearchButton*  chooseBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:chooseBtn];
        chooseBtn.tag =i+10000;
        if (chooseBtn.tag==10000) {
            
            chooseBtn.isSelected =YES;
            _selectedItem =chooseBtn;
        }
        chooseBtn.frame =CGRectMake(10+i%3*60, 5, 50, 30) ;
        [chooseBtn setTitle:chooseTitleArray[i] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        
    }
    
    
}
-(void)addCategoryBtn{
    UIButton*  categoryBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:categoryBtn];
    categoryBtn.frame =CGRectMake(kWidth-120, 7, 120, 30) ;
    [categoryBtn setTitle:@"委员会类型" forState:UIControlStateNormal];
    [categoryBtn setImage:[UIImage imageNamed:@"downlower"] forState:UIControlStateNormal];
    [categoryBtn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [categoryBtn setTitleColor:HexRGB(0x959595) forState:UIControlStateNormal];
    categoryBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 90, 0, 0);
    categoryBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 30);
    
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-64-44) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView setBackgroundColor:HexRGB(0xe0e0e0)];
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}
#pragma mark ----chooseBtn categoryBtn 筛选按钮
//筛选按钮
-(void)chooseBtnClick:(YYSearchButton *)sender{
    //    _selectedItem.isSelected =NO;
    NSLog(@"%d----%d",_selectedItem.tag,sender.tag);
    
    
    if (sender!=_selectedItem) {
        
        _selectedItem.isSelected =NO;
        sender.isSelected =YES;
        _selectedItem=sender;
    }
}
-(void)categoryBtnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.001 animations:^{
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, DEGREES_TO_RADIANS(180));
    }];
    
    
    CGPoint point = CGPointMake(kWidth-60, sender.frame.origin.y + sender.frame.size.height+60);
    
    NSArray * titles = @[@"   全部类型", @" 落地实操委员会", @"   落地实操辅助委",@"   落地实操反馈委"];
    NSArray *  category = @[@"主席", @"总理", @"部长",@"快乐局",@"宣传局", @"关爱局", @"造场局"];
    
    categoryView *popView = [[categoryView alloc] initWithPoint:point titles:titles categoryTitles:category];
    popView.selectRowAtIndex = ^(NSInteger index)
    {
        
        NSLog(@"select index:%ld", (long)index);
    };
    
    [popView show];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    NeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[NeedViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    NSLog(@"%f---%d",cell.frame.size.height,indexPath.row);
    if (indexPath.row>=8) {
        topBtn.hidden =NO;
    }else if (indexPath.row<=4){
        topBtn.hidden =YES;
    }
    
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    CourseDetailControll *courseDetailVC=[[CourseDetailControll alloc]init];
    //    [self.navigationController pushViewController:courseDetailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(void)topBtnClick:(UIButton *)top{
    //    NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
    //    [_infoTableView scrollToRowAtIndexPath:indePath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    NSIndexPath *indePath =[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indePath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[DBTool shareDBToolClass]deleteAllEntity];
}

@end
