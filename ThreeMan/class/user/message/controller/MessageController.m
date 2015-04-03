//
//  MessageController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "MessageController.h"
#import "PatternDetailController.h"
#import "MessageCell.h"
#import "MessageItem.h"

@interface MessageController ()

@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"消息"];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self buildUI];
}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
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
}

- (void)loadData
{
    for (int i = 0 ; i < 10; i++) {
        MessageItem *item = [[MessageItem alloc] init];
        item.title = @"HTC创始人cher再度出山";
        item.desc = @"现在问题太多,需要一项一项去梳理,4ps里除了产品现在问题太多,需要一项一项去梳理,4ps里除了产品现在问题太多,需要一项一项去梳理,4ps里除了产品现在问题太多,需要一项一项去梳理,4ps里除了产品";
        item.date = @"2015.01.04";
        [_dataArray addObject:item];
    }
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify  = @"identify";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil ) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    MessageItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.contentLabel.text = item.desc;
    cell.dateLabel.text = item.date;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem *item = [_dataArray objectAtIndex:indexPath.row];
    PatternDetailController *pattern = [[PatternDetailController alloc] init];
    [self.navigationController pushViewController:pattern animated:YES];
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
