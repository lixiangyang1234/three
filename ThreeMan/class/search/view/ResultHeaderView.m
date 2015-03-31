//
//  ResultHeaderView.m
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "ResultHeaderView.h"
#import "AdaptationSize.h"

@interface RigthView : UIView
{
    UILabel *leftLabel;
    UILabel *midLabel;
    UILabel *rigthLabel;
}

- (void)setLeftTitle:(NSString *)leftTitle rigthTitle:(NSString *)rigthTitle midTitle:(NSString *)midTitle;

@end

@implementation RigthView

#define titleFont [UIFont systemFontOfSize:14]

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = titleFont;
        [self addSubview:leftLabel];
        
        midLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        midLabel.backgroundColor = [UIColor clearColor];
        midLabel.textColor = [UIColor greenColor];
        midLabel.font = titleFont;
        [self addSubview:midLabel];
        
        rigthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        rigthLabel.backgroundColor = [UIColor clearColor];
        rigthLabel.font = titleFont;
        [self addSubview:rigthLabel];
    }
    return self;
}

- (void)setLeftTitle:(NSString *)leftTitle rigthTitle:(NSString *)rigthTitle midTitle:(NSString *)midTitle
{
    NSString *str1 = rigthTitle;
    CGSize size1 = [AdaptationSize getSizeFromString:str1 Font:titleFont withHight:self.frame.size.height withWidth:CGFLOAT_MAX];
    rigthLabel.frame = CGRectMake(self.frame.size.width-size1.width, 0, size1.width, self.frame.size.height);
    rigthLabel.text = str1;
    
    NSString *str2 = midTitle;
    CGSize size2 = [AdaptationSize getSizeFromString:str2 Font:titleFont withHight:self.frame.size.height withWidth:CGFLOAT_MAX];
    midLabel.frame = CGRectMake(rigthLabel.frame.origin.x-size2.width, 0, size2.width, self.frame.size.height);
    midLabel.text = str2;
    
    NSString *str3 = leftTitle;
    CGSize size3 = [AdaptationSize getSizeFromString:str3 Font:titleFont withHight:self.frame.size.height withWidth:CGFLOAT_MAX];
    leftLabel.frame = CGRectMake(midLabel.frame.origin.x-size3.width, 0, size3.width, self.frame.size.height);
    leftLabel.text = str3;

}

@end

@interface ResultHeaderView ()
{
    RigthView *desView;
}
@end

@implementation ResultHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HexRGB(0xf3f3f3);
        CGFloat topDis = 5;
        CGFloat leftDis = 10;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftDis,topDis, frame.size.width-leftDis*2,frame.size.height-topDis*2)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, bgView.frame.size.height)];
        [bgView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.frame.origin.x+_imgView.frame.size.width+5, 0,80,bgView.frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_titleLabel];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width-25,(bgView.frame.size.height-25)/2,25,25)];
        imageView.image = [UIImage imageNamed:@"rightSore"];
        [bgView addSubview:imageView];
        
        desView = [[RigthView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x-150, 0,150,bgView.frame.size.height)];
        desView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:desView];

        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
    }
    return self;
}

- (void)setImgView:(UIImage *)image title:(NSString *)title count:(NSString *)count
{
    _imgView.image = image;
    _titleLabel.text = title;
    [desView setLeftTitle:@"总共" rigthTitle:@"条结果" midTitle:count];
}

- (void)btnDown
{
    if ([self.delegate respondsToSelector:@selector(resultHeaderViewTouch:)]) {
        [self.delegate resultHeaderViewTouch:self];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end









