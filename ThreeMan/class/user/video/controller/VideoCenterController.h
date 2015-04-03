//
//  VideoCenterController.h
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RootViewController.h"
#import "DownloadListController.h"
#import "FavoriteViewController.h"
#import "RecordController.h"
#import "SUNSlideSwitchView.h"
#import "TYPopoverView.h"


@interface VideoCenterController : RootViewController<SUNSlideSwitchViewDelegate,TYPopoverViewDelegate>
@property(nonatomic,strong)DownloadListController *listVC;
@property(nonatomic,strong)FavoriteViewController *favoriteVC;
@property(nonatomic,strong)RecordController *recordVC;
@property(nonatomic,strong)SUNSlideSwitchView *sliderSwitchView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
