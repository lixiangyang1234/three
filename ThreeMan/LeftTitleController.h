//
//  LeftTitleController.h
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BaseViewController.h"
#import "ErrorView.h"


@interface LeftTitleController : BaseViewController
{
    ErrorView *networkError;
}
- (void)setLeftTitle:(NSString *)leftTitle;


@end
