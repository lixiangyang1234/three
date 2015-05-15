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
        
        backCell =[[UIView alloc]init];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        
        backLineCell =[[UIView alloc]init];
        backLineCell.backgroundColor =HexRGB(0xcacaca);
        [backCell addSubview:backLineCell];

        
        headerRecommendImage =[[UIImageView alloc]init];
        [backCell addSubview:headerRecommendImage];
        headerRecommendImage.backgroundColor =[UIColor clearColor];
        headerRecommendImage.userInteractionEnabled =YES;
        headerRecommendImage.layer.cornerRadius =20;
        headerRecommendImage.layer.masksToBounds=YES;
        headerRecommendImage.layer.borderWidth=1.0f;
        headerRecommendImage.layer.borderColor =HexRGB(0x959595) .CGColor;
        
        nameRecomendLabel =[[UILabel alloc]init];
        nameRecomendLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:nameRecomendLabel];
        nameRecomendLabel.numberOfLines =2;
        nameRecomendLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        nameRecomendLabel.textColor =HexRGB(0x323232);
        
        timeRecomendLabel =[[UILabel alloc]init];
        timeRecomendLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:timeRecomendLabel];
        timeRecomendLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        timeRecomendLabel.textColor =HexRGB(0xa8a8a8);
        
        contentRecomendLabel =[[UILabel alloc]init];
        contentRecomendLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:contentRecomendLabel];
        contentRecomendLabel.numberOfLines =0;
        contentRecomendLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        contentRecomendLabel.textColor =HexRGB(0x655555);
        
        
        
    }
    return self;
}
-(void)setObjectRecommendItem:(courseDetailModel *)item{
    CGSize recommendSize =[AdaptationSize getSizeFromString:item.recommendContent Font:[UIFont systemFontOfSize:PxFont(16)] withHight:CGFLOAT_MAX withWidth:kWidth-borderwh*3];
    CGSize nameRecommendSize =[AdaptationSize getSizeFromString:item.recommendUseame Font:[UIFont systemFontOfSize:PxFont(18)] withHight:CGFLOAT_MAX withWidth:kWidth-YYBORDERWH*2-130];

    backCell.frame =CGRectMake(YYBORDERWH, 0, kWidth-YYBORDERWH, recommendSize.height+47+nameRecommendSize.height);
    backLineCell.frame=CGRectMake(0, backCell.frame.size.height-1, kWidth-borderwh, 1);
    
    headerRecommendImage.frame =CGRectMake(borderwh, borderwh-5, 40, 40);
    headerRecommendImage.backgroundColor =[UIColor redColor];
    [headerRecommendImage setImageWithURL:[NSURL URLWithString:item.recommendImg] placeholderImage:placeHoderImage1];
    
    CGFloat imageW =headerRecommendImage.frame.origin.x+headerRecommendImage.frame.size.width;
    
    nameRecomendLabel.frame =CGRectMake(imageW+borderwh, borderwh, backCell.frame.size.width-YYBORDERWH-130, nameRecommendSize.height);
    nameRecomendLabel.text =item.recommendUseame;
    
    timeRecomendLabel.frame =CGRectMake(self.frame.size.width-90, borderwh+3, 70, 20);
    timeRecomendLabel.text =item.recommednAddtime;
    CGFloat needH =backCell. frame.size.height-recommendSize.height-8;

    contentRecomendLabel.frame =CGRectMake(borderwh, needH,self.frame.size.width-borderwh*3 , recommendSize.height);
    contentRecomendLabel.text =item.recommendContent;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
