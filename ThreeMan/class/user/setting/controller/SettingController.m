//
//  SettingController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "SettingController.h"
#import "SettingCell.h"
#import "AboutUsController.h"
#import "FeedBackController.h"

@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"设置"];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
    
    [self loadData];
    [_tableView reloadData];
}

- (void)loadData
{
    NSArray *array = [NSArray arrayWithObjects:@"修改密码",@"意见反馈",@"关于三身行",@"操作指南", nil];
    NSArray *array1 = [NSArray arrayWithObjects:@"应许非WIFI网络下载",@"检查更新", nil];
    [_dataArray addObject:array];
    [_dataArray addObject:array1];
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
    static NSString *identify  = @"identify";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil ) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,41, kWidth-8*2,1)];
    if (indexPath.row<[[_dataArray objectAtIndex:indexPath.section] count]-1) {
        line.backgroundColor = HexRGB(0xeaebec);
    }else{
        line.backgroundColor = HexRGB(0xcacaca);
    }
    if (indexPath.section==1&&indexPath.row==0) {
        cell.nextImage.hidden = YES;
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"off",@"on", nil]];
        [control addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        control.selectedSegmentIndex = 1;
        control.center = CGPointMake(kWidth-8*2-15-control.frame.size.width/2,42/2);
        [cell.bgView addSubview:control];
    }else{
        cell.nextImage.hidden = NO;
    }
    [cell.bgView addSubview:line];
    cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }else
        return 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            //修改密码
            case 0:
            {
                
            }
                break;
            //意见反馈
            case 1:
            {
                FeedBackController *feed = [[FeedBackController alloc] init];
                [self.navigationController pushViewController:feed animated:YES];
            }
                break;
            //关于三身行
            case 2:
            {
                AboutUsController *about = [[AboutUsController alloc] init];
                [self.navigationController pushViewController:about animated:YES];
            }
                break;
            //操作指南
            case 3:
            {
                
            }
                break;
   
            default:
                break;
        }
    }else{
        //检查更新
        if (indexPath.row == 1) {
            
        }
    }
}

- (void)resetPassword
{

}

- (void)checkVersion
{
    
}

- (void)valueChange:(UISegmentedControl *)control
{
    NSLog(@"%d",control.selectedSegmentIndex);
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
