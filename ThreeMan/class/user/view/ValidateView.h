//
//  ValidateView.h
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFieldView.h"
#import "KeyboardDelegate.h"

@class ValidateView;

@protocol ValidateViewDelegate <NSObject>

@optional

- (void)validateViewBtnClick:(UIButton *)btn view:(ValidateView *)view;

@end

@interface ValidateView : UIView<UITextFieldDelegate>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) ImageFieldView *yzmView;
@property (nonatomic,assign) id<ValidateViewDelegate> delegate;
@property (nonatomic,assign) id <KeyboardDelegate> keyboardDelegate;


- (id)initWithTitle:(NSString *)title;

@end
