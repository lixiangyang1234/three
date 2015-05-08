//
//  BusinessViewCell.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BusinessViewCell.h"

#define YYBorderX 8
#define borderH 10
#define borderW 12
#define between 25
@implementation BusinessViewCell

@synthesize businessImage,businessNeed,businessTtile,bussinessLabel,backCell;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        backCell =[[UIView alloc]initWithFrame:CGRectMake(YYBorderX, 0, kWidth-YYBorderX*2, 99.75)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        
        businessImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderW, borderH+10, 40, 40)];
        [backCell addSubview:businessImage];
        businessImage.backgroundColor =[UIColor clearColor];
        businessImage.userInteractionEnabled =YES;
        businessImage.layer.cornerRadius =20;
        businessImage.layer.masksToBounds=YES;
        businessImage.layer.borderWidth=1.0f;
        businessImage.layer.borderColor =HexRGB(0xdde5eb) .CGColor;
        CGFloat imageW =businessImage.frame.origin.x+businessImage.frame.size.width;
        
        businessTtile =[[UILabel alloc]initWithFrame:CGRectMake(imageW+between, 2, kWidth-imageW-between-borderW*3 , 30)];
        businessTtile.backgroundColor =[UIColor clearColor];
        [backCell addSubview:businessTtile];
        businessTtile.numberOfLines =2;
        businessTtile.font =[UIFont systemFontOfSize:PxFont(18)];
        businessTtile.textColor =HexRGB(0x323232);
        
        CGFloat titleH =businessTtile.frame.origin.y+businessTtile.frame.size.height-3;
        businessNeed =[[UILabel alloc]initWithFrame:CGRectMake(imageW+between, titleH, kWidth-imageW-between-borderW*3, 20)];
        businessNeed.backgroundColor =[UIColor clearColor];
        businessNeed.text =@"需求 21 ";
        [backCell addSubview:businessNeed];
        businessNeed.font =[UIFont systemFontOfSize:PxFont(14)];
        businessNeed.textColor =HexRGB(0x959595);
        CGFloat needH =businessNeed.frame.origin.y+businessNeed.frame.size.height-3;

        bussinessLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+between, needH,kWidth-imageW-between-borderW*3 , 50)];
        bussinessLabel.backgroundColor =[UIColor clearColor];
        bussinessLabel.text =@"首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整 ";
        [backCell addSubview:bussinessLabel];
        bussinessLabel.numberOfLines =3;
        bussinessLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        bussinessLabel.textColor =HexRGB(0x1c8cc6);

        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
