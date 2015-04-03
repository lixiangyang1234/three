//
//  EditView.m
//  ThreeMan
//
//  Created by tianj on 15/4/3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "EditView.h"

@implementation EditView


- (id)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kWidth,40);
        self.backgroundColor = HexRGB(0xffffff);
        NSArray *array = [NSArray arrayWithObjects:@"全选",@"删除", nil];
        CGFloat width = kWidth/array.count;
        for (int i = 0 ; i < array.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                [btn setTitleColor:HexRGB(0x323232) forState:UIControlStateNormal];
                [btn setTitle:@"全不选" forState:UIControlStateSelected];
            }else{
                [btn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
            }
            btn.tag = i;
            btn.frame = CGRectMake(width*i, 0, width, 40);
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        self.layer.borderColor = HexRGB(0xd1d1d1).CGColor;
        self.layer.borderWidth = 0.5;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1,self.frame.size.height)];
        line.backgroundColor = HexRGB(0xd1d1d1);
        line.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:line];
    };
    
    return self;
}

- (void)btnDown:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(btnClicked: view:)]) {
        [self.delegate btnClicked:btn view:self];
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
