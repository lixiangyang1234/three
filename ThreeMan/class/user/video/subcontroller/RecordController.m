//
//  RecordController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RecordController.h"
#import "EditView.h"
#import "RecordItem.h"
#import "FavoriteCell.h"
#import "SectionHeadView.h"
#import "CourseDetailController.h"
#import "DateManeger.h"

@interface RecordController ()<EditViewDelegate>
{
    BOOL isEditting;
    EditView *editView;
}
@end

@implementation RecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    headViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-40) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
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
    
    [self loadData];
}

- (void)loadData
{
    [HttpTool postWithPath:@"getHistory" params:nil success:^(id JSON, int code, NSString *msg) {
        NSLog(@"%@",JSON);
        if (code == 100) {
            NSArray *array = JSON[@"data"][@"history"];
            if (![array isKindOfClass:[NSNull class]]) {
                NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dict  in array) {
                    RecordItem *item = [[RecordItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [mutableArr addObject:item];
                }
                [self seperateData:mutableArr];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//分离出今天和之前的
- (void)seperateData:(NSMutableArray *)mutableArr
{
    //今天的
    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:0];
    //更早的
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:0];
    for (RecordItem *item in mutableArr) {
        NSDate *date = [DateManeger getDateFromTimeStamps:item.addtime];
        BOOL ret = [DateManeger isTodayTime:date];
        if (ret) {
            [arr1 addObject:item];
        }else{
            [arr2 addObject:item];
        }
    }
    if (arr1.count!=0) {
        [_dataArray addObject:arr1];
        
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        [headView setImgView:[UIImage imageNamed:@"today"] title:@"今天"];
        [headViewArray addObject:headView];
    }
    if (arr2.count!=0) {
        [_dataArray addObject:arr2];
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        [headView setImgView:[UIImage imageNamed:@"earlier"] title:@"更早"];
        [headViewArray addObject:headView];
    }
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
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.multipleSelectionBackgroundView = [[UIView alloc] init];
    NSMutableArray *arr;
    arr = [_dataArray objectAtIndex:indexPath.section];
    RecordItem *item = [arr objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:placeHoderImage];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [headViewArray objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEditting) {
        RecordItem *item = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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

        for (int i = 0 ; i < array.count; i++) {
            NSIndexPath *indexPath = [array objectAtIndex:i];
            RecordItem *item = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
