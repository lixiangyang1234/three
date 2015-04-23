//
//  NoDataView.h
//  ThreeMan
//
//  Created by tianj on 15/4/20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "ErrorView.h"

@class NoDataView;
@protocol NoDataViewDelegate <NSObject>


@optional

- (void)viewClicked:(UIButton *)btn view:(NoDataView *)view;

@end

@interface NoDataView : ErrorView


@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,assign) id<NoDataViewDelegate>delegate;

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title btnTitle:(NSString *)btnTitle;

@end
