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
@synthesize headerRecommendImage,nameRecomendLabel,timeRecomendLabel,contentRecomendLabel,backCell,backLineCell;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        backCell =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-borderwh*2, 74)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
         backLineCell =[[UIView alloc]initWithFrame:CGRectMake(0, backCell.frame.size.height-1, kWidth-borderwh, 1)];
        [backCell addSubview:backLineCell];
        backLineCell.backgroundColor =HexRGB(0xcacaca);
        headerRecommendImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, borderwh-5, 40, 40)];
        [backCell addSubview:headerRecommendImage];
        headerRecommendImage.backgroundColor =[UIColor clearColor];
        headerRecommendImage.userInteractionEnabled =YES;
        headerRecommendImage.layer.cornerRadius =20;
        headerRecommendImage.layer.masksToBounds=YES;
        headerRecommendImage.layer.borderWidth=1.0f;
        headerRecommendImage.layer.borderColor =HexRGB(0x959595) .CGColor;
        CGFloat imageW =headerRecommendImage.frame.origin.x+headerRecommendImage.frame.size.width;
        
        nameRecomendLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, borderwh, 155 , 40)];
        nameRecomendLabel.backgroundColor =[UIColor clearColor];
        nameRecomendLabel.text =@"大头儿子";
        [backCell addSubview:nameRecomendLabel];
        nameRecomendLabel.numberOfLines =2;
        nameRecomendLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        nameRecomendLabel.textColor =HexRGB(0x323232);
        
        timeRecomendLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-90, 3, 70, 40)];
        timeRecomendLabel.backgroundColor =[UIColor clearColor];
        timeRecomendLabel.text =@"2015-03-04";
        [backCell addSubview:timeRecomendLabel];
        timeRecomendLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        timeRecomendLabel.textColor =HexRGB(0xa8a8a8);
        CGFloat needH =timeRecomendLabel.frame.origin.y+timeRecomendLabel.frame.size.height;
        
        contentRecomendLabel =[[UILabel alloc]initWithFrame:CGRectMake(borderwh, needH,self.frame.size.width-borderwh*3 , 50)];
        contentRecomendLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:contentRecomendLabel];
        contentRecomendLabel.numberOfLines =3;
        contentRecomendLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        contentRecomendLabel.textColor =HexRGB(0x655555);
        
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
