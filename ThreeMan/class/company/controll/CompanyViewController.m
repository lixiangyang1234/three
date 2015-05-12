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
#import "UIImageView+WebCache.h"

#define pagesize 15

@interface CompanyViewController ()<MJRefreshBaseViewDelegate>
{
    ErrorView *networkError;
    MJRefreshFooterView *refreshFootView;
}
@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64-39) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    refreshFootView = [[MJRefreshFooterView alloc] init];
    refreshFootView.delegate = self;
    refreshFootView.scrollView = _tableView;
    
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    [self loadData:NO];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadData:YES];
}

#pragma mark 请求数据
- (void)loadData:(BOOL)loading
{
    NSDictionary *param;
    if (loading) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pagesize]};
    }else{
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pagesize]};
    }
    if (!loading) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    [HttpTool postWithPath:@"getCaseList" params:param success:^(id JSON, int code, NSString *msg) {
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        if (code == 100) {
            if (!loading) {
                [_dataArray removeAllObjects];
            }
            NSArray *array = [JSON objectForKey:@"data"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    PatternItem *item = [[PatternItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_dataArray addObject:item];
                }
                if (array.count<pagesize) {
                    refreshFootView.hidden = YES;
                }else{
                    refreshFootView.hidden = NO;
                }
            }else{
                refreshFootView.hidden = YES;
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        if (_dataArray.count==0) {
            networkError.hidden = NO;
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
    PatternCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[PatternCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    PatternItem *item =[_dataArray objectAtIndex:indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:item.imgurl] placeholderImage:placeHoderImage2];
    cell.titleLabel.text = item.title;
    cell.readLabel.text = item.number;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatternItem *item = [_dataArray objectAtIndex:indexPath.row];
    PatternDetailController *detail = [[PatternDetailController alloc] init];
    detail.uid = item.uid;
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
