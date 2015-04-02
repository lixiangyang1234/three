//
//  AccountController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "AccountController.h"
#import "AccountHeadView.h"
#import "AccountCell.h"
#import "AccountItem.h"
#import "PayViewController.h"

@interface AccountController ()
{
    AccountHeadView *headView;
}
@end

@implementation AccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"蜕变豆"];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self buildUI];
}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
    
    headView = [[AccountHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 81)];
    [headView.btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [self loadData];
}

- (void)btnDown
{
    PayViewController *pay = [[PayViewController alloc] init];
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)loadData
{
    for (int i = 0 ; i<5; i++) {
        AccountItem *item = [[AccountItem alloc] init];
        item.title = @"03.15期雅思听力测试班";
        item.desc = @"华信博达管理顾问公司";
        item.amount = @"-25";
        item.date = @"2014.15.14";
        [_dataArray addObject:item];
    }
    _tableView.tableHeaderView = headView;
    headView.amountLabel.text = @"238";
    [headView.btn setTitle:@"充值" forState:UIControlStateNormal];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify  = @"identify";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil ) {
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    AccountItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.desLabel.text = item.desc;
    cell.amountLabel.text = item.amount;
    cell.dateLabel.text = item.date;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
