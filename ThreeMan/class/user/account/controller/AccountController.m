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
#import "DrawViewController.h"

@interface AccountController ()
{
    AccountHeadView *headView;
}
@end

@implementation AccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"账户管理"];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
    
    
    
    headView = [[AccountHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 81)];
    [headView.btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    
    nodataView = [[ErrorView alloc] initWithImage:@"netFailImg_2" title:@"目前您的账户尚无纪录!"];
    nodataView.center = CGPointMake(kWidth/2, (kHeight-64)/2);
    nodataView.hidden = YES;
    [_tableView addSubview:nodataView];

}
#pragma mark 充值/提现
- (void)btnDown
{
    UserInfo *userinfo = [SystemConfig sharedInstance].userInfo;
    if ([userinfo.type isEqualToString:@"1"]) {
        //支付
        PayViewController *pay = [[PayViewController alloc] init];
        [self.navigationController pushViewController:pay animated:YES];

    }else{
        //提现
        DrawViewController *draw = [[DrawViewController alloc] init];
        [self.navigationController pushViewController:draw animated:YES];
    }
}

- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTool postWithPath:@"getUserCenter" params:nil success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",JSON);
        if (code == 100) {
            if (_dataArray.count!=0) {
                [_dataArray removeAllObjects];
            }
            NSArray *array = JSON[@"data"][@"payments"];
            if (array&&![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary  *dict in array) {
                    AccountItem *item = [[AccountItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_dataArray addObject:item];
                }
            }
            
            if (_dataArray.count==0) {
                nodataView.hidden = NO;
            }
            NSDictionary *user = JSON[@"data"][@"user"];
            NSString *num = [user objectForKey:@"num"];
            NSString *type = [user objectForKey:@"type"];
            _tableView.tableHeaderView = headView;
            headView.amountLabel.text = num;
            UserInfo *userinfo = [SystemConfig sharedInstance].userInfo;
            if ([type isEqualToString:@"1"]&&[userinfo.type isEqualToString:@"1"]) {
                [headView.btn setTitle:@"充值" forState:UIControlStateNormal];
            }else{
                [headView.btn setTitle:@"提现" forState:UIControlStateNormal];
            }
        }else{
            [RemindView showViewWithTitle:msg location:TOP];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:TOP];
    }];
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
    cell.desLabel.text = item.companyname;
    if ([item.type isEqualToString:@"1"]) {
        cell.amountLabel.text = [NSString stringWithFormat:@"-%@",item.price];
        cell.amountLabel.textColor = HexRGB(0x1c8cc6);
    }else if([item.type isEqualToString:@"2"]){
        cell.amountLabel.textColor = HexRGB(0xd83847);
        cell.amountLabel.text = [NSString stringWithFormat:@"+%@",item.price];
    }else if([item.type isEqualToString:@"3"]){
        cell.amountLabel.textColor = HexRGB(0x1c8cc6);
        cell.amountLabel.text = [NSString stringWithFormat:@"-%@",item.price];
    }
    cell.dateLabel.text = item.addtime;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row<_dataArray.count-1) {
        cell.line.backgroundColor = HexRGB(0xe0e0e0);
    }else{
        cell.line.backgroundColor = HexRGB(0xcacaca);
    }
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
