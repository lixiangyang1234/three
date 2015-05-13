//
//  FavoriteViewController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteCell.h"
#import "FavoriteItem.h"
#import "EditView.h"
#import "CourseDetailController.h"
#import "ErrorView.h"
#import "NineBlockController.h"
#import "YYSearchButton.h"
#import "MJRefresh.h"
#import "EnterpriseItem.h"
#import "EnterpriseCell.h"
#import "CompanyHomeControll.h"

#define pagesize 15

@interface FavoriteViewController ()<EditViewDelegate,NoDataViewDelegate,MJRefreshBaseViewDelegate>
{
    UIView *topBgView;
    BOOL isEditting;
    EditView *editView;
    YYSearchButton *seletedBtn;
    MJRefreshFooterView *refreshFootView;
}
@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    // Do any additional setup after loading the view.
    
    _demandArray = [[NSMutableArray alloc] initWithCapacity:0];
    _companyArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    demandType = YES;
    
    [self buidlUI];
    
    [self loadDemandData:NO];
}

- (void)buidlUI
{
    topBgView = [[UIView alloc] initWithFrame:CGRectMake(8,8,kWidth-8*2,35)];
    topBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBgView];
    
    NSArray *array = [NSArray arrayWithObjects:@"需求",@"企业", nil];
    for (int i = 0 ; i < array.count; i++) {
        YYSearchButton *btn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 25);
        btn.center = CGPointMake(13+btn.frame.size.width/2+(btn.frame.size.width+9)*i,topBgView.frame.size.height/2);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.tag = 1000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [topBgView addSubview:btn];
        if (i == 0) {
            btn.isSelected = YES;
            seletedBtn = btn;
        }
        
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,topBgView.frame.origin.y+topBgView.frame.size.height, kWidth, kHeight-64-40-(topBgView.frame.origin.y+topBgView.frame.size.height)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 8)];
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

//加载需求数据
- (void)loadDemandData:(BOOL)loading
{
    NSDictionary *param;
    if (loading) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_demandArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pagesize]};
    }else{
        param = @{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pagesize]};
    }
    //第一次加载数据或刷新数据
    if (!loading) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [HttpTool postWithPath:@"getCollect" params:param success:^(id JSON, int code, NSString *msg) {
        //如果是加载  结束加载动画
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        if (code == 100) {
            if (!loading) {
                [_demandArray removeAllObjects];
            }
            NSArray *array = JSON[@"data"][@"collect"];
            if (array&&![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    FavoriteItem *item = [[FavoriteItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_demandArray addObject:item];
                }
                if (array.count<pagesize) {
                    refreshFootView.hidden = YES;
                }else{
                    refreshFootView.hidden = NO;
                }
            }else{
                refreshFootView.hidden = YES;
            }
        }else{
            [RemindView showViewWithTitle:msg location:TOP];
        }
        
        if (_demandArray.count==0) {
            noDataView.hidden = NO;
        }else{
            noDataView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [_tableView reloadData];
        if (loading) {
            [refreshFootView endRefreshing];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

//加载企业数据
- (void)loadCompanyData:(BOOL)loading
{
    NSDictionary *param;
    if (loading) {
        param = @{@"pageid":[NSString stringWithFormat:@"%lu",(unsigned long)_companyArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pagesize]};
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
                [_companyArray removeAllObjects];
            }
            NSArray *array = JSON[@"data"];
            if (array&&![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    EnterpriseItem *item = [[EnterpriseItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_companyArray addObject:item];
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
        
        if (_companyArray.count==0) {
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
        //编辑状态时 设置顶部按钮不可点击
        for (UIView *subView in topBgView.subviews) {
            subView.userInteractionEnabled = NO;
        }
        
        
    //非编辑状态
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
        }];
        
        for (UIView *subView in topBgView.subviews) {
            subView.userInteractionEnabled = YES;
        }

    }
}

#pragma mark refreshView_delegate 加载代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (demandType) {
        [self loadDemandData:YES];
    }else{
        [self loadCompanyData:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  demandType?_demandArray.count:_companyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (demandType) {
        static NSString *identify1 = @"identify1";
        FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (cell == nil) {
            cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        UIView *view = [[UIView alloc] initWithFrame:cell.frame];
        view.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.multipleSelectionBackgroundView = [[UIView alloc] init];
        
        FavoriteItem *item = [_demandArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.title;
        [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:placeHoderImage2];
        cell.desLabel.text = item.companyname;
        return cell;
    }else{
        static NSString *identify2 = @"identify2";
        EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (cell == nil) {
            cell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        UIView *view = [[UIView alloc] initWithFrame:cell.frame];
        view.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.multipleSelectionBackgroundView = [[UIView alloc] init];

        
        EnterpriseItem *item = [_companyArray objectAtIndex:indexPath.row];
        [cell.imgView setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:placeHoderImage1];
        cell.titleLabel.text = item.companyname;
        cell.littleLabel.text = [NSString stringWithFormat:@"课程%@",item.scorenums];
        cell.contentLabel.text = item.introduce;
        
        return cell;

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (demandType) {
        return 88;
    }
    return 90;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEditting) {
        if (demandType) {
            FavoriteItem *item = [_demandArray objectAtIndex:indexPath.row];
            CourseDetailController *detail = [[CourseDetailController alloc] init];
            detail.courseDetailID = item.sid;
            [self.nav pushViewController:detail animated:YES];
        }else{
            EnterpriseItem *item = [_companyArray objectAtIndex:indexPath.row];
            CompanyHomeControll *detail = [[CompanyHomeControll alloc] init];
            detail.companyId = item.cid;
            [self.nav pushViewController:detail animated:YES];
        }
    }
}

#pragma mark editView_delegate 
- (void)btnClicked:(UIButton *)btn view:(EditView *)view
{
    //全选/全不选操作
    if (btn.tag == 0) {
        btn.selected = !btn.selected;
        //设置全选/全不选状态
        //需求
        if (demandType) {
            for (int i = 0; i < _demandArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                //全选
                if (btn.selected) {
                    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //全不选
                }else{
                    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
                }
            }
        //企业
        }else{
            for (int i = 0; i < _companyArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                //全选
                if (btn.selected) {
                    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //全不选
                }else{
                    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
                }
            }
        }
    //删除操作
    }else{
        //获取选中的cell
        NSArray *array = [_tableView indexPathsForSelectedRows];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (array.count==0) {
            [RemindView showViewWithTitle:@"请选中删除选项" location:MIDDLE];
            return;
        }
        
        NSMutableString *str = [NSMutableString stringWithString:@""];
        //需求删除
        if (demandType) {
            for (int i = 0 ; i < array.count; i++) {
                NSIndexPath *indexPath = [array objectAtIndex:i];
                FavoriteItem *item = [_demandArray objectAtIndex:indexPath.row];
                if (i==0) {
                    [str appendString:item.mid];
                }else{
                    [str appendString:[NSString stringWithFormat:@",%@",item.mid]];
                }
                [arr addObject:item];
            }
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:str,@"id", nil];
            [MBProgressHUD showHUDAddedTo:window animated:YES];
            [HttpTool postWithPath:@"getCollectDel" params:param success:^(id JSON, int code, NSString *msg) {
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
                if (code == 100) {
                    [_demandArray removeObjectsInArray:arr];
                    [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    [RemindView showViewWithTitle:msg location:MIDDLE];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
                [RemindView showViewWithTitle:offline location:MIDDLE];
            }];

        //企业删除
        }else{
            for (int i = 0 ; i < array.count; i++) {
                NSIndexPath *indexPath = [array objectAtIndex:i];
                EnterpriseItem *item = [_companyArray objectAtIndex:indexPath.row];
                if (i==0) {
                    [str appendString:item.uid];
                }else{
                    [str appendString:[NSString stringWithFormat:@",%@",item.uid]];
                }
                [arr addObject:item];
            }
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:str,@"id", nil];
            [MBProgressHUD showHUDAddedTo:window animated:YES];
            
            [HttpTool postWithPath:@"getCollectDel" params:param success:^(id JSON, int code, NSString *msg) {
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
                if (code == 100) {
                    [_companyArray removeObjectsInArray:arr];
                    [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                }else{
                    [RemindView showViewWithTitle:msg location:MIDDLE];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
                [RemindView showViewWithTitle:offline location:MIDDLE];
            }];
 
        }
    }
}

#pragma mark NoDataView_deleagte
- (void)viewClicked:(UIButton *)btn view:(NoDataView *)view
{
    NineBlockController *nine = [[NineBlockController alloc] init];
    [self.nav pushViewController:nine animated:YES];
}

//顶部按钮点击
- (void)btnDown:(YYSearchButton *)btn
{
    if (seletedBtn.tag == btn.tag) {
        return;
    }
    seletedBtn.isSelected = NO;
    seletedBtn = btn;
    btn.isSelected = YES;
    //需求
    if (btn.tag == 1000) {
        demandType = YES;
        [self loadDemandData:NO];
    //企业
    }else{
        demandType = NO;
        [self loadCompanyData:NO];
    }
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
