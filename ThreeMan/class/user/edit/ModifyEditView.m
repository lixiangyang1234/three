//
//  ModifyEditView.m
//  ThreeMan
//
//  Created by tianj on 15/5/19.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "ModifyEditView.h"

@implementation ModifyEditView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width,0,self.frame.size.width-(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width),self.frame.size.height)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = HexRGB(0x323232);
        _textField.font = [UIFont systemFontOfSize:16];
        [self addSubview:_textField];
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
