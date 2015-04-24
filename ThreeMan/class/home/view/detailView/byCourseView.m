//
//  byCourseView.m
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "byCourseView.h"
#import "YYSearchButton.h"
#define BACKVIEWw 235
@implementation byCourseView
-(id)initWithFrame:(CGRect)frame byTitle:(NSString *)title contentLabel:(NSString *)content buttonTitle:(NSArray *)butTitle TagType:(int)type{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        UIView *backView =[[UIView alloc]initWithFrame:CGRectMake((kWidth-BACKVIEWw)/2, kHeight-310, BACKVIEWw, 140)];
        [self addSubview:backView];
        backView.backgroundColor =[UIColor whiteColor];
        backView.layer.cornerRadius =4;
        backView.layer.masksToBounds=YES;
        backView.layer.borderColor =HexRGB(0xcacaca).CGColor;
        backView.layer.borderWidth =1.0f;
        
        UILabel *byCourseTitle =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, BACKVIEWw, 35)];
        byCourseTitle.backgroundColor =[UIColor clearColor];
        byCourseTitle.text =title;
        [backView addSubview:byCourseTitle];
        byCourseTitle.font =[UIFont systemFontOfSize:PxFont(18)];
        byCourseTitle.textColor =HexRGB(0x646464);
        byCourseTitle.textAlignment =NSTextAlignmentCenter;

        UIView *line =[[UIView alloc]initWithFrame:CGRectMake((BACKVIEWw-215)/2, 38, 215, 1)];
        [backView addSubview:line];
        line.backgroundColor =HexRGB(0xcacaca);
        
       UILabel* contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 45, BACKVIEWw-20, 40)];
        contentLabel.backgroundColor =[UIColor clearColor];
        contentLabel.text =content;
        [backView addSubview:contentLabel];
        contentLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        contentLabel.textColor =HexRGB(0x646464);
        contentLabel.textAlignment =NSTextAlignmentCenter;
        contentLabel.numberOfLines =2;


        for (int i=0; i<2; i++) {
            UIButton *chooseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:chooseBtn];
            chooseBtn.frame =CGRectMake((backView.frame.size.width-180)/2+i%2*100, backView.frame.size.height-43, 80, 30);
            [chooseBtn setTitle:butTitle[i] forState:UIControlStateNormal];
            if (i==0) {
                chooseBtn.backgroundColor =HexRGB(0xf2f2f2);
                [chooseBtn setTitleColor:HexRGB(0x646464) forState:UIControlStateNormal];
            }else{
                [chooseBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
                chooseBtn.backgroundColor =HexRGB(0x178ac5);
            }
            chooseBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
            chooseBtn.layer.cornerRadius =6;
            chooseBtn.layer.masksToBounds = YES;
            chooseBtn.layer.borderWidth =1.0f;
            chooseBtn.layer.borderColor=HexRGB(0xcacaca).CGColor;
            
            
            [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:PxFont(20)]];
            [chooseBtn addTarget:self action:@selector(chooseBtnClickDele:) forControlEvents:UIControlEventTouchUpInside];
            if (type ==333) {
                chooseBtn.tag =333+i;

            }if (type==444) {
                chooseBtn.tag =444+i;
            }if (type==555) {
                chooseBtn.tag =555+i;
            }if (type==666) {
                chooseBtn.tag =666+i;
            }
        }
        
 
    }
    return self;
}


-(void)chooseBtnClickDele:(UIButton *)choose{
    
//    NSLog(@"   ddddddd%d",choose.tag);
    if ([self.delegate respondsToSelector:@selector(chooseBtn:chooseTag:)]) {
        [self.delegate chooseBtn:choose chooseTag:choose.tag];
    }
}
@end
