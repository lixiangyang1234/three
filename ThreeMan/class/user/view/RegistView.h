//
//  RegistView.h
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFieldView.H"
#import "KeyboardDelegate.h"

@class RegistView;

@protocol RegistViewDelegate <NSObject>

@optional

- (void)registViewBtnClick:(UIButton *)btn view:(RegistView *)view;

@end

@interface RegistView : UIView
@property (nonatomic,strong) ImageFieldView *telView;
@property (nonatomic,strong) ImageFieldView *nameView;
@property (nonatomic,strong) ImageFieldView *passwordView;
@property (nonatomic,assign) id<RegistViewDelegate> delegate;
@property (nonatomic,assign) id <KeyboardDelegate> keyboardDelegate;

@end
