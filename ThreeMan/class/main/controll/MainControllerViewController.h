//
//  MainControllerViewController.h
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RootViewController.h"
#import "SUNSlideSwitchView.h"
#import "HomeViewController.h"
#import "CompanyViewController.h"
#import "CourseViewController.h"
@interface MainControllerViewController : RootViewController<SUNSlideSwitchViewDelegate>
@property(nonatomic,strong)HomeViewController *home;
@property(nonatomic,strong)CourseViewController *course;
@property(nonatomic,strong)CompanyViewController *company;
@property(nonatomic,strong)SUNSlideSwitchView *sliderSwitchView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end
