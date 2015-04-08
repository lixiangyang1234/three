//
//  KeyboardDelegate.h
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol KeyboardDelegate <NSObject>

@optional

- (void)keyboardShow:(UIView *)view frame:(CGRect)frame;

- (void)keyboardHiden:(UIView *)view;


@end
