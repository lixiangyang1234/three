//
//  BaseEditView.m
//  ThreeMan
//
//  Created by tianj on 15/5/19.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BaseEditView.h"

@implementation BaseEditView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13,0,80,self.frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = HexRGB(0x323232);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLabel];
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
