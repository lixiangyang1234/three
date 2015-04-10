//
//  ResetSecretView.h
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFieldView.H"
#import "KeyboardDelegate.h"

@class ResetSecretView;

@protocol ResetSecretViewDelegate <NSObject>

@optional

- (void)resetViewBtnClick:(UIButton *)btn view:(ResetSecretView *)view;

@end

@interface ResetSecretView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) ImageFieldView *telView;

@property (nonatomic,strong) ImageFieldView *originView;

@property (nonatomic,strong) ImageFieldView *freshView;

@property (nonatomic,assign) id<ResetSecretViewDelegate> delegate;
@property (nonatomic,assign) id <KeyboardDelegate> keyboardDelegate;

@end
