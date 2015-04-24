//
//  CourseRecommendViewCell.m
//  ThreeMan
//
//  Created by YY on 15-4-3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseRecommendViewCell.h"
#define borderwh 11
#define YYBORDERWH        16  //外边界

@implementation CourseRecommendViewCell
@synthesize headerRecommendImage,nameRecomendLabel,timeRecomendLabel,contentRecomendLabel;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(YYBORDERWH, 0, self.frame.size.width-YYBORDERWH, 110)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        UIView *backLineCell =[[UIView alloc]initWithFrame:CGRectMake(YYBORDERWH, backCell.frame.size.height-1, self.frame.size.width-YYBORDERWH, 1)];
        [self addSubview:backLineCell];
        backLineCell.backgroundColor =HexRGB(0xcacaca);
        
        headerRecommendImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, borderwh-5, 40, 40)];
        [backCell addSubview:headerRecommendImage];
        headerRecommendImage.backgroundColor =[UIColor redColor];
        headerRecommendImage.userInteractionEnabled =YES;
        headerRecommendImage.layer.cornerRadius =20;
        headerRecommendImage.layer.masksToBounds=YES;
        headerRecommendImage.layer.borderWidth=1.0f;
        headerRecommendImage.layer.borderColor =HexRGB(0x959595) .CGColor;
        CGFloat imageW =headerRecommendImage.frame.origin.x+headerRecommendImage.frame.size.width;
        
        nameRecomendLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, borderwh, 140 , 40)];
        nameRecomendLabel.backgroundColor =[UIColor clearColor];
        nameRecomendLabel.text =@"大头儿子";
        [backCell addSubview:nameRecomendLabel];
        nameRecomendLabel.numberOfLines =2;
        nameRecomendLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        nameRecomendLabel.textColor =HexRGB(0x323232);
        
        timeRecomendLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-100, borderwh, 80, 40)];
        timeRecomendLabel.backgroundColor =[UIColor clearColor];
        timeRecomendLabel.text =@"2015-03-04";
        [backCell addSubview:timeRecomendLabel];
        timeRecomendLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        timeRecomendLabel.textColor =HexRGB(0xa8a8a8);
        CGFloat needH =timeRecomendLabel.frame.origin.y+timeRecomendLabel.frame.size.height;
        
        contentRecomendLabel =[[UILabel alloc]initWithFrame:CGRectMake(borderwh, needH,self.frame.size.width-borderwh*3 , 50)];
        contentRecomendLabel.backgroundColor =[UIColor clearColor];
        contentRecomendLabel.text =@"首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整 ";
        [backCell addSubview:contentRecomendLabel];
        contentRecomendLabel.numberOfLines =3;
        contentRecomendLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        contentRecomendLabel.textColor =HexRGB(0x655555);
        
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
