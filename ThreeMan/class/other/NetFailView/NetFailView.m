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
-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
     UIImageView *   netFailImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-NETFAILIMGWH)/2, (kHeight-NETFAILIMGWH)/2-64, NETFAILIMGWH, NETFAILIMGWH)];
        [self addSubview:netFailImg];
        netFailImg.backgroundColor =[UIColor clearColor];
        netFailImg.image =[UIImage imageNamed:@"netFailImg_1"];
        
        UILabel *netFailLabel =[[UILabel alloc]initWithFrame:CGRectMake((kWidth-130)/2, (kHeight-NETFAILIMGWH)/2+NETFAILIMGWH-84, 130, 40)];
        netFailLabel.backgroundColor =[UIColor clearColor];
        netFailLabel.text =@"对不起，网络不给力!请检查您的网络设置! ";
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
