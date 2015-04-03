//
//  AccountHeadView.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "AccountHeadView.h"
#import "AdaptationSize.h"

#define TITLE_FONT [UIFont systemFontOfSize:16]

@implementation AccountHeadView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, frame.size.width-8*2, frame.size.height-8*2)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        self.backgroundColor = HexRGB(0xe8e8e8);
        
        
        NSString *str = @"当前蜕变豆余额:";
        CGSize size = [AdaptationSize getSizeFromString:str Font:TITLE_FONT withHight:20 withWidth:CGFLOAT_MAX];
        self.titlaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,size.width,20)];
        self.titlaLabel.backgroundColor = [UIColor clearColor];
        self.titlaLabel.font = TITLE_FONT;
        self.titlaLabel.text = str;
        self.titlaLabel.textColor = HexRGB(0x323232);
        self.titlaLabel.center = CGPointMake(12+size.width/2, bgView.frame.size.height/2);
        [bgView addSubview:self.titlaLabel];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,120,20)];
        self.amountLabel.center = CGPointMake(self.titlaLabel.frame.origin.x+self.titlaLabel.frame.size.width+self.amountLabel.frame.size.width/2+5, bgView.frame.size.height/2);
        self.amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.textColor = HexRGB(0x1c8cc6);
        self.amountLabel.font = TITLE_FONT;
        [bgView addSubview:self.amountLabel];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0, 0, 70, 35);
        [self.btn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn.center = CGPointMake(bgView.frame.size.width-12-self.btn.frame.size.width/2, bgView.frame.size.height/2);
        [bgView addSubview:self.btn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height-1,bgView.frame.size.width, 1)];
        line.backgroundColor = HexRGB(0xcacaca);
        [bgView addSubview:line];
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
