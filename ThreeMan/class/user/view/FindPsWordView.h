//
//  FindPsWordView.h
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFieldView.h"
#import "KeyboardDelegate.h"

@class  FindPsWordView;
@protocol FindPsWordViewDelegate <NSObject>

@optional

- (void)findViewBtnClick:(UIButton *)btn view:(FindPsWordView *)view;

@end

@interface FindPsWordView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) ImageFieldView *telView;
@property (nonatomic,strong) ImageFieldView *passwordView;
@property (nonatomic,strong) id<FindPsWordViewDelegate> delegate;
@property (nonatomic,assign) id <KeyboardDelegate> keyboardDelegate;

- (void)resignFirstResponder;

@end
