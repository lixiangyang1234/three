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
#import "CompySearchController.h"
#import "UIImageView+WebCache.h"
#import "CourseDetailController.h"
#import "CompanyHomeControll.h"
#import "ErrorView.h"

@interface SearchViewController ()
{
    ErrorView *noResultView;
    ErrorView *networkError;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);

    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _videoArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _companyArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _subjectArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _results = [[NSMutableArray alloc] initWithCapacity:0];
    
    _defaultHeadViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _resultHeadViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    frame = CGRectMake(0, 0, kWidth, kHeight-64);
    
    
    [self loadNavItems];
    
    [self loadTableView];
    
    [self loadDefaultData];
    
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];

    
    noResultView = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"抱歉,没有找到相关结果"];
    noResultView.center = CGPointMake(kWidth/2, (kHeight-64)/2);
    noResultView.hidden = YES;
    [self.view addSubview:noResultView];

    
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
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
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
    _resultTableView.backgroundColor =[UIColor clearColor];
    _resultTableView.backgroundView = nil;
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
    searchBtn.frame = CGRectMake(0, 0, 44, 44);
    [searchBtn setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
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
            if (noResultView.hidden == NO) {
                noResultView.hidden = YES;
            }
            if (networkError.hidden == NO) {
                networkError.hidden = YES;
            }
        }
    }
}

#pragma mark 加载默认数据(热门搜索、搜索历史)
- (void)loadDefaultData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTool postWithPath:@"getSelect" params:nil success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (code == 100) {
            NSArray *result = JSON[@"data"][@"select"];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            if (![result isKindOfClass:[NSNull class]]&&result) {
                for (NSDictionary *dict in result) {
                    HotItem *item = [[HotItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [arr addObject:item];
                }
                existHots = YES;
            }
            if (arr.count!=0) {
                
                [_dataArray addObject:arr];

                DefaultHeaderView *headerView = [[DefaultHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
                [headerView setImgView:[UIImage imageNamed:@"hot_search"] title:@"热门搜索"];
                [_defaultHeadViewArray addObject:headerView];
            }
        }
        [self addSearchRecord];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self addSearchRecord];
    }];
}
//添加搜索记录
- (void)addSearchRecord
{
    NSMutableArray *mutableArr = [SaveTempDataTool unarchiveClassWithFileName:@"history"];
    if (mutableArr) {
        
        [_dataArray addObject:mutableArr];

        DefaultHeaderView *headerView = [[DefaultHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        [headerView setImgView:[UIImage imageNamed:@"history_search"] title:@"搜索历史"];

        [_defaultHeadViewArray addObject:headerView];
    }
    [_tableView reloadData];
}

#pragma mark 搜索按钮点击
- (void)search
{
    if (_textField.text.length==0) {
        [RemindView showViewWithTitle:@"搜索内容不能为空" location:TOP];
    }else{
        
        [_textField resignFirstResponder];
        [self requestSearchData:_textField.text];
    }
}

#pragma mark 搜索关键词
- (void)requestSearchData:(NSString *)keywords
{
    
    //隐藏默认tableview
    if (_resultTableView.hidden) {
        _tableView.hidden = YES;
        _resultTableView.hidden = NO;
        _resultTableView.frame = frame;
    }

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:keywords,@"keywords", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTool postWithPath:@"getSelect" params:param success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (code == 100) {
            NSLog(@"%@",JSON);
            [self loadResultData:JSON];
            [self addToRecord];
            _keywords = keywords;
        }
    } failure:^(NSError *error) {
        networkError.hidden = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark 添加搜索关键词到历史纪录
- (void)addToRecord
{
    //没搜索历史
    if (_dataArray.count<2) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:_textField.text, nil];
        BOOL ret = [SaveTempDataTool archiveClass:array FileName:@"history"];
        if (ret) {
            [_dataArray addObject:array];
            
            DefaultHeaderView *headerView = [[DefaultHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
            [headerView setImgView:[UIImage imageNamed:@"history_search"] title:@"搜索历史"];
            
            [_defaultHeadViewArray addObject:headerView];
            
        }
    }else{
        NSMutableArray *arr = [_dataArray objectAtIndex:1];
        int count = 0;
        for (int i = 0 ; i < arr.count; i++) {
            NSString *str = [arr objectAtIndex:i];
            if ([_textField.text isEqualToString:str]) {
                break;
            }
            count++;
        }
        if (count<arr.count) {
            return;
        }
        [arr insertObject:_textField.text atIndex:0];
        BOOL ret =  [SaveTempDataTool archiveClass:arr FileName:@"history"];
        if (ret) {
            [_dataArray replaceObjectAtIndex:1 withObject:arr];
        }
    }
}

#pragma mark 解析搜索数据
- (void)loadResultData:(NSDictionary *)response
{
    [_results removeAllObjects];
    [_videoArray removeAllObjects];
    [_companyArray removeAllObjects];
    [_subjectArray removeAllObjects];
    [_resultHeadViewArray removeAllObjects];
    
    
    NSDictionary *data = [response objectForKey:@"data"];
    NSArray *select_video = [data objectForKey:@"select_video"];
    if (![select_video isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in select_video) {
            FileItem *item = [[FileItem alloc] init];
            [item setValuesForKeysWithDictionary:dic];
            [_videoArray addObject:item];
        }
    }
    
    //视频搜索结果不为空
    if (_videoArray.count!=0) {
        
        [_results addObject:_videoArray];
        ResultHeaderView *headView = [[ResultHeaderView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        headView.tag = 1000;
        headView.delegate = self;
        [headView setImgView:[UIImage imageNamed:@"video_search"] title:@"视频" count:data[@"select_video_count"]];
        
        [_resultHeadViewArray addObject:headView];
        
    }
    //企业搜索结果不为空
    NSArray *select_company = [data objectForKey:@"select_company"];
    if (![select_company isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in select_company) {
            EnterpriseItem *item = [[EnterpriseItem alloc] init];
            [item setValuesForKeysWithDictionary:dic];
            [_companyArray addObject:item];
        }
    }
    if (_companyArray.count!=0) {
        
        [_results addObject:_companyArray];

        
        ResultHeaderView *headView = [[ResultHeaderView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        headView.tag = 1001;
        headView.delegate = self;
        [headView setImgView:[UIImage imageNamed:@"company_search"] title:@"企业" count:data[@"select_company_count"]];

        [_resultHeadViewArray addObject:headView];
    }
    //课件搜索结果不为空
    NSArray *select_subject = [data objectForKey:@"select_subject"];
    if (![select_subject isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in select_subject) {
            FileItem *item = [[FileItem alloc] init];
            [item setValuesForKeysWithDictionary:dic];
            [_subjectArray addObject:item];
        }
    }
    if (_subjectArray.count!=0) {
        
        [_results addObject:_subjectArray];
    
        ResultHeaderView *headView = [[ResultHeaderView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        headView.tag = 1002;
        headView.delegate = self;
        [headView setImgView:[UIImage imageNamed:@"document_search"] title:@"课件" count:data[@"select_subject_count"]];
        
        [_resultHeadViewArray addObject:headView];
    }
    
    if (_results.count==0) {
        noResultView.hidden = NO;
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
        static NSString *identify1 = @"identify1";
        static NSString *identify2 = @"identify2";
        
        if (indexPath.section == 0) {
            //存在热门搜索
            if (existHots) {
                HotCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
                if (cell == nil) {
                    cell = [[HotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
                }
                NSMutableArray *array = [_dataArray objectAtIndex:indexPath.section];
                HotItem *item1 = [array objectAtIndex:indexPath.row*3];
                [cell.firstBtn setTitle:item1.keywords forState:UIControlStateNormal];
                cell.firstBtn.tag = 1000+indexPath.row*3;
                [cell.firstBtn addTarget:self action:@selector(hotBtnDown:) forControlEvents:UIControlEventTouchUpInside];
                
                if (array.count<indexPath.row*3+2) {
                    cell.secondBtn.hidden = YES;
                }else{
                    cell.secondBtn.hidden = NO;
                    HotItem *item2 = [array objectAtIndex:indexPath.row*3+1];
                    [cell.secondBtn setTitle:item2.keywords forState:UIControlStateNormal];
                    cell.secondBtn.tag = 1000+indexPath.row*3+1;
                    [cell.secondBtn addTarget:self action:@selector(hotBtnDown:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (array.count<indexPath.row*3+3) {
                        cell.thirdBtn.hidden = YES;
                    }else{
                        cell.thirdBtn.hidden = NO;
                        HotItem *item3 = [array objectAtIndex:indexPath.row*3+2];
                        [cell.thirdBtn setTitle:item3.keywords forState:UIControlStateNormal];
                        cell.thirdBtn.tag = 1000+indexPath.row*3+2;
                        [cell.thirdBtn addTarget:self action:@selector(hotBtnDown:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            //无热门搜索
            }else{
                HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
                if (cell == nil) {
                    cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
                }
                NSString *str =[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                cell.titleLabel.text = str;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else{
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
        static NSString *identify3 = @"identify3";
        static NSString *identify4 = @"identify4";
        static NSString *identify5 = @"identify5";

        if (indexPath.section == 0) {
            //视频、企业、文件三者都有 第一组为视频搜索结果
            if (_results.count==3) {
                FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
                if (cell == nil) {
                    cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify3];
                }
                NSMutableArray *array1 = [_results objectAtIndex:indexPath.section];
                if (indexPath.row+1<array1.count) {
                    cell.line.backgroundColor = HexRGB(0xcacaca);
                }else{
                    cell.line.backgroundColor = HexRGB(0xe0e0e0);
                }
                FileItem *item = [array1 objectAtIndex:indexPath.row];
                [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"list_fail"]];
                cell.titleLabel.text = item.title;
                cell.desLabel.text = item.content;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }else if(_results.count==2){
                //无企业或课件搜索结果 第一组为视频搜索结果
                if (_companyArray.count==0||_subjectArray.count==0) {
                    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
                    if (cell == nil) {
                        cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify3];
                    }
                    NSMutableArray *array1 = [_results objectAtIndex:indexPath.section];
                    if (indexPath.row+1<array1.count) {
                        cell.line.backgroundColor = HexRGB(0xcacaca);
                    }else{
                        cell.line.backgroundColor = HexRGB(0xe0e0e0);
                    }
                    FileItem *item = [array1 objectAtIndex:indexPath.row];
                    [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"list_fail"]];
                    cell.titleLabel.text = item.title;
                    cell.desLabel.text = item.content;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;

                }
                //无视频搜索结果 第一组为企业搜索结果
                if (_videoArray.count==0) {
                    EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
                    if (cell == nil) {
                        cell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify4];
                    }
                    NSMutableArray *array2 = [_results objectAtIndex:indexPath.section];
                    if (indexPath.row+1<array2.count) {
                        cell.line.backgroundColor = HexRGB(0xcacaca);
                    }else{
                        cell.line.backgroundColor = HexRGB(0xe0e0e0);
                    }
                    EnterpriseItem *item = [array2 objectAtIndex:indexPath.row];
                    [cell.imgView setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:[UIImage imageNamed:@"index_icon_fail"]];
                    cell.titleLabel.text = item.companyname;
                    cell.littleLabel.text = [NSString stringWithFormat:@"课程%@",item.scorenums];
                    cell.contentLabel.text = item.introduce;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            //只有一组搜索结果
            }else{
                if (_videoArray.count!=0) {
                    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
                    if (cell == nil) {
                        cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify3];
                    }
                    NSMutableArray *array1 = [_results objectAtIndex:indexPath.section];
                    if (indexPath.row+1<array1.count) {
                        cell.line.backgroundColor = HexRGB(0xcacaca);
                    }else{
                        cell.line.backgroundColor = HexRGB(0xe0e0e0);
                    }
                    FileItem *item = [array1 objectAtIndex:indexPath.row];
                    [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"list_fail"]];
                    cell.titleLabel.text = item.title;
                    cell.desLabel.text = item.content;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                if (_companyArray.count!=0) {
                    EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
                    if (cell == nil) {
                        cell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify4];
                    }
                    NSMutableArray *array2 = [_results objectAtIndex:indexPath.section];
                    if (indexPath.row+1<array2.count) {
                        cell.line.backgroundColor = HexRGB(0xcacaca);
                    }else{
                        cell.line.backgroundColor = HexRGB(0xe0e0e0);
                    }

                    EnterpriseItem *item = [array2 objectAtIndex:indexPath.row];
                    [cell.imgView setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:[UIImage imageNamed:@"index_icon_fail"]];
                    cell.titleLabel.text = item.companyname;
                    cell.littleLabel.text = [NSString stringWithFormat:@"课程%@",item.scorenums];
                    cell.contentLabel.text = item.introduce;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                if (_subjectArray.count!=0) {
                    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
                    if (cell == nil) {
                        cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify3];
                    }
                    NSMutableArray *array1 = [_results objectAtIndex:indexPath.section];
                    if (indexPath.row+1<array1.count) {
                        cell.line.backgroundColor = HexRGB(0xcacaca);
                    }else{
                        cell.line.backgroundColor = HexRGB(0xe0e0e0);
                    }
                    FileItem *item = [array1 objectAtIndex:indexPath.row];
                    [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"list_fail"]];
                    cell.titleLabel.text = item.title;
                    cell.desLabel.text = item.content;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
         //企业
        }else if(indexPath.section == 1){
            if (_results.count==3) {
                EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
                if (cell == nil) {
                    cell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify4];
                }
                NSMutableArray *array2 = [_results objectAtIndex:indexPath.section];
                if (indexPath.row+1<array2.count) {
                    cell.line.backgroundColor = HexRGB(0xcacaca);
                }else{
                    cell.line.backgroundColor = HexRGB(0xe0e0e0);
                }
                EnterpriseItem *item = [array2 objectAtIndex:indexPath.row];
                [cell.imgView setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:[UIImage imageNamed:@"index_icon_fail"]];
                cell.titleLabel.text = item.companyname;
                cell.littleLabel.text = [NSString stringWithFormat:@"课程%@",item.scorenums];
                cell.contentLabel.text = item.introduce;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                //无视频或企业搜索结果  第二组为课件搜索列表
                if (_videoArray.count==0||_companyArray.count==0) {
                    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
                    if (cell == nil) {
                        cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify3];
                    }
                    NSMutableArray *array1 = [_results objectAtIndex:indexPath.section];
                    if (indexPath.row+1<array1.count) {
                        cell.line.backgroundColor = HexRGB(0xcacaca);
                    }else{
                        cell.line.backgroundColor = HexRGB(0xe0e0e0);
                    }
                    FileItem *item = [array1 objectAtIndex:indexPath.row];
                    [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"list_fail"]];
                    cell.titleLabel.text = item.title;
                    cell.desLabel.text = item.content;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else{
                    EnterpriseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
                    if (cell == nil) {
                        cell = [[EnterpriseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify4];
                    }
                    NSMutableArray *array2 = [_results objectAtIndex:indexPath.section];
                    if (indexPath.row+1<array2.count) {
                        cell.line.backgroundColor = HexRGB(0xcacaca);
                    }else{
                        cell.line.backgroundColor = HexRGB(0xe0e0e0);
                    }
                    EnterpriseItem *item = [array2 objectAtIndex:indexPath.row];
                    [cell.imgView setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:[UIImage imageNamed:@""]];
                    cell.titleLabel.text = item.companyname;
                    cell.littleLabel.text = [NSString stringWithFormat:@"课程%@",item.scorenums];
                    cell.contentLabel.text = item.introduce;
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
        //课件
        }else{
            FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identify5];
            if (cell == nil) {
                cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify5];
            }
            NSMutableArray *array3 = [_results objectAtIndex:indexPath.section];
            if (indexPath.row+1<array3.count) {
                cell.line.backgroundColor = HexRGB(0xcacaca);
            }else{
                cell.line.backgroundColor = HexRGB(0xe0e0e0);
            }
            FileItem *item = [array3 objectAtIndex:indexPath.row];
            [cell.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"list_fail"]];
            cell.titleLabel.text = item.title;
            cell.desLabel.text = item.content;
            
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
        return [_defaultHeadViewArray objectAtIndex:section];
    }else{
        return [_resultHeadViewArray objectAtIndex:section];
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
        if (_dataArray.count==2) {
            if (section==1) {
                return 50;
            }
        }else if(_dataArray.count == 1){
            if (section == 0) {
                NSMutableArray *array = [_dataArray lastObject];
                id value = [array objectAtIndex:0];
                if ([value isKindOfClass:[NSString class]]) {
                    return 50;
                }
            }
        }
    }
    return 0.00000000000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, kWidth,50);
        [btn setTitle:@"清除历史纪录" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        if (_dataArray.count==2) {
            if (section == 1) {
                return btn;
            }
        }else if(_dataArray.count==1){
            NSMutableArray *array = [_dataArray lastObject];
            id value = [array objectAtIndex:0];
            if ([value isKindOfClass:[NSString class]]) {
                return btn;
            }else
                return nil;
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
    if (tableView.tag ==1000) {
        if (existHots) {
            if (indexPath.section==0) {
                return;
            }else{
                NSMutableArray *array = [_dataArray objectAtIndex:indexPath.section];
                NSString *keywords = [array objectAtIndex:indexPath.row];
                _textField.text = keywords;
                [self requestSearchData:keywords];
            }
        }else{
            NSMutableArray *array = [_dataArray objectAtIndex:indexPath.section];
            NSString *keywords = [array objectAtIndex:indexPath.row];
            _textField.text = keywords;
            [self requestSearchData:keywords];
        }
    }else{
        NSMutableArray *array = [_results objectAtIndex:indexPath.section];
        id item = [array objectAtIndex:indexPath.row];
        //视频或文件
        if ([item isKindOfClass:[FileItem class]]) {
            FileItem *obj = (FileItem *)item;
            CourseDetailController *detail = [[CourseDetailController alloc] init];
            detail.courseDetailID = obj.uid;
            [self.navigationController pushViewController:detail animated:YES];
        //企业
        }else{
            EnterpriseItem *obj = (EnterpriseItem *)item;
            CompanyHomeControll *company = [[CompanyHomeControll alloc] init];
            company.companyId = obj.uid;
            [self.navigationController pushViewController:company animated:YES];
        }
    }
}




#pragma mark 热门搜索按钮点击
- (void)hotBtnDown:(UIButton *)btn
{
    [self.view endEditing:YES];
    NSMutableArray *array = [_dataArray objectAtIndex:0];
    HotItem *item = [array objectAtIndex:btn.tag-1000];
    _textField.text = item.keywords;
    [self requestSearchData:item.keywords];
}

#pragma mark 清除历史纪录按钮点击
- (void)clearHistory
{
   BOOL ret = [SaveTempDataTool removeFile:@"history"];
    if (ret) {
        [_dataArray removeLastObject];
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
            video.type = @"1";
            video.keywords = _keywords;
            [self.navigationController pushViewController:video animated:YES];
        }
            break;
        case 1:
        {
            CompySearchController *csc = [[CompySearchController alloc] init];
            csc.keywords = _keywords;
            csc.type = @"2";
            [self.navigationController pushViewController:csc animated:YES];
        }
            break;
        case 2:
        {
            VideoViewController *video = [[VideoViewController alloc] init];
            video.type = @"3";
            video.keywords = _keywords;
            [self.navigationController pushViewController:video animated:YES];
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
