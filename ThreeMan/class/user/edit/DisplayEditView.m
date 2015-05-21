//
//  DisplayEditView.m
//  ThreeMan
//
//  Created by tianj on 15/5/19.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "DisplayEditView.h"

@implementation DisplayEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width,0,self.frame.size.width-(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width),self.frame.size.height)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = HexRGB(0x999999);
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_contentLabel];
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
