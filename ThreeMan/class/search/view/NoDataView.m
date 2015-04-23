//
//  NoDataView.m
//  ThreeMan
//
//  Created by tianj on 15/4/20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView


- (instancetype)initWithImage:(NSString *)image title:(NSString *)title btnTitle:(NSString *)btnTitle
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
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn setTitle:btnTitle forState:UIControlStateNormal];
        self.btn.frame = CGRectMake(0, 0, img.size.width-40, 35);
        [self.btn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        self.btn.center = CGPointMake(img.size.width/2, self.errorLabel.frame.origin.y+self.errorLabel.frame.size.height+self.btn.frame.size.height/2+5);
        [self.btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        
        self.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.btn.frame.origin.y+self.btn.frame.size.height);

    }
    return self;
}

- (void)btnDown:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(viewClicked:view:)]) {
        [self.delegate viewClicked:btn view:self];
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
