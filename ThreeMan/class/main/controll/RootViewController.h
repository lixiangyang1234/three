//
//  RootViewController.h
//  ThreeMan
//
//  Created by YY on 15-3-17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBNavigationController.h"
@interface RootViewController : UIViewController
@property (nonatomic,strong) WBNavigationController *nav;
@property (nonatomic,strong) UIScrollView * scroll;
-(void)loadCurrent;
@end
