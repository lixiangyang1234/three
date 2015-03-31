//
//  ResultHeaderView.h
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultHeaderView;

@protocol ResultHeaderViewDelegate <NSObject>

@optional
- (void)resultHeaderViewTouch:(ResultHeaderView *)view;

@end

@interface ResultHeaderView : UIView

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,assign) id <ResultHeaderViewDelegate> delegate;

- (void)setImgView:(UIImage *)image title:(NSString *)title count:(NSString *)count;

@end
