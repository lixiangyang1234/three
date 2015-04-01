//
//  CompySearchController.m
//  ThreeMan
//
//  Created by tianj on 15/3/31.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompySearchController.h"
#import "EnterpriseCell.h"
#import "EnterpriseItem.h"
#import "CompanyHomeControll.h"

@interface CompySearchController ()

@end

@implementation CompySearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);

    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,10)];
    view.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.tableHeaderView = view;
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)loadData
{
    for (int i = 0 ; i< 10 ; i++) {
        EnterpriseItem *item = [[EnterpriseItem alloc] init];
        item.image = @"";
        item.title = @"途牛旅游网";
        item.desc = @"课程21";
        item.content = @"途牛旅游网-中国知名的在线旅游预订平台，提供北京、上海、广州、深圳等64个城市出发的旅游度假产品预订服务，包括跟团游、自助游、自驾游、邮轮、公司旅游、酒店以及景区门票预订等，产品全面，价格透明，全年365天4007-999-999电话预订，提供丰富的后续服务和保障。";
        [_dataArray addObject:item];
    }
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identify";
    EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    EnterpriseItem *item = [_dataArray objectAtIndex:indexPath.row];
    
    cell.imgView.backgroundColor = [UIColor redColor];
    cell.titleLabel.text = item.title;
    cell.littleLabel.text = item.desc;
    cell.contentLabel.text = item.content;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyHomeControll *compy = [[CompanyHomeControll alloc] init];
    [self.navigationController pushViewController:compy animated:YES];
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
