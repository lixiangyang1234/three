//
//  SectionHeadView.m
//  ThreeMan
//
//  Created by tianj on 15/4/3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "SectionHeadView.h"

@implementation SectionHeadView

#define titleFont [UIFont systemFontOfSize:14]

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat topDis = 8;
        CGFloat leftDis = 8;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftDis,topDis, frame.size.width-leftDis*2,33)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12,(bgView.frame.size.height-19)/2, 25,19)];
        [bgView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.frame.origin.x+_imgView.frame.size.width+10, 0,80,bgView.frame.size.height)];
        _titleLabel.font = titleFont;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = HexRGB(0x7a7a7a);
        [bgView addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setImgView:(UIImage *)image title:(NSString *)title
{
    self.imgView.image = image;
    self.titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
