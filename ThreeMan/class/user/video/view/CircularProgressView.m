//
//  CircularProgressView.m
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//  QQ:20118368
//  http://nijino.cn

#import "CircularProgressView.h"

@interface CircularProgressView ()

@property (nonatomic,strong) UIImageView *backgroundView;
@property (assign, nonatomic) CGFloat angle;//angle between two lines

@end

@implementation CircularProgressView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        _backColor = [UIColor clearColor];
        _progressColor = HexRGB(0x1c8cc6);
        _lineWidth = 1;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tapGesture];
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//        [self addGestureRecognizer:panGesture];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.userInteractionEnabled = YES;
        [self addSubview:_backgroundView];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tapGesture];
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//        [self addGestureRecognizer:panGesture];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2)
                                                              radius:(CGRectGetWidth(self.bounds) - self.lineWidth) / 2
                                                          startAngle:(CGFloat) - M_PI_2
                                                            endAngle:(CGFloat)(1.5 * M_PI)
                                                           clockwise:YES];
    [self.backColor setStroke];
    backCircle.lineWidth = self.lineWidth;
    [backCircle stroke];
    
    if (self.progress) {
        //draw progress circle
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                                                                      radius:(CGRectGetWidth(self.bounds) - self.lineWidth) / 2
                                                                  startAngle:(CGFloat) - M_PI_2
                                                                    endAngle:(CGFloat)(- M_PI_2 + self.progress * 2 * M_PI)
                                                                   clockwise:YES];
        [self.progressColor setStroke];
        progressCircle.lineWidth = self.lineWidth;
        [progressCircle stroke];
    }
}

- (void)setProgress:(CGFloat)progress
{
    if (_progress >= 1.0 && progress >= 1.0) {
        _progress = 1.0;
        return;
    }
    
    if (progress < 0.0) {
        progress = 0.0;
    }
    if (progress > 1.0) {
        progress = 1.0;
    }
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)setDownloadState:(downloadState)downloadState
{
    _downloadState = downloadState;
    [self setImageWithState:downloadState];

}


- (void)setImageWithState:(downloadState)downloadstate
{
    
    switch (downloadstate) {
        case 0:
        {
            _backgroundView.image = [UIImage imageNamed:@"downloading"];
        }
            break;
        case 1:
        {
            _backgroundView.image = [UIImage imageNamed:@"stop"];

        }
            break;
        case 2:
        {
            _backgroundView.image = [UIImage imageNamed:@"waitting"];

        }
            break;
    
        default:
            break;
    }
}

- (void)handleGesture:(UIGestureRecognizer *)recognizer{
    if ([self.delegate respondsToSelector:@selector(progressViewClicked:)]) {
        [self.delegate progressViewClicked:self];
    }
}


@end
