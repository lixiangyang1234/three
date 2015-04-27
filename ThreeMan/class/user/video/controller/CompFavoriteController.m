//
//  CompFavoriteController.m
//  ThreeMan
//
//  Created by tianj on 15/4/24.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompFavoriteController.h"
#import "DemandFavController.h"
#import "CompFavoriteVC.h"

@interface CompFavoriteController ()

@end

@implementation CompFavoriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"我的收藏"];
    
    [self addTopView];
    [self addScrollView];
    
    [self loadRigthNavItems];
}

- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kWidth, kHeight-40-64)];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    self.demandVC = [[DemandFavController alloc] init];
    self.demandVC.nav = (WBNavigationController *)self.navigationController;
    self.demandVC.view.frame = CGRectMake(0, 0, kWidth, _scrollView.frame.size.height);
    [_scrollView addSubview:self.demandVC.view];
    
    self.compVC = [[CompFavoriteVC alloc] init];
    self.compVC.nav = (WBNavigationController *)self.navigationController;
    self.compVC.view.frame = CGRectMake(kWidth, 0, kWidth, _scrollView.frame.size.height);
    [_scrollView addSubview:self.compVC.view];
    
    [_scrollView setContentSize:CGSizeMake(kWidth*2, _scrollView.frame.size.height)];

}

- (void)loadRigthNavItems
{
    UIButton *deleteItem =[UIButton buttonWithType:UIButtonTypeCustom];
    deleteItem.frame =CGRectMake(kWidth-50-40, 8, 44, 44);
    [deleteItem setImage:[UIImage imageNamed:@"nav_delete"] forState:UIControlStateNormal];
    [deleteItem setImage:[UIImage imageNamed:@"nav_delete_pre"] forState:UIControlStateSelected];
    [deleteItem addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1= [[UIBarButtonItem alloc] initWithCustomView:deleteItem];
    
    NSArray *array = self.navigationItem.rightBarButtonItems;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
    [arr addObject:item1];
    self.navigationItem.rightBarButtonItems = arr;
}



-(void)delete:(UIButton *)btn
{
    btn.selected = !btn.selected;
    isEditting = !isEditting;
    if (isEditting) {
        _scrollView.scrollEnabled = NO;
        for (UIView *subView in topBgView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subView;
                btn.userInteractionEnabled = NO;
            }
        }
    }else{
        _scrollView.scrollEnabled = YES;
        for (UIView *subView in topBgView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subView;
                btn.userInteractionEnabled = YES;
            }
        }
    }
    
    switch (self.selectedIndex) {
        case 0:
        {
            [self.demandVC edit:isEditting];
        }
            break;
        case 1:
        {
            [self.compVC edit:isEditting];
        }
            break;
        default:
            break;
    }

}


- (void)addTopView
{
    topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    topBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBgView];
    NSArray *array = [NSArray arrayWithObjects:@"需求",@"企业", nil];
    for (int i = 0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kWidth/2*i, 0, kWidth/2, 40);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateSelected];
        [btn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateSelected];
        [btn setTitleColor:HexRGB(0x9a9a9a) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        [topBgView addSubview:btn];
        if (i==0) {
            btn.selected = YES;
            selectedBtn = btn;
        }
    }
    line = [[UIView alloc] initWithFrame:CGRectMake(0,topBgView.frame.size.height-2, kWidth/2, 2)];
    line.backgroundColor = HexRGB(0x1c8cc6);
    [topBgView addSubview:line];
}



- (void)btnDown:(UIButton *)btn
{
    if (selectedBtn == btn) {
        return;
    }
    selectedBtn.selected = NO;
    selectedBtn = btn;
    btn.selected = YES;
    self.selectedIndex = btn.tag-1000;
    [_scrollView setContentOffset:CGPointMake((btn.tag-1000)*kWidth,0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.01 animations:^{
        line.frame = CGRectMake(scrollView.contentOffset.x/2, line.frame.origin.y, line.frame.size.width, line.frame.size.height);
    }];
    if (scrollView.contentOffset.x==0) {
        if (selectedBtn.tag == 1000) {
            return;
        }
        for (UIView *subView in topBgView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subView;
                if (btn.tag == 1000) {
                    btn.selected = YES;
                    selectedBtn = btn;
                }else{
                    btn.selected = NO;
                }
            }
        }
        self.selectedIndex = 0;
    }
    if (scrollView.contentOffset.x==kWidth) {
        if (selectedBtn.tag == 1001) {
            return;
        }
        for (UIView *subView in topBgView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subView;
                if (btn.tag == 1001) {
                    btn.selected = YES;
                    selectedBtn = btn;
                }else{
                    btn.selected = NO;
                }
            }
        }
        self.selectedIndex = 1;
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
