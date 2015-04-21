//
//  CourseViewController.m
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseViewCell.h"
#import "CourseViewVCModel.h"
#import "CourseDetaileControll.h"
@interface CourseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation CourseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:HexRGB(0xe8e8e8)];
    _courseArray =[[NSMutableArray alloc]initWithCapacity:0];
    [self addTableView];

    [self addLoadStatus];
}
-(void)addLoadStatus{
    [HttpTool postWithPath:@"getSsxList" params:nil success:^(id JSON, int code, NSString *msg) {
        if (code == 100) {
            NSDictionary *dic = [JSON objectForKey:@"data"];
            NSArray *array = [dic objectForKey:@"ssx"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    CourseViewVCModel *item = [[CourseViewVCModel alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_courseArray addObject:item];
                }
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
       
    }];

}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-39) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor =  HexRGB(0xe0e0e0);
;
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}
#pragma mark - Table view data source



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
        cell.titleLabel.text =courseModel.title;
        cell.contentLabel.text =courseModel.description;
        [cell.headerImage setImageWithURL:[NSURL URLWithString:courseModel.imgurl]placeholderImage:placeHoderImage1];
       
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"ddddd");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseViewVCModel *courseModel =[_courseArray objectAtIndex:indexPath.row];
    
    CourseDetaileControll *courseVc=[[CourseDetaileControll alloc]init];
    courseVc.courseIndex =courseModel.courseID;
    [self.nav pushViewController:courseVc animated:YES];
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
