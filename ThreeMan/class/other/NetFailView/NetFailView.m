//
//  NetFailView.m
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "NetFailView.h"
#define NETFAILIMGWH   165
@implementation NetFailView
-(id)initWithFrame:(CGRect)frame backImage:(UIImage *)img promptTitle:(NSString *)title{
    self =[super initWithFrame:frame];
    if (self) {
     UIImageView *   netFailImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-NETFAILIMGWH)/2, (kHeight-NETFAILIMGWH)/2-64, NETFAILIMGWH, NETFAILIMGWH)];
        [self addSubview:netFailImg];
        netFailImg.backgroundColor =[UIColor clearColor];
        netFailImg.image =img;
        
        UILabel *netFailLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-NETFAILIMGWH)/2, (kHeight-NETFAILIMGWH)/2+NETFAILIMGWH-84, NETFAILIMGWH, 40)];
        netFailLabel.backgroundColor =[UIColor clearColor];
        netFailLabel.text =title;
        [self addSubview:netFailLabel];
        netFailLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        netFailLabel.textColor =HexRGB(0x646464);
        netFailLabel.textAlignment =NSTextAlignmentCenter;
        netFailLabel.numberOfLines =2;


    }
    return self;
}
-(id)initWithFrameForDetail:(CGRect)frame backImage:(UIImage *)img promptTitle:(NSString *)title{
    self =[super initWithFrame:frame];
    if (self) {
        UIImageView *   netFailImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-NETFAILIMGWH)/2, kHeight-280-40, NETFAILIMGWH, NETFAILIMGWH)];
        [self addSubview:netFailImg];
        netFailImg.backgroundColor =[UIColor clearColor];
        netFailImg.image =img;
        
        UILabel *netFailLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-NETFAILIMGWH)/2, kHeight-170, NETFAILIMGWH, 40)];
        netFailLabel.backgroundColor =[UIColor clearColor];
        netFailLabel.text =title;
        [self addSubview:netFailLabel];
        netFailLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        netFailLabel.textColor =HexRGB(0x646464);
        netFailLabel.textAlignment =NSTextAlignmentCenter;
        netFailLabel.numberOfLines =2;
        
        
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
