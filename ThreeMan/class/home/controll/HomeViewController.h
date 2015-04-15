//
//  HomeViewController.h
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RootViewController.h"

@interface HomeViewController : RootViewController
@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,copy)NSArray *noticeArray;

@property(nonatomic,copy)NSMutableArray *slideImages;
@property(nonatomic,strong)NSMutableArray *adsImage;
@property(nonatomic,strong)NSMutableArray *courseArray;
@property(nonatomic,strong)NSMutableArray *categoryArray;
@property(nonatomic,strong)NSMutableArray *tradeArray;

@property(nonatomic,copy)NSMutableArray *slideImagesOffLine;
@property(nonatomic,strong)NSMutableArray *adsImageOffLine;
@property(nonatomic,strong)NSMutableArray *courseArrayOffLine;
@property(nonatomic,strong)NSMutableArray *categoryArrayOffLine;
@property(nonatomic,strong)NSMutableArray *tradeArrayOffLine;
@end
