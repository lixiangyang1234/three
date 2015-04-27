//
//  VideoViewController.m
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "VideoViewController.h"
#import "CompanyHomeViewCell.h"
#import "FileModel.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    [self.view addSubview:_tableView];
    [self loadData];
}

- (void)loadData
{
    NSDictionary *param = @{@"keywords":self.keywords,@"type":self.type};;
    [HttpTool postWithPath:@"getSelectList" params:param success:^(id JSON, int code, NSString *msg) {
        if (code == 100) {
            NSArray *array = JSON[@"data"][@"select"];
            if (array&&![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    FileModel *fileModel = [[FileModel alloc] init];
                    [fileModel setValuesForKeysWithDictionary:dict];
                    [_dataArray addObject:fileModel];
                }
            }
            [_tableView reloadData];
        }else{
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identify";
    CompanyHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[CompanyHomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
