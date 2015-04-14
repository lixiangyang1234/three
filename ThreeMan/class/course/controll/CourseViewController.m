//
//  CourseViewController.m
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseViewCell.h"
#import "CourseViewVCTool.h"
#import "CourseViewVCModel.h"
@interface CourseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation CourseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:HexRGB(0xe0e0e0)];
    _courseArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    [self addLoadStatus];
}
-(void)addLoadStatus{
    [CourseViewVCTool statusesWithCourseSuccess:^(NSMutableArray *statues) {
        NSLog(@"%@",statues);
//        CourseViewVCModel *courseModel =[[CourseViewVCModel alloc]initWithDictionaryForCourse:statues];
        [_courseArray addObjectsFromArray:statues];
        [self addTableView];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 6, kWidth, kHeight-64-6) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor =[UIColor whiteColor];
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _courseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    CourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[CourseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        CourseViewVCModel *courseModel =[_courseArray objectAtIndex:indexPath.row];
        [cell.headerImage setImageWithURL:[NSURL URLWithString:courseModel.courseHeaderImage]placeholderImage:placeHoderImage];
        
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CompanyHomeControll *companyHomeVC=[[CompanyHomeControll alloc]init];
//    [self.navigationController pushViewController:companyHomeVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
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
