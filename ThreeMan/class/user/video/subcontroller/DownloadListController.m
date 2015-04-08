//
//  DownloadListController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "DownloadListController.h"
#import "EditView.h"
#import "FavoriteItem.h"
#import "UnfinishedCell.h"
#import "FinishedCell.h"
#import "CommenHelper.h"
#import "RecommendController.h"
#import "QuestionController.h"
#import "CourseDetailController.h"
#import "SectionHeadView.h"
#import "MemorySizeView.h"

@interface DownloadListController ()<EditViewDelegate>
{
    BOOL isEditting;
    EditView *editView;
    MemorySizeView *memoryView;
}


@end

@implementation DownloadListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self addView];
    
    [self loadData];
}

- (void)addView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-40-40) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];

    editView = [[EditView alloc] init];
    editView.delegate = self;
    editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
    [self.view addSubview:editView];
    
    memoryView = [[MemorySizeView alloc] init];
    NSLog(@"%f",memoryView.frame.size.height);
    memoryView.frame = CGRectMake(0,_tableView.frame.size.height,memoryView.frame.size.width,memoryView.frame.size.height);
    [self.view addSubview:memoryView];
}

- (void)loadData
{
    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 4; i++) {
        FavoriteItem *item = [[FavoriteItem alloc] init];
        item.image = @"";
        item.title = @"与大师有约门票－成功第一网";
        item.desc = @"王大妈老师";
        [arr1 addObject:item];
    }
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 6; i++) {
        FavoriteItem *item = [[FavoriteItem alloc] init];
        item.image = @"";
        item.title = @"与大师有约门票－成功第一网";
        item.desc = @"王大妈老师";
        [arr2 addObject:item];
    }
    [_dataArray addObject:arr1];
    [_dataArray addObject:arr2];
    [_tableView reloadData];
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
    return [[_dataArray objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identify";
    FinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[FinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.multipleSelectionBackgroundView = [[UIView alloc] init];
    cell.recommendBtn.tag = 1000+indexPath.row;
    cell.questionBtn.tag = 2000+indexPath.row;
    [cell.recommendBtn addTarget:self action:@selector(recommend:) forControlEvents:UIControlEventTouchUpInside];
    [cell.questionBtn addTarget:self action:@selector(question:) forControlEvents:UIControlEventTouchUpInside];

    NSMutableArray *arr;
    arr = [_dataArray objectAtIndex:indexPath.section];
    FavoriteItem *item = [arr objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.imgView.image = [UIImage imageNamed:@"img"];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        [headView setImgView:[UIImage imageNamed:@"finish"] title:@"完成"];
        return headView;
    }else{
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        [headView setImgView:[UIImage imageNamed:@"unfinish"] title:@"未完成"];
        return headView;
    }
    return nil;
}

#pragma mark editView_delegate
- (void)btnClicked:(UIButton *)btn view:(EditView *)view
{
    if (btn.tag == 0) {
        btn.selected = !btn.selected;
        for (int i = 0; i < _dataArray.count; i++) {
            NSMutableArray *arr = [_dataArray objectAtIndex:i];
            for (int j =0; j <arr.count; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                if (btn.selected) {
                    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                }else{
                    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
                }
            }
        }
    }else{
        NSArray *array = [_tableView indexPathsForSelectedRows];
        
        if (array.count==0) {
            return;
        }
        NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *a1 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *a2 = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0 ; i < array.count; i++) {
            NSIndexPath *indexPath = [array objectAtIndex:i];
            FavoriteItem *item = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if (indexPath.section == 0) {
                [arr1 addObject:item];
            }else if(indexPath.section == 1){
                [arr2 addObject:item];
            }
            
        }
        
        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_dataArray.count>0) {
            NSMutableArray *array1 = [_dataArray objectAtIndex:0];
            [array1 removeObjectsInArray:arr1];
            if (array1.count != 0) {
                [mutableArr addObject:array1];
            }
            if (_dataArray.count>1) {
                NSMutableArray *array2 = [_dataArray objectAtIndex:1];
                [array2 removeObjectsInArray:arr2];
                if (array2.count != 0) {
                    [mutableArr addObject:array2];
                }
            }
        }
        
        [_dataArray removeAllObjects];
        if (mutableArr.count!=0) {
            [_dataArray addObjectsFromArray:mutableArr];
        }
        [_tableView reloadData];
        //        [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEditting) {
        CourseDetailController *detail = [[CourseDetailController alloc] init];
        [self.nav pushViewController:detail animated:YES];
    }
}


- (void)deleteSections:(NSArray *)sections rows:(NSArray *)rows
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 49;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000000000000001;
}

#pragma mark 推荐按钮点击
- (void)recommend:(UIButton *)btn
{
    RecommendController *recommend = [[RecommendController alloc] init];
    [self.nav pushViewController:recommend animated:YES];
}

#pragma mark 提问按钮点击
- (void)question:(UIButton *)btn
{
    QuestionController *question = [[QuestionController alloc] init];
    [self.nav pushViewController:question animated:YES];
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
