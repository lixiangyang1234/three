//
//  BusinessController.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BusinessController.h"
#import "BusinessViewCell.h"
#import "CompanyHomeControll.h"
#import "businessListModel.h"
@interface BusinessController ()<UITableViewDataSource,UITableViewDelegate>
{
    ErrorView *notStatus;
    ErrorView *networkError;
    UITableView *_tableView;
}
@end

@implementation BusinessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:HexRGB(0xe0e0e0)];
    [self setLeftTitle:self.navTitle];
    _businessArray =[NSMutableArray array];
    [self addTableView];
    [self addMBprogressView];
    [self addErrorView];
    [self addNotLoatStatus];
    [self addLoadStatus];
}
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
}
#pragma mark=====添加数据
-(void)addLoadStatus{
    NSDictionary *paraDic =[NSDictionary dictionaryWithObjectsAndKeys:_tradeId,@"id", nil];
   [HttpTool postWithPath:@"getCompanyList" params:paraDic success:^(id JSON, int code, NSString *msg) {
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

       NSDictionary *dict =JSON[@"data"];
       NSArray *arr =dict[@"company_list"];
       if (code==100) {
           for (NSDictionary *dicArr in arr) {
               businessListModel *businessModel =[[businessListModel alloc]initWithDictonaryForBusinessList:dicArr];
               [_businessArray addObject:businessModel];
           }
           
       }
       [_tableView reloadData];
       if (_businessArray.count<=0) {
           notStatus.hidden =NO;
       }else{
           notStatus.hidden =YES;
       }
   } failure:^(NSError *error) {
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

       networkError.hidden =NO;
   }];
}

#pragma mark---创建TableView

-(UITableView *)addTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.backgroundColor =HexRGB(0xe0e0e0);
        
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
    }
    
    return _tableView;
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _businessArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    BusinessViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[BusinessViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    businessListModel *businessModel =[_businessArray objectAtIndex:indexPath.row];
    [cell.businessImage setImageWithURL:[NSURL URLWithString:businessModel.businessLogo] placeholderImage:placeHoderImage1];
    cell.businessNeed.text =[NSString stringWithFormat:@"需求 %d",businessModel.businessScorenums];
    cell.businessTtile.text =businessModel.businessCompanyname;
    cell.bussinessLabel.text =businessModel.businessIntroduce;
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        businessListModel *businessModel =[_businessArray objectAtIndex:indexPath.row];
        CompanyHomeControll *companyHomeVC=[[CompanyHomeControll alloc]init];
    companyHomeVC.companyId =[NSString stringWithFormat:@"%d", businessModel.businessId];
   
        [self.navigationController pushViewController:companyHomeVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       return 100;
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
#pragma mark 控件将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
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
