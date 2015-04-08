//
//  CustomBtn.m
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CustomBtn.h"

#define kTitleRatio 0.6

@implementation CustomBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        // 2.文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
        // 3.图片的内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        
    }
    return self;
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.height;
    CGFloat imageHeight = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = contentRect.size.height;
    CGFloat titleY = 0;
    CGFloat titleWidth = contentRect.size.width-contentRect.size.height;
    CGFloat titleHeight = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}


@end
