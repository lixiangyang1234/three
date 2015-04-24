//
//  NeedViewController.m
//  按需求常规
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "NeedViewController.h"
#import "NeedViewCell.h"
#import "YYSearchButton.h"
#import "needListModel.h"
#import "CourseDetailController.h"
@interface NeedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ErrorView *notStatus;
    ErrorView *networkError;
    UIButton *topBtn;
    UITableView *_tableView;
    YYSearchButton *_selectedItem;
}
@property(nonatomic,strong)NSMutableArray *needListArray;
@end

@implementation NeedViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:HexRGB(0xffffff)];
    [self setLeftTitle:self.navTitle];
    _needListArray =[[NSMutableArray alloc]init];
//    [self addUINavView];
    [self addTableView];
    [self addErrorView];
     [self addNotLoatStatus];
    [self addUIChooseBtn];//添加筛选按钮
    [self addMBprogressView];
    [self addLoadStatus:@"0"];
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
    [topBtn addTarget:self action:@selector(topBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topBtn setTitle:@"定都" forState:UIControlStateNormal];
    [topBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [topBtn.titleLabel setFont:[UIFont systemFontOfSize:PxFont(12)]];
    topBtn.tag =900;
    
}
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
}
-(void)addLoadStatus:(NSString *)typestr{
    NSDictionary *parmDic =[NSDictionary dictionaryWithObjectsAndKeys:_categoryId,@"id",typestr,@"type" ,nil];
    [HttpTool postWithPath:@"getNeedList" params:parmDic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",JSON);
        [_needListArray removeAllObjects];
        [_tableView reloadData];

        if (code == 100) {
            NSDictionary *dic = [JSON objectForKey:@"data"];
            NSArray *array = [dic objectForKey:@"subject_list"];
            [_needListArray removeAllObjects];

            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    needListModel *item = [[needListModel alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_needListArray addObject:item];
                }
            }
            [_tableView reloadData];
            }

        if (_needListArray.count<=0) {
            notStatus.hidden =NO;
        }else{
            notStatus.hidden =YES;
            
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        networkError.hidden =NO;
    }];

}
-(void)addUIChooseBtn{
    NSArray *chooseTitleArray =@[@"全部",@"视频",@"文件"];

    for (int i=0; i<3; i++) {

        YYSearchButton*  chooseBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:chooseBtn];
        chooseBtn.tag =i+1000;
        if (chooseBtn.tag==1000) {

            chooseBtn.isSelected =YES;
            _selectedItem =chooseBtn;
        }
        chooseBtn.frame =CGRectMake(10+i%3*60, 7, 50, 30) ;
        [chooseBtn setTitle:chooseTitleArray[i] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
       
    }
    
                      
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
//筛选按钮
-(void)chooseBtnClick:(YYSearchButton *)sender{

    if (sender.tag==1000) {
        [self addLoadStatus:@"0"];

    }else if(sender.tag ==1001){
        [self addLoadStatus:@"1"];

    }
    else if(sender.tag ==1002){
        [self addLoadStatus:@"2"];

    }
    if (sender!=_selectedItem) {
           
        _selectedItem.isSelected =NO;
        sender.isSelected =YES;
        _selectedItem=sender;
    }
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _needListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    NeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[NeedViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        needListModel *needModle =[_needListArray objectAtIndex:indexPath.row];
        [cell.needImage setImageWithURL:[NSURL URLWithString:needModle.imgurl]placeholderImage:placeHoderImage];
        
        CGFloat titleH =[needModle.title sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(kWidth-156, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        cell.needTitle.frame =CGRectMake(135, 9, kWidth-156, titleH);
        cell.needTitle.text =[NSString stringWithFormat:@"        %@",needModle.title];

        cell . needTitle . adjustsFontSizeToFitWidth  =  YES ;
        cell . needTitle . adjustsLetterSpacingToFitWidth  =  YES ;
        cell.needTitle.backgroundColor =[UIColor clearColor];
        [cell.zanBtn setTitle:needModle.categoryHits forState:UIControlStateNormal];
        cell.companyName.text =needModle.companyname;
        [cell.needSmailImage typeID:[needModle.categoryType intValue]];

        if (indexPath.row>=14) {
            topBtn.hidden =NO;
        }else if (indexPath.row<=10){
            topBtn.hidden =YES;
        }
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    needListModel *needModel =[_needListArray objectAtIndex:indexPath.row];
    CourseDetailController *courseDetailVC=[[CourseDetailController alloc]init];
    courseDetailVC.courseDetailID =needModel.categoryId;
    [self.navigationController pushViewController:courseDetailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(void)topBtnClick{
    NSIndexPath *indePath =[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indePath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}
//没有网络
-(void)addErrorView{
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    
}
//没有数据
-(void)addNotLoatStatus{
    notStatus = [[ErrorView alloc] initWithImage:@"netFailImg_2" title:@"亲，暂时没有数据哦!"];
    notStatus.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    notStatus.hidden = YES;
    [self.view addSubview:notStatus];
    
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
