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
#import "threeBlockModel.h"
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
    _threeArray =[NSMutableArray array];
    _categoryArray =[NSMutableArray array];
    _threeListArray =[NSMutableArray array];

    [self addTableView];
    [self addUIChooseBtn];//添加筛选按钮
    [self addCategoryBtn];
    [self addLoadStatus:@"0"];
}

-(void)addLoadStatus:(NSString *)typestr{
    NSDictionary *parmDic =[NSDictionary dictionaryWithObjectsAndKeys:_threeId,@"id",typestr,@"type" ,nil];
    [HttpTool postWithPath:@"getNeedList" params:parmDic success:^(id JSON, int code, NSString *msg) {
//        NSLog(@"%@",JSON);

        if (code == 100) {
            [_categoryArray removeAllObjects];
            NSDictionary *dic = [JSON objectForKey:@"data"][@"subcategory_list"];
            
            NSDictionary *dic1 = [JSON objectForKey:@"data"];
            NSArray *array =dic1[@"subcategory_list"];
            NSDictionary *arr =[array objectAtIndex:0];
            NSDictionary *arrdic =arr[@"subcategory"];
            
            NSDictionary *dic2 = [JSON objectForKey:@"data"][@"subject_list"];
            NSLog(@"%@",dic2);

            if (![dic isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in dic) {
                    threeBlockModel *item = [[threeBlockModel alloc] initWithForArray:dict];
                    [_threeArray addObject:item];
                }
                
            }
                for (NSDictionary *dict1 in arrdic) {
                    threeBlockModel *cateModel = [[threeBlockModel alloc] initWithForCategory:dict1];
                    [_categoryArray addObject:cateModel];
                }
            for (NSDictionary *dict1 in dic2) {
                threeBlockModel *cateModel = [[threeBlockModel alloc] initWithForThreeList:dict1];
                [_threeListArray addObject:cateModel];
            }
            
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
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
    [categoryBtn addTarget:self action:@selector(threeCategoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
        if (sender!=_selectedItem) {
        
        _selectedItem.isSelected =NO;
        sender.isSelected =YES;
        _selectedItem=sender;
    }
    
}
-(void)threeCategoryBtnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.001 animations:^{
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, DEGREES_TO_RADIANS(180));
    }];
    
    CGPoint point = CGPointMake(kWidth-60, sender.frame.origin.y + sender.frame.size.height+60);
    
    NSMutableArray *titles = [NSMutableArray array];
    
    [titles addObject:@"全部类型"];
    for (int i=0; i<3; i++) {
        threeBlockModel *threeModel =[_threeArray objectAtIndex:i];
        NSString *str =threeModel.categoryTitle;
        [titles addObject:str];
    }
    NSMutableArray *category = [NSMutableArray array];

    for (int c=0; c<7; c++) {
        threeBlockModel *categoryModel =[_categoryArray objectAtIndex:c];

        NSString *cateStr =categoryModel.cateTitle;
        NSLog(@"%@",cateStr);
        [category addObject:cateStr];
    }
    
    
    
    categoryView *popView = [[categoryView alloc] initWithPoint:point titles:titles categoryTitles:category];
    popView.selectRowAtIndex = ^(NSInteger index)
    {
        
//        threeBlockModel *threeModel =[_threeArray objectAtIndex:index];
        
        NSLog(@"select index:%ld", (long)index);
//        [self addLoadStatus:[NSString stringWithFormat:@"%d",threeModel.threeType]];
    };
    
    [popView show];
    
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _threeListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    NeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[NeedViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    threeBlockModel *threeModel =[_threeListArray objectAtIndex:indexPath.row];
    [cell.needImage setImageWithURL:[NSURL URLWithString:threeModel.threeImgurl] placeholderImage:placeHoderImage];
    CGFloat titleH =[threeModel.threeTitle sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(kWidth-156, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    cell.needTitle.frame =CGRectMake(135, 9, kWidth-156, titleH);
    cell.needTitle.text =[NSString stringWithFormat:@"         %@",threeModel.threeTitle];
    cell.companyName.text =threeModel.threeCompanyname;
    [cell.zanBtn setTitle:[NSString stringWithFormat:@"%d",threeModel.threeHits ] forState:UIControlStateNormal];
    [cell.needSmailImage typeID:threeModel.threeType];
    //    NSLog(@"%f---%d",cell.frame.size.height,indexPath.row);
    if (indexPath.row>=15) {
        topBtn.hidden =NO;
    }else if (indexPath.row<=10){
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

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[DBTool shareDBToolClass]deleteAllEntity];
}

@end
