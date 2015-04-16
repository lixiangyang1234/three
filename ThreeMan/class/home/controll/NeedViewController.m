//
//  NeedViewController.m
//  按需求常规
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "NeedViewController.h"
#import "NeedViewCell.h"
#import "YYSearchButton.h"
#import "needListModel.h"
#import "needListTool.h"
#import "CourseDetailController.h"
@interface NeedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    YYSearchButton *_selectedItem;
}
@property(nonatomic,strong)NSMutableArray *needListArray;
@end

@implementation NeedViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:HexRGB(0xffffff)];
    _needListArray =[[NSMutableArray alloc]init];
//    [self addUINavView];
    [self addTableView];
    [self addUIChooseBtn];//添加筛选按钮
    [self addLoadStatus:@"0"];
}
-(void)addLoadStatus:(NSString *)typestr{
    NSDictionary *parmDic =[NSDictionary dictionaryWithObjectsAndKeys:_categoryId,@"id",typestr,@"type" ,nil];

    [HttpTool postWithPath:@"getNeed1List" params:parmDic success:^(id JSON, int code, NSString *msg) {
        if (code == 100) {
            [_needListArray removeAllObjects];
            NSDictionary *dic = [JSON objectForKey:@"data"];
            NSArray *array = [dic objectForKey:@"subject_list"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in array) {
                    needListModel *item = [[needListModel alloc] init];
                    [item setValuesForKeysWithDictionary:dict];
                    [_needListArray addObject:item];
                }
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)addUIChooseBtn{
    NSArray *chooseTitleArray =@[@"全部",@"视频",@"文件"];

    for (int i=0; i<3; i++) {

        YYSearchButton*  chooseBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:chooseBtn];
        chooseBtn.tag =i+10000;
        if (chooseBtn.tag==10000) {

            chooseBtn.isSelected =YES;
            _selectedItem =chooseBtn;
        }
        chooseBtn.frame =CGRectMake(10+i%3*60, 7, 50, 30) ;
        [chooseBtn setTitle:chooseTitleArray[i] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
       
    }
    
                      
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-64-44) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView setBackgroundColor:HexRGB(0xe0e0e0)];
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}
//筛选按钮
-(void)chooseBtnClick:(YYSearchButton *)sender{

    if (sender.tag==10000) {
        [self addLoadStatus:@"0"];

    }else if(sender.tag ==10001){
        [self addLoadStatus:@"1"];
    }
    else if(sender.tag ==10002){
        [self addLoadStatus:@"2"];
    }
    if (sender!=_selectedItem) {
           
        _selectedItem.isSelected =NO;
        sender.isSelected =YES;
        _selectedItem=sender;
    }
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _needListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    NeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[NeedViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        needListModel *needModle =[_needListArray objectAtIndex:indexPath.row];
        [cell.needImage setImageWithURL:[NSURL URLWithString:needModle.imgurl]placeholderImage:placeHoderImage];
        CGFloat titleH =[needModle.title sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(kWidth-156, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        cell.needTitle.frame =CGRectMake(135, 9, kWidth-156, titleH);
        cell.needTitle.text =needModle.title;
        cell.needTitle .font =[UIFont systemFontOfSize:PxFont(20)];

        cell . needTitle . adjustsFontSizeToFitWidth  =  YES ;
        cell . needTitle . adjustsLetterSpacingToFitWidth  =  YES ;
        cell.needTitle.backgroundColor =[UIColor clearColor];
        [cell.zanBtn setTitle:needModle.categoryHits forState:UIControlStateNormal];
        cell.companyName.text =needModle.companyname;
//        NSLog(@"----%@",needModle.title);
        
        
        NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString : cell . needTitle . text ];
//
        NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
//
        paragraphStyle. alignment = NSTextAlignmentLeft ;
//
//        
//        //    paragraphStyle. maximumLineHeight = 40 ;  //最大的行高
//        
        paragraphStyle. lineSpacing = 3 ;  //行自定义行高度
//
        [paragraphStyle setFirstLineHeadIndent :30 + 5 ]; //首行缩进 根据用户昵称宽度在加5个像素
//
        [attributedString addAttribute : NSParagraphStyleAttributeName value :paragraphStyle range : NSMakeRange ( 0 , [ cell . needTitle . text length ])];

        cell . needTitle . attributedText = attributedString;
//
        [ cell . needTitle sizeToFit ];

        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    needListModel *needModel =[_needListArray objectAtIndex:indexPath.row];
    CourseDetailController *courseDetailVC=[[CourseDetailController alloc]init];
    courseDetailVC.courseDetailID =needModel.categoryId;
    [self.navigationController pushViewController:courseDetailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
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
