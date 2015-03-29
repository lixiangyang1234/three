//
//  SearchViewController.m
//  ThreeMan
//
//  Created by Tianj on 15/3/28.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    
    [self loadNavItems];
}

- (void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kWidth,kHeight-64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _resultTableView.dataSource = self;
    _resultTableView.delegate = self;
    [self.view addSubview:_resultTableView];
    _resultTableView.hidden = YES;
}

- (void)loadNavItems
{
    //搜索框
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 200,32)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 32/2;
    view.layer.masksToBounds = YES;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(32/2, 0,200-32, 32)];
    [view addSubview:textField];
    textField.placeholder = @"搜索课程、企业";
    self.navigationItem.titleView = view;
    
    //搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 50, 30);
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}

#pragma mark 搜索按钮点击
- (void)search
{
    
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
