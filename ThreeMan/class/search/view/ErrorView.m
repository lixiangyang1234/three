//
//  ErrorView.m
//  ThreeMan
//
//  Created by tianj on 15/4/17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "ErrorView.h"
#import "AdaptationSize.h"

@implementation ErrorView

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title
{
    if (self = [super init]) {
        UIImage *img = [UIImage imageNamed:image];
        self.imageView = [[UIImageView alloc] initWithImage:img];
        self.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [self addSubview:self.imageView];
        
        CGSize size = [AdaptationSize getSizeFromString:title Font:[UIFont systemFontOfSize:15] withHight:CGFLOAT_MAX withWidth:self.imageView.frame.size.width];
        
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.frame.size.height, self.imageView.frame.size.width,size.height)];
        self.errorLabel.backgroundColor = [UIColor clearColor];
        self.errorLabel.numberOfLines = 0;
        self.errorLabel.text = title;
        self.errorLabel.textAlignment = NSTextAlignmentCenter;
        self.errorLabel.font = [UIFont systemFontOfSize:15];
        self.errorLabel.textColor = HexRGB(0x646464);
        [self addSubview:self.errorLabel];
        
        self.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.errorLabel.frame.origin.y+self.errorLabel.frame.size.height);
        
    }
    return self;
}

@end
