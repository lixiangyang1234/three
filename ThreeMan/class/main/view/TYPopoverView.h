//
//  TYPopoverView.h
//  ZSEL
//
//  Created by apple on 14-11-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYPopoverView;
@protocol TYPopoverViewDelegate <NSObject>

@optional

- (void)TYPopoverViewTouch:(UIButton *)btn view:(TYPopoverView *)view;

- (void)imageViewClick:(TYPopoverView *)view;

@end

@interface TYPopoverView : UIView



@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *registBtn;
@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic, strong) NSArray       *titleArray;
@property (nonatomic, strong) NSArray       *imageArray;
@property (nonatomic) CGPoint               showPoint;

@property (nonatomic, strong) UIButton      *handerView;
@property (nonatomic, strong) UIButton      *titleBtn;

@property (nonatomic, copy) UIColor         *borderColor;

@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@property (nonatomic,strong) id<TYPopoverViewDelegate> delegate;

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@end
