//
//  YYSearchButton.m
//  PEM
//
//  Created by YY on 14-11-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "YYSearchButton.h"

@implementation YYSearchButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setIsSelected:NO];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        [self setBorderColor:HexRGB(0x178ac5) TextColor:HexRGB(0x178ac5)];
    }else{
        [self setBorderColor:HexRGB(0x959595) TextColor:HexRGB(0x959595)];
    }
}

- (void)setBorderColor:(UIColor *)borderColor TextColor:(UIColor *)textColor{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius=8;
    self.layer.masksToBounds=YES;

    [self setTitleColor:textColor forState:UIControlStateNormal];
}

@end
