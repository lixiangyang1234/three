//
//  CompFavoriteVC.m
//  ThreeMan
//
//  Created by tianj on 15/4/24.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompFavoriteVC.h"
#import "FavoriteItem.h"
#import "FavoriteCell.h"
#import "CourseDetailController.h"
#import "NineBlockController.h"
#import "MJRefresh.h"
#import "EnterpriseCell.h"
#import "EnterpriseItem.h"
#import "CompanyHomeControll.h"

#define pagesize 15

@interface CompFavoriteVC ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *refreshFootView;
}
@end


@implementation CompFavoriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self buidlUI];
    
    [self loadData:NO];
    
}

- (void)buidlUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight-64-40) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,8)];
    view.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = view;
    

    refreshFootView = [[MJRefreshFooterView alloc] init];
    refreshFootView.delegate = self;
    refreshFootView.scrollView = _tableView;
    
    editView = [[EditView alloc] init];
    editView.delegate = self;
    editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
    [self.view addSubview:editView];
    
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    
    
    noDataView = [[ErrorView alloc] initWithImage:@"netFailImg_2" title:@"您目前暂无收藏!"];
    noDataView.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];
    
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadData:YES];
}

- (void)loadData:(BOOL)loading
{
    NSDictionary *param;
    if (loading) {
        
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_dataArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pagesize]};
        
    }else{
        
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pagesize]};
    }
    //第一次加载数据或刷新数据
    if (!loading) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [HttpTool postWithPath:@"getCollectCompany" params:param success:^(id JSON, int code, NSString *msg) {
        //如果是加载  结束加载动画
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        if (code == 100) {
            if (!loading) {
                [_dataArray removeAllObjects];
            }
            NSArray *array = JSON[@"data"];
            if (array&&![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    EnterpriseItem *item = [[EnterpriseItem alloc] init];
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
        }
        
        if (_dataArray.count==0) {
            noDataView.hidden = NO;
        }else{
            noDataView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [_tableView reloadData];
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)edit:(BOOL)editting
{
    isEditting = editting;
    [_tableView setEditing:editting animated:YES];
    //编辑状态
    if (editting) {
        if (editView) {
            editView = nil;
        }
        editView = [[EditView alloc] init];
        editView.delegate = self;
        editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
        [self.view addSubview:editView];
        
        [UIView animateWithDuration:0.2 animations:^{
            editView.frame = CGRectMake(0,self.view.frame.size.height-editView.frame.size.height,editView.frame.size.width, editView.frame.size.height);
        }];
        //非编辑状态
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
        }];
    }
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
    cell.littleLabel.text = [NSString stringWithFormat:@"课程 %@",item.scorenums];
    cell.contentLabel.text = item.introduce;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEditting) {
        EnterpriseItem *item = [_dataArray objectAtIndex:indexPath.row];
        CompanyHomeControll *detail = [[CompanyHomeControll alloc] init];
        detail.companyId = item.cid;
        [self.nav pushViewController:detail animated:YES];
    }
}

#pragma mark editView_delegate
- (void)btnClicked:(UIButton *)btn view:(EditView *)view
{
    if (btn.tag == 0) {
        btn.selected = !btn.selected;
        
        for (int i = 0; i < _dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            if (btn.selected) {
                [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }else{
                [_tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
        }
    }else{
        NSArray *array = [_tableView indexPathsForSelectedRows];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (array.count==0) {
            [RemindView showViewWithTitle:@"请选中删除选项" location:MIDDLE];
            return;
        }
        NSMutableString *str = [NSMutableString stringWithString:@""];
        for (int i = 0 ; i < array.count; i++) {
            NSIndexPath *indexPath = [array objectAtIndex:i];
            EnterpriseItem *item = [_dataArray objectAtIndex:indexPath.row];
            if (i==0) {
                [str appendString:item.uid];
            }else{
                [str appendString:[NSString stringWithFormat:@",%@",item.uid]];
            }
            [arr addObject:item];
        }
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:str,@"id", nil];
        NSLog(@"%@",str);
        [MBProgressHUD showHUDAddedTo:window animated:YES];
        [HttpTool postWithPath:@"getCollectDel" params:param success:^(id JSON, int code, NSString *msg) {
            NSLog(@"%@",JSON);
            [MBProgressHUD hideAllHUDsForView:window animated:YES];
            if (code == 100) {
                [_dataArray removeObjectsInArray:arr];
                [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [RemindView showViewWithTitle:msg location:MIDDLE];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:window animated:YES];
            [RemindView showViewWithTitle:offline location:MIDDLE];
        }];
    }
}

#pragma mark NoDataView_deleagte
- (void)viewClicked:(UIButton *)btn view:(NoDataView *)view
{
    NineBlockController *nine = [[NineBlockController alloc] init];
    [self.nav pushViewController:nine animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
