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

@interface FavoriteViewController ()<EditViewDelegate,NoDataViewDelegate>
{
    BOOL isEditting;
    EditView *editView;
    YYSearchButton *seletedBtn;
}
@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self buidlUI];
    
    [self loadData];
}

- (void)buidlUI
{
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth,35)];
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,topBgView.frame.size.height, kWidth, kHeight-64-40-topBgView.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
//    view.backgroundColor = [UIColor clearColor];
//    _tableView.tableHeaderView = view;
    [self.view addSubview:_tableView];
    
    editView = [[EditView alloc] init];
    editView.delegate = self;
    editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
    [self.view addSubview:editView];
    
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    
    
    noDataView = [[NoDataView alloc] initWithImage:@"netFailImg_2" title:@"您目前暂无收藏!" btnTitle:@"去收藏"];
    noDataView.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    noDataView.hidden = YES;
    noDataView.delegate = self;
    [self.view addSubview:noDataView];

}

- (void)loadData
{
    [HttpTool postWithPath:@"getCollect" params:nil success:^(id JSON, int code, NSString *msg) {
        if (code == 100) {
            NSLog(@"%@",JSON);
            NSArray *array = JSON[@"data"][@"collect"];
            if (array&&![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    FavoriteItem *item = [[FavoriteItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_dataArray addObject:item];
                }
            }
        }
        if (_dataArray.count==0) {
            noDataView.hidden = NO;
        }else{
            noDataView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
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
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.multipleSelectionBackgroundView = [[UIView alloc] init];
    
    FavoriteItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:placeHoderImage2];
    cell.desLabel.text = item.companyname;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEditting) {
        FavoriteItem *item = [_dataArray objectAtIndex:indexPath.row];
        CourseDetailController *detail = [[CourseDetailController alloc] init];
        detail.courseDetailID = item.sid;
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
            FavoriteItem *item = [_dataArray objectAtIndex:indexPath.row];
            if (i==0) {
                [str appendString:item.mid];
            }else{
                [str appendString:[NSString stringWithFormat:@",%@",item.mid]];
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

//顶部按钮点击
- (void)btnDown:(YYSearchButton *)btn
{
    seletedBtn.isSelected = NO;
    seletedBtn = btn;
    btn.isSelected = YES;
    //需求
    if (btn.tag == 1000) {
        
    //企业
    }else{
        
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
