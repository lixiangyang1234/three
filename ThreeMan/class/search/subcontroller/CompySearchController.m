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
#import "MJRefresh.h"

#define pagesize 15

@interface CompySearchController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *refreshFootView;
}
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
    
    refreshFootView = [[MJRefreshFooterView alloc] init];
    refreshFootView.delegate = self;
    refreshFootView.scrollView = _tableView;
    
    [self loadData:NO];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadData:YES];
}

- (void)loadData:(BOOL)loading
{
    NSDictionary *param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pagesize],@"keywords":self.keywords,@"type":self.type};
    if (!loading) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    [HttpTool postWithPath:@"getSelectList" params:param success:^(id JSON, int code, NSString *msg) {
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        if (code == 100) {
            NSArray *select = JSON[@"data"][@"select"];
            if (![select isKindOfClass:[NSNull class]]&&select) {
                for (NSDictionary *dict in select) {
                    EnterpriseItem *item = [[EnterpriseItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_dataArray addObject:item];
                }
                if (select.count<pagesize) {
                    refreshFootView.hidden = YES;
                }else{
                    refreshFootView.hidden = NO;
                }
            }else{
                refreshFootView.hidden = YES;
            }
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
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
    [cell.imgView setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:placeHoderImage1];
    cell.titleLabel.text = item.companyname;
    cell.littleLabel.text = [NSString stringWithFormat:@"课程%@",item.scorenums];
    cell.contentLabel.text = item.introduce;

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
