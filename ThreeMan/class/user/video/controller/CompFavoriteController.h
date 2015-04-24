//
//  CompFavoriteController.h
//  ThreeMan
//
//  Created by tianj on 15/4/24.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "LeftTitleController.h"
#import "CompFavoriteVC.h"
#import "DemandFavController.h"
#import "WBNavigationController.h"

@interface CompFavoriteController : LeftTitleController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *topBgView;
    UIView *line;
    UIButton *selectedBtn;

}

@property (nonatomic,strong) DemandFavController *demandVC;
@property (nonatomic,strong) CompFavoriteVC *compVC;

@end
