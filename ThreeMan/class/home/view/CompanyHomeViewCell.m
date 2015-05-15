//
//  CompanyHomeViewCell.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompanyHomeViewCell.h"
#define YYBorderX 8
#define boreder 5
@implementation CompanyHomeViewCell



@synthesize companyHomeImage,companyHomeSmailImage,companyHomeTitle,downLoadBtn,zanBtn;
- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(YYBorderX, 8, kWidth-YYBorderX*2, 80)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        //底部线条
        UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(0, backCell.frame.size.height-0.5, backCell.frame.size.width, 0.5)];
        [backCell addSubview:topLie];
        topLie.backgroundColor =HexRGB(0xcacaca);
        
        companyHomeImage =[[UIImageView alloc]initWithFrame:CGRectMake(boreder, boreder, 123, 70)];
        [backCell addSubview:companyHomeImage];
        companyHomeImage.backgroundColor =[UIColor clearColor];
        companyHomeImage.userInteractionEnabled =YES;
        CGFloat companyHomeImgW =companyHomeImage.frame.size.width+companyHomeImage.frame.origin.x;
        
        companyHomeSmailImage =[[typeView alloc]initWithFrame:CGRectMake(boreder+companyHomeImgW, boreder*2, 27, 15)];
        [backCell addSubview:companyHomeSmailImage];
        companyHomeSmailImage.backgroundColor =[UIColor clearColor];
        companyHomeSmailImage.userInteractionEnabled =YES;
        
        
        companyHomeTitle =[[UILabel alloc]initWithFrame:CGRectMake(boreder+companyHomeImgW, boreder, kWidth-boreder*2-125, 50)];
        companyHomeTitle.backgroundColor =[UIColor clearColor];
        [backCell addSubview:companyHomeTitle];
        companyHomeTitle.numberOfLines =2;
        companyHomeTitle.font =[UIFont systemFontOfSize:PxFont(18)];

        
        downLoadBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:downLoadBtn];
        downLoadBtn.frame =CGRectMake(boreder+companyHomeImgW, backCell.frame.size.height-YYBorderX-20, 80, 20);
        [downLoadBtn setTitle:@"230" forState:UIControlStateNormal];
        downLoadBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [downLoadBtn setImage:[UIImage imageNamed:@"companyDownload_img"] forState:UIControlStateNormal];
        [downLoadBtn setTitleColor:HexRGB(0xa8a8a8) forState:UIControlStateNormal];
        downLoadBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        downLoadBtn.backgroundColor =[UIColor clearColor];

        CGFloat downW =downLoadBtn.frame.size.width+downLoadBtn.frame.origin.x;
        zanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:zanBtn];
        zanBtn.frame =CGRectMake(boreder+downW, backCell.frame.size.height-YYBorderX-20, 80, 20);
        [zanBtn setTitle:@"23" forState:UIControlStateNormal];
        zanBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        zanBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 7, 0, 0);
        [zanBtn setImage:[UIImage imageNamed:@"browser_number_icon"] forState:UIControlStateNormal];
        [zanBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
        zanBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        zanBtn.backgroundColor =[UIColor clearColor];
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
