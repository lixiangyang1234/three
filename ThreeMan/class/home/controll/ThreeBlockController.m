//
//  ThreeBlockController.m
//  ThreeMan
//
//  Created by YY on 15-4-1.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "ThreeBlockController.h"
#import "CourseDetailController.h"
#import "NeedViewCell.h"
#import "YYSearchButton.h"
#import "categoryView.h"
#import "threeBlockModel.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define pageSize 6

@interface ThreeBlockController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,categoryViewDelegate>
{
    ErrorView *networkError;
    ErrorView *notStatus;
    UITableView *_tableView;
    YYSearchButton *_selectedItem;
    MJRefreshHeaderView *refreshHeaderView;
    MJRefreshFooterView *refreshFooterView;
    BOOL isRefresh;
    NSInteger indexBtn;
    
    UIButton *_categoryBtn;
    
}
@end

@implementation ThreeBlockController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:HexRGB(0xffffff)];
    _selectedIntem =[UIButton buttonWithType:UIButtonTypeCustom];

    _threeArray =[NSMutableArray array];
    _categoryArray =[NSMutableArray array];
    _threeListArray =[NSMutableArray array];
    [self setLeftTitle:self.navTitle];

    [self addTableView];
    [self addErrorView];
    [self addNotLoatStatus];
    [self addRefreshView];
    [self addUIChooseBtn];//添加筛选按钮
    [self addCategoryBtn];
    [self addLoadStatus:@"0" indexId:_threeId];
}
//-(void)touc
-(void)addRefreshView{
    refreshHeaderView =[[MJRefreshHeaderView alloc]init];
    refreshHeaderView.delegate =self;
    refreshHeaderView.scrollView =_tableView;
    
    refreshFooterView =[[MJRefreshFooterView alloc]init];
    refreshFooterView.delegate =self;
    refreshFooterView.scrollView =_tableView;
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    NSLog(@"----%ld------%ld",(long)indexBtn,(long)_selectedIntem.tag);
    if (![refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        isRefresh = YES;
        if (_selectedItem.tag ==10000)
        {
            
            [self addLoadStatus:@"0" indexId:_threeId ];
            if (indexBtn==100) {
                [self addLoadStatus:@"0" indexId:_threeId ];

            }
           else if (indexBtn ==101||indexBtn==102||indexBtn==103) {
                threeBlockModel *threeModel =[_threeArray objectAtIndex:indexBtn-101];
                NSString * indexid1=[NSString stringWithFormat:@"%d", threeModel.categoryid];
                [self addLoadStatus:@"0" indexId:indexid1 ];
                
            }else if(indexBtn==10||indexBtn==11||indexBtn==12||indexBtn==13||indexBtn==14||indexBtn==15||indexBtn==16){
                if (_categoryArray.count>0) {
                    threeBlockModel *threeModel =[_categoryArray objectAtIndex:indexBtn-10];
                    NSString * indexid2=[NSString stringWithFormat:@"%d", threeModel.cateid];
                    [self addLoadStatus:@"0" indexId:indexid2];
                }
                
                
            }
            
        }else if (_selectedItem.tag ==10001) {
            [self addLoadStatus:@"1" indexId:_threeId ];
            
            if (indexBtn==100) {
                [self addLoadStatus:@"0" indexId:_threeId ];
                
            }
            
           else if (indexBtn ==101||indexBtn==102||indexBtn==103) {
                threeBlockModel *threeModel =[_threeArray objectAtIndex:indexBtn-101];
                NSString * indexid1=[NSString stringWithFormat:@"%d", threeModel.categoryid];
                [self addLoadStatus:@"1" indexId:indexid1 ];
                
            }else if(indexBtn==10||indexBtn==11||indexBtn==12||indexBtn==13||indexBtn==14||indexBtn==15||indexBtn==16){
                if (_categoryArray.count>0) {
                    threeBlockModel *threeModel =[_categoryArray objectAtIndex:indexBtn-10];
                    NSString * indexid2=[NSString stringWithFormat:@"%d", threeModel.cateid];
                    [self addLoadStatus:@"1"indexId:indexid2];
                }
                
                
            }
            
        }else if (_selectedItem.tag ==10002)
        {
            [self addLoadStatus:@"2||3||4||5||6||7||8" indexId:_threeId];
            if (indexBtn==100) {
                [self addLoadStatus:@"0" indexId:_threeId ];
                
            }
           else if (indexBtn ==101||indexBtn==102||indexBtn==103) {
                threeBlockModel *threeModel =[_threeArray objectAtIndex:indexBtn-101];
                NSString * indexid1=[NSString stringWithFormat:@"%d", threeModel.categoryid];
                [self addLoadStatus:@"2||3||4||5||6||7||8" indexId:indexid1 ];
                
            }else if(indexBtn==10||indexBtn==11||indexBtn==12||indexBtn==13||indexBtn==14||indexBtn==15||indexBtn==16){
                if (_categoryArray.count>0) {
                threeBlockModel *threeModel =[_categoryArray objectAtIndex:indexBtn-10];
                NSString * indexid2=[NSString stringWithFormat:@"%d", threeModel.cateid];
                [self addLoadStatus:@"2||3||4||5||6||7||8" indexId:indexid2];
                }
            }
            
        }
        
        
    }else{
      
        [self isRefreshLoad];
       
    }

}
-(void)addLoadStatus:(NSString *)typestr indexId:(NSString *)indexid{
    NSDictionary *parmDic;
    if (isRefresh) {
        parmDic =@{@"pageid":[NSString stringWithFormat:@"%ld",(unsigned long)_threeListArray.count],@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"type":typestr ,@"id":indexid    };
    }else{
        parmDic =@{@"pageid":@"0",@"pagesize":[NSString stringWithFormat:@"%d",pageSize],@"type":typestr ,@"id":indexid   };
    }
    if (!isRefresh) {
        MBProgressHUD *progress =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progress.labelText =@"加载中...";
    }
    [HttpTool postWithPath:@"getNeedList" params:parmDic success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"========>%@",JSON);
        if (isRefresh) {
            [refreshFooterView endRefreshing];
        }else{
            [refreshHeaderView endRefreshing];

            [MBProgressHUD hideAllHUDsForView :self.view animated:YES];
//        }
//        if (!isRefresh) {
            [_threeListArray removeAllObjects];

        }

        if (code == 100) {
//            [_categoryArray removeAllObjects];
//            [_threeArray removeAllObjects];

            
            NSDictionary *dic = [JSON objectForKey:@"data"][@"subcategory_list"];
            
            NSDictionary *dic1 = [JSON objectForKey:@"data"];
            NSArray *array =dic1[@"subcategory_list"];
            NSDictionary *arr =[array objectAtIndex:0];
            NSDictionary *arrdic =arr[@"subcategory"];
            NSDictionary *dic2 = [JSON objectForKey:@"data"][@"subject_list"];

            


            if (![dic isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict in dic) {
                    threeBlockModel *item = [[threeBlockModel alloc] initWithForArray:dict];
                    [_threeArray addObject:item];
                }
                
            }
            if (![dic1 isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dict1 in arrdic) {
                    threeBlockModel *cateModel = [[threeBlockModel alloc] initWithForCategory:dict1];
                    [_categoryArray addObject:cateModel];
                }
            }
            if (![dic2 isKindOfClass:[NSNull class]]) {

                if (dic2.count<pageSize) {
                    refreshFooterView.hidden =YES;

                }else{
                    refreshFooterView.hidden = NO;

                }
            for (NSDictionary *dict1 in dic2) {
                threeBlockModel *cateModel = [[threeBlockModel alloc] initWithForThreeList:dict1];
                [_threeListArray addObject:cateModel];
                
            }
            }else{
                refreshFooterView.hidden = NO;

            }
            

        }
        

        if (_threeListArray.count<=0) {
            notStatus.hidden =NO;
            networkError.hidden =YES;

            refreshFooterView.hidden =YES;
        }else{
            notStatus.hidden =YES;
//             refreshFooterView.hidden = NO;
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        if (isRefresh) {
            [refreshFooterView endRefreshing];
        }else{
            [refreshHeaderView endRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }
        if (_threeListArray.count<=0) {
            notStatus.hidden =YES;
            networkError.hidden =NO;
        }
    }];
    
}
//添加筛选按钮
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
        
        chooseBtn.frame =CGRectMake(8+i%3*55, 6, 50, 28) ;
        [chooseBtn setTitle:chooseTitleArray[i] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(tchooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:PxFont(18)]];
        
        
    }
    
    
}
-(void)addCategoryBtn{
    UIButton*  categoryBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:categoryBtn];
    categoryBtn.frame =CGRectMake(kWidth-100, 7, 100, 30) ;
    [categoryBtn setTitle:@"全部类型" forState:UIControlStateNormal];
    [categoryBtn setImage:[UIImage imageNamed:@"downlower"] forState:UIControlStateNormal];
    [categoryBtn addTarget:self action:@selector(threeCategoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryBtn.titleLabel setFont:[UIFont systemFontOfSize:PxFont(18)]];
    [categoryBtn setTitleColor:HexRGB(0x959595) forState:UIControlStateNormal];
    categoryBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 75, 0, 0);
    categoryBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 25);
    categoryBtn.backgroundColor =[UIColor clearColor];
    _categoryBtn=categoryBtn;
    
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, kWidth, kHeight-64-40) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView setBackgroundColor:HexRGB(0xe0e0e0)];
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}
#pragma mark ----chooseBtn categoryBtn 筛选按钮
//筛选按钮
-(void)tchooseBtnClick:(YYSearchButton *)sender{
    
_selectedIntem.tag =sender.tag;
        if (sender!=_selectedItem) {
           
        _selectedItem.isSelected =NO;
        sender.isSelected =YES;
        _selectedItem=sender;
            
    }
    [self isRefreshLoad];

    
}
-(void)threeCategoryBtnClick:(UIButton *)sender{
    
   
    [UIView animateWithDuration:0.001 animations:^{
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, DEGREES_TO_RADIANS(180));
    }];
    if (_threeArray.count==0) {
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }else {
        
    
    
    
    CGPoint point = CGPointMake(kWidth-60, sender.frame.origin.y + sender.frame.size.height+60);
    
    NSMutableArray *titles = [NSMutableArray array];
    
    [titles addObject:@"全部类型"];
    for (int i=0; i<_threeArray.count; i++) {
        threeBlockModel *threeModel =[_threeArray objectAtIndex:i];
        NSString *str =threeModel.categoryTitle;
               [titles addObject:str];

    }
    NSMutableArray *category = [NSMutableArray array];

    for (int c=0; c<_categoryArray.count; c++) {
        threeBlockModel *categoryModel =[_categoryArray objectAtIndex:c];

        NSString *cateStr =categoryModel.cateTitle;
        [category addObject:cateStr];
    }
    
    
    
    categoryView *popView = [[categoryView alloc] initWithPoint:point titles:titles categoryTitles:category];
        popView.delegate =self;
        popView.threeCount =_threeArray.count;
        popView.threeCount1 =_categoryArray.count;
    popView.selectRowAtIndex = ^(NSInteger index)
    {
       
        NSLog(@"------>%ld",(long)index);
        if (index==100||index==101||index==102||index==103) {
            [sender setTitle:titles[index-100] forState:UIControlStateNormal];
            if (index==101) {
                [sender setTitle:category[index-101] forState:UIControlStateNormal];

            }

        }else{
            [sender setTitle:category[index-10] forState:UIControlStateNormal];

        }
        
        indexBtn =index;
        if (index==101) {
            
        }else {
        [UIView animateWithDuration:0.001 animations:^{
            sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, DEGREES_TO_RADIANS(180));
        }];
        
        }

        [self isRefreshLoad];
    };
        
    [popView show];
      
        
    }
   
}
-(void)ThreeChooseBtn:(UIButton *)choose{
    choose =_categoryBtn;
    [UIView animateWithDuration:0.001 animations:^{
        choose.imageView.transform = CGAffineTransformRotate(choose.imageView.transform, DEGREES_TO_RADIANS(180));
    }];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _threeListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndexfider =@"CourseCell";
    
    NeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
    if (!cell) {
        cell =[[NeedViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        [cell setBackgroundColor:HexRGB(0xe0e0e0)];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    if (_threeListArray.count>0) {
        threeBlockModel *threeModel =[_threeListArray objectAtIndex:indexPath.row];

    
    [cell.needImage setImageWithURL:[NSURL URLWithString:threeModel.threeImgurl] placeholderImage:placeHoderImage];
    CGFloat titleH =[threeModel.threeTitle sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(kWidth-156, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    cell.needTitle.frame =CGRectMake(135, 9, kWidth-156, titleH);
    cell.needTitle.text =[NSString stringWithFormat:@"        %@",threeModel.threeTitle];
    cell.companyName.text =threeModel.threeCompanyname;
    [cell.zanBtn setTitle:[NSString stringWithFormat:@"%d",threeModel.threeHits ] forState:UIControlStateNormal];
    [cell.needSmailImage typeID:threeModel.threeType];
   
    }
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    threeBlockModel *threeModel =[_threeListArray objectAtIndex:indexPath.row];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CourseDetailController *courseDetailVC=[[CourseDetailController alloc]init];
       courseDetailVC.courseDetailID  = [NSString stringWithFormat:@"%d", threeModel.threeId];
        [self.navigationController pushViewController:courseDetailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[DBTool shareDBToolClass]deleteAllEntity];
}
//没有网络
-(void)addErrorView{
    networkError = [[ErrorView alloc] initWithImage:@"netFailImg_1" title:@"对不起,网络不给力! 请检查您的网络设置!"];
    networkError.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    networkError.hidden = YES;
    [self.view addSubview:networkError];
    
}
//没有数据
-(void)addNotLoatStatus{
    notStatus = [[ErrorView alloc] initWithImage:@"netFailImg_2" title:@"亲，暂时没有数据哦!"];
    notStatus.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    notStatus.hidden = YES;
    [self.view addSubview:notStatus];
    
}
-(void)isRefreshLoad{
    isRefresh = NO;
    if (_selectedItem.tag ==10000)
    {
        
       
         if (indexBtn ==101||indexBtn==102||indexBtn==103) {
            threeBlockModel *threeModel =[_threeArray objectAtIndex:indexBtn-101];
            NSString * indexid1=[NSString stringWithFormat:@"%d", threeModel.categoryid];
            [self addLoadStatus:@"0" indexId:indexid1 ];
            
        }else if(indexBtn==10||indexBtn==11||indexBtn==12||indexBtn==13||indexBtn==14||indexBtn==15||indexBtn==16){
            if (_categoryArray.count>0) {
                threeBlockModel *threeModel =[_categoryArray objectAtIndex:indexBtn-10];
                NSString * indexid2=[NSString stringWithFormat:@"%d", threeModel.cateid];
                [self addLoadStatus:@"0" indexId:indexid2];
            }
            
        } else  {
            [self addLoadStatus:@"0" indexId:_threeId ];
        }
        
    }else if (_selectedItem.tag ==10001) {
        
         if (indexBtn ==101||indexBtn==102||indexBtn==103) {
            threeBlockModel *threeModel =[_threeArray objectAtIndex:indexBtn-101];
            NSString * indexid1=[NSString stringWithFormat:@"%d", threeModel.categoryid];
            [self addLoadStatus:@"1" indexId:indexid1 ];
            
        }else if(indexBtn==10||indexBtn==11||indexBtn==12||indexBtn==13||indexBtn==14||indexBtn==15||indexBtn==16) {
            if (_categoryArray.count>0) {
                threeBlockModel *threeModel =[_categoryArray objectAtIndex:indexBtn-10];
                NSString * indexid2=[NSString stringWithFormat:@"%d", threeModel.cateid];
                [self addLoadStatus:@"1"indexId:indexid2];
            }
           
        }else  {
            [self addLoadStatus:@"1" indexId:_threeId ];
        }
        
    }else if (_selectedItem.tag ==10002)
    {
        if (indexBtn ==101||indexBtn==102||indexBtn==103) {
            threeBlockModel *threeModel =[_threeArray objectAtIndex:indexBtn-101];
            NSString * indexid1=[NSString stringWithFormat:@"%d", threeModel.categoryid];
            [self addLoadStatus:@"2||3||4||5||6||7||8" indexId:indexid1 ];
        }else if(indexBtn==10||indexBtn==11||indexBtn==12||indexBtn==13||indexBtn==14||indexBtn==15||indexBtn==16){
            if (_categoryArray.count>0) {
                threeBlockModel *threeModel =[_categoryArray objectAtIndex:indexBtn-10];
                NSString * indexid2=[NSString stringWithFormat:@"%d", threeModel.cateid];
                [self addLoadStatus:@"2||3||4||5||6||7||8" indexId:indexid2];
            }
            
        }else  {
            [self addLoadStatus:@"2||3||4||5||6||7||8" indexId:_threeId ];
        }
        
    }
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[DBTool shareDBToolClass]deleteAllEntity];
}
@end
