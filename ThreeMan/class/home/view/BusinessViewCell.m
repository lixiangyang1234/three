//
//  BusinessViewCell.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BusinessViewCell.h"

#define YYBorderX 10
#define YYBorderY 10
@implementation BusinessViewCell

@synthesize businessImage,businessNeed,businessTtile,bussinessLabel;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(YYBorderX, YYBorderX, kWidth-YYBorderX*2, 120)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        
        businessImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBorderX, YYBorderY, 60, 60)];
        [backCell addSubview:businessImage];
        businessImage.backgroundColor =[UIColor redColor];
        businessImage.userInteractionEnabled =YES;
        businessImage.layer.cornerRadius =30;
        businessImage.layer.masksToBounds=YES;
        
        
        businessTtile =[[UILabel alloc]initWithFrame:CGRectMake(YYBorderX*2+60, YYBorderY, kWidth-YYBorderX*2-90, 30)];
        businessTtile.backgroundColor =[UIColor clearColor];
        businessTtile.text =@"首行缩进根据用户昵称自动调整 ";
        [backCell addSubview:businessTtile];
        businessTtile.numberOfLines =2;
        businessTtile.font =[UIFont systemFontOfSize:20];
        
        
        businessNeed =[[UILabel alloc]initWithFrame:CGRectMake(YYBorderX*2+60, YYBorderY*2+30, kWidth-YYBorderX*2-90, 20)];
        businessNeed.backgroundColor =[UIColor clearColor];
        businessNeed.text =@"需求 21 ";
        [backCell addSubview:businessNeed];
        businessNeed.font =[UIFont systemFontOfSize:14];
 
        bussinessLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBorderX*2+60, YYBorderY*2+50, kWidth-YYBorderX*2-90, 50)];
        bussinessLabel.backgroundColor =[UIColor clearColor];
        bussinessLabel.text =@"首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整 ";
        [backCell addSubview:bussinessLabel];
        bussinessLabel.numberOfLines =3;
        bussinessLabel.font =[UIFont systemFontOfSize:15];
        

        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
