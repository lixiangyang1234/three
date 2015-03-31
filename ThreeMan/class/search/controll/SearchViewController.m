//
//  SearchViewController.m
//  ThreeMan
//
//  Created by Tianj on 15/3/28.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "SearchViewController.h"
#import "HotCell.h"
#import "HistoryCell.h"
#import "FileCell.h"
#import "EnterpriseCell.h"
#import "DefaultHeaderView.h"
#import "HotItem.h"
#import "RemindView.h"
#import "FileItem.h"
#import "EnterpriseItem.h"
#import "VideoViewController.h"
#import "SaveTempDataTool.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);

    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _results = [[NSMutableArray alloc] initWithCapacity:0];
    
    frame = CGRectMake(0, 0, kWidth, kHeight-64);
    
    
    [self loadNavItems];
    
    [self loadTableView];
    
    [self loadDefaultData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark 键盘弹出
- (void)keyboardWillShow:(NSNotification *)notify
{
    NSDictionary *dic = [notify userInfo];
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    CGRect rect = _resultTableView.frame;
    rect.size.height = (kHeight-64)-keyboardFrame.size.height;
    frame = rect;
    if (_tableView.hidden) {
        _resultTableView.frame = frame;
    }else{
        _tableView.frame = frame;
    }
}


#pragma mark 键盘隐藏
- (void)keyboardWillHidden
{
    frame = CGRectMake(0, 0, kWidth, kHeight-64);
    [UIView animateWithDuration:0.1 animations:^{
        if (_tableView.hidden) {
            _resultTableView.frame = frame;
        }else{
            _tableView.frame = frame;
        }
    }];
}

- (void)loadTableView
{
    //默认列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kWidth,kHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tag = 1000;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
    
    //搜索结果列表
    _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _resultTableView.dataSource = self;
    _resultTableView.delegate = self;
    _resultTableView.tag = 1001;
    _resultTableView.backgroundColor = HexRGB(0xe8e8e8);
    _resultTableView.separatorColor = [UIColor clearColor];
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_resultTableView];
    _resultTableView.hidden = YES;
}

#pragma mark 导航栏相关视图
- (void)loadNavItems
{
    //搜索框
    CGFloat width = kWidth-140;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,32)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 32/2;
    view.layer.masksToBounds = YES;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(32/2, 0,width-32/2, 32)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.delegate  = self;
    [view addSubview:_textField];
    _textField.placeholder = @"搜索课程、企业";
    self.navigationItem.titleView = view;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:_textField];
    
    //搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 50, 30);
    [searchBtn setImage:[UIImage imageNamed:@"nav_search_btn"] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}

#pragma mark 搜索框内容改变
- (void)textFieldChange
{
    if (_textField.text.length == 0) {
        if (_tableView.hidden) {
            _tableView.hidden = NO;
            _resultTableView.hidden = YES;
            _tableView.frame = frame;
            [_tableView reloadData];
        }
    }
}

#pragma mark 加载默认数据(热门搜索、搜索历史)
- (void)loadDefaultData
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i<11; i++) {
        HotItem *item = [[HotItem alloc] init];
        item.title = @"职场技能";
        [arr addObject:item];
    }
    [_dataArray addObject:arr];
    NSMutableArray *mutableArr = [SaveTempDataTool unarchiveClassWithFileName:@"history"];
    if (mutableArr) {
        [_dataArray addObject:mutableArr];
    }
}

#pragma mark 搜索按钮点击
- (void)search
{
    if (_textField.text.length==0) {
        [RemindView showViewWithTitle:@"搜索内容不能为空" location:TOP];
    }else{
        [_textField resignFirstResponder];
        if (_dataArray.count<2) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:_textField.text, nil];
            BOOL ret = [SaveTempDataTool archiveClass:array FileName:@"history"];
            if (ret) {
                [_dataArray addObject:array];
            }
        }else{
            NSMutableArray *arr = [_dataArray objectAtIndex:1];
            [arr insertObject:_textField.text atIndex:0];
            BOOL ret =  [SaveTempDataTool archiveClass:arr FileName:@"history"];
            if (ret) {
                [_dataArray replaceObjectAtIndex:1 withObject:arr];
            }
        }
        [self loadResultData];
    }
}

#pragma mark 请求搜索结果
- (void)loadResultData
{
    [_results removeAllObjects];
    
    NSMutableArray *firstArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ; i< 10 ; i++) {
        FileItem *item = [[FileItem alloc] init];
        item.image = @"";
        item.title = @"与大师有约门票";
        item.desc = @"王大妈老师";
        [firstArr addObject:item];
    }
    [_results addObject:firstArr];
    
    NSMutableArray *secondArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ; i< 10 ; i++) {
        EnterpriseItem *item = [[EnterpriseItem alloc] init];
        item.image = @"";
        item.title = @"途牛旅游网";
        item.desc = @"课程21";
        item.content = @"途牛旅游网-中国知名的在线旅游预订平台，提供北京、上海、广州、深圳等64个城市出发的旅游度假产品预订服务，包括跟团游、自助游、自驾游、邮轮、公司旅游、酒店以及景区门票预订等，产品全面，价格透明，全年365天4007-999-999电话预订，提供丰富的后续服务和保障。";
        [secondArr addObject:item];
    }
    [_results addObject:secondArr];

    NSMutableArray *thirdArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ; i< 10 ; i++) {
        FileItem *item = [[FileItem alloc] init];
        item.image = @"";
        item.title = @"与大师有约门票";
        item.desc = @"王大妈老师";
        [thirdArr addObject:item];
    }
    [_results addObject:thirdArr];

    if (_resultTableView.hidden) {
        _tableView.hidden = YES;
        _resultTableView.hidden = NO;
        _resultTableView.frame = frame;
    }
    [_resultTableView reloadData];
}

#pragma mark scrollView_delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.tag == 1001) {
            [_textField resignFirstResponder];
        }
    }
}

#pragma mark tableView_dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        if (section == 0) {
            NSMutableArray *arr = [_dataArray objectAtIndex:section];
            return arr.count%3==0?arr.count/3:arr.count/3+1;
        }
        return [[_dataArray objectAtIndex:section] count];
    }else{
        NSUInteger count = [[_results objectAtIndex:section] count];
        if (count<3) {
            return count;
        }else
            return 3;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1000) {
        return _dataArray.count;
    }else
        return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //默认列表
    if (tableView.tag == 1000) {
        if (indexPath.section == 0) {
            static NSString *identify1 = @"identify1";
            HotCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
            if (cell == nil) {
                cell = [[HotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
            }
            NSMutableArray *array = [_dataArray objectAtIndex:indexPath.section];
            HotItem *item1 = [array objectAtIndex:indexPath.row*3];
            [cell.firstBtn setTitle:item1.title forState:UIControlStateNormal];
            cell.firstBtn.tag = 1000+indexPath.row*3;
            [cell.firstBtn addTarget:self action:@selector(hotBtnDown:) forControlEvents:UIControlEventTouchUpInside];
            
            if (array.count<indexPath.row*3+2) {
                cell.secondBtn.hidden = YES;
            }else{
                cell.secondBtn.hidden = NO;
                HotItem *item2 = [array objectAtIndex:indexPath.row*3+1];
                [cell.secondBtn setTitle:item2.title forState:UIControlStateNormal];
                cell.secondBtn.tag = 1000+indexPath.row*3+1;
                [cell.secondBtn addTarget:self action:@selector(hotBtnDown:) forControlEvents:UIControlEventTouchUpInside];

                if (array.count<indexPath.row*3+3) {
                    cell.thirdBtn.hidden = YES;
                }else{
                    cell.thirdBtn.hidden = NO;
                    HotItem *item3 = [array objectAtIndex:indexPath.row*3+2];
                    [cell.thirdBtn setTitle:item3.title forState:UIControlStateNormal];
                    cell.thirdBtn.tag = 1000+indexPath.row*3+2;
                    [cell.thirdBtn addTarget:self action:@selector(hotBtnDown:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *identify2 = @"identify2";
            HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
            if (cell == nil) {
                cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
            }
            NSString *str =[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.titleLabel.text = str;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    //搜索列表
    }else{
        //视频
        if (indexPath.section == 0) {
            static NSString *identify3 = @"identify3";
            FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
            if (cell == nil) {
                cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify3];
            }
            NSMutableArray *array1 = [_results objectAtIndex:indexPath.section];
            FileItem *item = [array1 objectAtIndex:indexPath.row];
            cell.imgView.backgroundColor = [UIColor redColor];
            cell.titleLabel.text = item.title;
            cell.desLabel.text = item.desc;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        //企业
        }else if(indexPath.section == 1){
            static NSString *identify4 = @"identify4";
            EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
            if (cell == nil) {
                cell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify4];
            }
            NSMutableArray *array2 = [_results objectAtIndex:indexPath.section];
            EnterpriseItem *item = [array2 objectAtIndex:indexPath.section];
            cell.imgView.backgroundColor = [UIColor redColor];
            cell.titleLabel.text = item.title;
            cell.littleLabel.text = item.desc;
            cell.contentLabel.text = item.content;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        //课件
        }else{
            static NSString *identify5 = @"identify5";
            FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identify5];
            if (cell == nil) {
                cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify5];
            }
            NSMutableArray *array3 = [_results objectAtIndex:indexPath.section];
            FileItem *item = [array3 objectAtIndex:indexPath.row];
            cell.imgView.backgroundColor = [UIColor redColor];
            cell.titleLabel.text = item.title;
            cell.desLabel.text = item.desc;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}


#pragma mark tableView_delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        if (section == 0) {
            DefaultHeaderView *headerView = [[DefaultHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
            [headerView setImgView:[UIImage imageNamed:@"hot_search"] title:@"热门搜索"];
            return headerView;
        }else if (section == 1){
            DefaultHeaderView *headerView = [[DefaultHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
            [headerView setImgView:[UIImage imageNamed:@"history_search"] title:@"搜索历史"];
            return headerView;
        }
    }else{
        switch (section) {
            case 0:
            {
                ResultHeaderView *headView = [[ResultHeaderView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
                headView.tag = 1000;
                headView.delegate = self;
                [headView setImgView:[UIImage imageNamed:@"video_search"] title:@"视频" count:@"234"];
                return headView;
            }
                break;
            case 1:
            {
                ResultHeaderView *headView = [[ResultHeaderView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
                headView.tag = 1001;
                headView.delegate = self;
                [headView setImgView:[UIImage imageNamed:@"company_search"] title:@"企业" count:@"234"];
                return headView;

            }
                break;
            case 2:
            {
                ResultHeaderView *headView = [[ResultHeaderView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
                headView.tag = 1002;
                headView.delegate = self;
                [headView setImgView:[UIImage imageNamed:@"document_search"] title:@"课件" count:@"234"];
                return headView;

            }
                break;
  
            default:
                return nil;
                break;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        if (indexPath.section == 0) {
            NSMutableArray *arr = [_dataArray objectAtIndex:indexPath.section];
            NSUInteger count =  arr.count%3==0?arr.count/3:arr.count/3+1;
            if (indexPath.row<count-1) {
                return 44;
            }else
                return 44+9;
        }else
            return 45;

    }else{
        if (indexPath.section == 0) {
            return 47;
        }else if(indexPath.section ==1){
            return 90;
        }else
            return 47;
    }
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        if (section == 1) {
            return 50;
        }
    }
    return 0.00000000000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        if (section == 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, kWidth,50);
            [btn setTitle:@"清除历史纪录" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
            return btn;
        }
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return 40;
    }else
        return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了%ld",(long)indexPath.row);
}



#pragma mark 热门搜索按钮点击
- (void)hotBtnDown:(UIButton *)btn
{
    NSLog(@"%d",btn.tag);
}

#pragma mark 清除历史纪录按钮点击
- (void)clearHistory
{
   BOOL ret = [SaveTempDataTool removeFile:@"history"];
    if (ret) {
        [_dataArray removeObjectAtIndex:1];
        [_tableView reloadData];
    }
}


#pragma mark textField_delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark resultHeaderView_delegate 点击搜索列表顶部
- (void)resultHeaderViewTouch:(ResultHeaderView *)view
{
    switch (view.tag-1000) {
        case 0:
        {
            VideoViewController *video = [[VideoViewController alloc] init];
            [self.navigationController pushViewController:video animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;

        default:
            break;
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
