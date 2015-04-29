//
//  CourseViewCell.m
//  ThreeMan
//
//  Created by YY on 15-4-1.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseViewCell.h"
#define borderwh 8
@implementation CourseViewCell
@synthesize headerImage,titleLabel,contentLabel;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(borderwh, 0, kWidth-borderwh*2, 58)];
        
        //        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(borderwh, 4, kWidth-borderwh*2, 80)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        //底部线条
        UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(0, backCell.frame.size.height-0.5, backCell.frame.size.width, 0.5)];
        [backCell addSubview:topLie];
        topLie.backgroundColor =HexRGB(0xcacaca);
        
        headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, borderwh, 44, 44)];
        [backCell addSubview:headerImage];
        headerImage.backgroundColor =[UIColor clearColor];
        headerImage.userInteractionEnabled =YES;
        headerImage.layer.cornerRadius =22;
        headerImage.layer.masksToBounds=YES;
        headerImage.layer.borderWidth=1.0f;
        headerImage.layer.borderColor =HexRGB(0xdde5eb) .CGColor;
        CGFloat imageW =headerImage.frame.origin.x+headerImage.frame.size.width;
        
        titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, 5, kWidth-imageW-borderwh*3 , 30)];
        titleLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:titleLabel];
        titleLabel.numberOfLines =2;
        titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        titleLabel.textColor =HexRGB(0x323232);
        
        CGFloat titleH =titleLabel.frame.origin.y+titleLabel.frame.size.height-4;
        contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh+3, titleH, kWidth-imageW-borderwh*3, 20)];
        contentLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:contentLabel];
        contentLabel.font =[UIFont systemFontOfSize:PxFont(12)];
        contentLabel.textColor =HexRGB(0x737373);
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
