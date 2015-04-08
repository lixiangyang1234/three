//
//  ImageFieldView.m
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "ImageFieldView.h"

@implementation ImageFieldView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat imgWidth = 23;
        CGFloat imgHeight = 23;
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,imgWidth,imgHeight)];
        self.imgView.center = CGPointMake(imgWidth/2,self.frame.size.height/2);
        [self addSubview:self.imgView];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(imgWidth+5, 0,self.frame.size.width-imgWidth-5,self.frame.size.height)];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.textField];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
