//
//  MessageController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "MessageController.h"
#import "MessageDetailController.h"
#import "MessageCell.h"
#import "MessageItem.h"
#import "ErrorView.h"

@interface MessageController ()
{
    ErrorView *noMesView;
}
@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"消息"];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    noMesView = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"抱歉,暂无消息!"];
    noMesView.center = CGPointMake(kWidth/2, (kHeight-64)/2);
    noMesView.hidden = YES;
    [self.view addSubview:noMesView];

    
    [self buildUI];
}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
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
    [HttpTool postWithPath:@"getMessage" params:nil success:^(id JSON, int code, NSString *msg) {
        if (code==100) {
            NSArray *message = JSON[@"data"][@"message"];
            if (![message isKindOfClass:[NSNull class]]&&message) {
                for (NSDictionary *dict in message) {
                    MessageItem *item = [[MessageItem alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_dataArray addObject:item];
                }
            }
            if (_dataArray.count==0) {
                noMesView.hidden = NO;
            }
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        networkError.hidden = NO;
    }];
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
    [cell.headerImage setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleLabel.text = item.title;
    cell.contentLabel.text = item.content;
    cell.dateLabel.text = item.addtime;
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
    MessageDetailController *detail = [[MessageDetailController alloc] init];
    detail.uid = item.uid;
    [self.navigationController pushViewController:detail animated:YES];
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
