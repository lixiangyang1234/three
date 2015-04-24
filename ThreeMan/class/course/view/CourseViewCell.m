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
        
        
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(borderwh, borderwh, kWidth-borderwh*2, 58)];
        
        //        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(borderwh, 4, kWidth-borderwh*2, 80)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        //底部线条
        UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(0, backCell.frame.size.height-1, backCell.frame.size.width, 1)];
        [backCell addSubview:topLie];
        topLie.backgroundColor =HexRGB(0xcacaca);
        
        headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, borderwh, 38, 38)];
        [backCell addSubview:headerImage];
        headerImage.backgroundColor =[UIColor redColor];
        headerImage.userInteractionEnabled =YES;
        headerImage.layer.cornerRadius =19;
        headerImage.layer.masksToBounds=YES;
        headerImage.layer.borderWidth=1.0f;
        headerImage.layer.borderColor =HexRGB(0xdde5eb) .CGColor;
        CGFloat imageW =headerImage.frame.origin.x+headerImage.frame.size.width;
        
        titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, 2, kWidth-imageW-borderwh*3 , 30)];
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.text =@"首行缩进根据用户昵称自动调整 ";
        [backCell addSubview:titleLabel];
        titleLabel.numberOfLines =2;
        titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        titleLabel.textColor =HexRGB(0x323232);
        
        CGFloat titleH =titleLabel.frame.origin.y+titleLabel.frame.size.height;
        contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, titleH, kWidth-imageW-borderwh*3, 20)];
        contentLabel.backgroundColor =[UIColor clearColor];
        contentLabel.text =@"需求 首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整21 ";
        [backCell addSubview:contentLabel];
        contentLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        contentLabel.textColor =HexRGB(0x737373);
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
