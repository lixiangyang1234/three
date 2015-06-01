//
//  LoginView.h
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFieldView.H"
#import "KeyboardDelegate.h"

@class  LoginView;
@protocol LoginViewDelegate <NSObject>

@optional

- (void)loginViewBtnClick:(UIButton *)btn view:(LoginView *)view;

@end

@interface LoginView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) ImageFieldView *telView;
@property (nonatomic,strong) ImageFieldView *passwordView;
@property (nonatomic,assign) id<LoginViewDelegate> delegate;
@property (nonatomic,assign) id <KeyboardDelegate> keyboardDelegate;

- (void)resignResponder;


@end
