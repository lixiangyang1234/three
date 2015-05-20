//
//  CircularProgressView.h
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//  QQ:20118368
//  http://nijino.cn

#import <UIKit/UIKit.h>


typedef enum
{
    loadingState = 0,
    stopState,
    waitingState
    
}downloadState;

@class CircularProgressView;

@protocol CircularProgressViewDelegate <NSObject>

@optional

- (void)progressViewClicked:(CircularProgressView *)view;

@end

@interface CircularProgressView : UIView

@property (nonatomic) UIColor *backColor;
@property (nonatomic) UIColor *progressColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,assign) downloadState downloadState;
@property (nonatomic,assign) id<CircularProgressViewDelegate> delegate;



@end