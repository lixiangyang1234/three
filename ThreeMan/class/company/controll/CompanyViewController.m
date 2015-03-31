//
//  CompanyViewController.m
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompanyViewController.h"
#import "PatternCell.h"
#import "PatternItem.h"
#import "PatternDetailController.h"


@interface CompanyViewController ()

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64-39) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self loadData];
}

#pragma mark 请求数据
- (void)loadData
{
    for (int i = 0 ; i< 10;i++) {
        PatternItem *item = [[PatternItem alloc] init];
        item.image = @"";
        item.title = @"第五届三身行优秀企业标杆案例";
        item.readAmount = @"255";
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
    PatternCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[PatternCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    PatternItem *item =[_dataArray objectAtIndex:indexPath.row];
    cell.imgView.backgroundColor = [UIColor redColor];
    cell.titleLabel.text = item.title;
    cell.readLabel.text = item.readAmount;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatternDetailController *detail = [[PatternDetailController alloc] init];
    [self.nav pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
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
