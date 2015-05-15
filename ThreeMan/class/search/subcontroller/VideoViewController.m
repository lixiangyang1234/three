//
//  VideoViewController.m
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "VideoViewController.h"
#import "CompanyHomeViewCell.h"
#import "FileModel.h"
#import "DocumentCell.h"
#import "CourseDetailController.h"
#import "MJRefresh.h"

#define pagesize 15

@interface VideoViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *refreshFootView;
}
@end

@implementation VideoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setLeftTitle:@"搜索结果"];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    refreshFootView = [[MJRefreshFooterView alloc] init];
    refreshFootView.delegate = self;
    refreshFootView.scrollView = _tableView;

    
    [self loadData:NO];
}

- (void)loadData:(BOOL)loading
{
    NSDictionary *param;
    if (loading) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pagesize],@"keywords":self.keywords,@"type":self.type};
    }else{
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pagesize],@"keywords":self.keywords,@"type":self.type};
    }
    if (!loading) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    [HttpTool postWithPath:@"getSelectList" params:param success:^(id JSON, int code, NSString *msg) {
        NSLog(@"%@",JSON);
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        if (code == 100) {
            if (!loading) {
                [_dataArray removeAllObjects];
            }
            NSArray *array = JSON[@"data"][@"select"];
            if (array&&![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    FileModel *fileModel = [[FileModel alloc] init];
                    [fileModel setValuesForKeysWithDictionary:dict];
                    [_dataArray addObject:fileModel];
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
        }else{
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
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
    DocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[DocumentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    FileModel *fileModel = [_dataArray objectAtIndex:indexPath.row];
    [cell setObject:fileModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileModel *fileModel = [_dataArray objectAtIndex:indexPath.row];
    CourseDetailController *course = [[CourseDetailController alloc] init];
    course.courseDetailID = fileModel.uid;
    [self.navigationController pushViewController:course animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
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
