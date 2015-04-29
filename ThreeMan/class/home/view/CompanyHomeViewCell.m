//
//  CompanyHomeViewCell.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CompanyHomeViewCell.h"
#define YYBorderX 10
#define YYBorderY 10
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
        
        companyHomeImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBorderX, YYBorderY, 90, 60)];
        [backCell addSubview:companyHomeImage];
        companyHomeImage.backgroundColor =[UIColor clearColor];
        companyHomeImage.userInteractionEnabled =YES;
        
        companyHomeSmailImage =[[typeView alloc]initWithFrame:CGRectMake(YYBorderX*2+90, YYBorderY, 30, 20)];
        [backCell addSubview:companyHomeSmailImage];
        companyHomeSmailImage.backgroundColor =[UIColor clearColor];
        companyHomeSmailImage.userInteractionEnabled =YES;
        
        
        companyHomeTitle =[[UILabel alloc]initWithFrame:CGRectMake(YYBorderX*2+90, YYBorderY, kWidth-YYBorderX*2-115, 50)];
        companyHomeTitle.backgroundColor =[UIColor clearColor];
        [backCell addSubview:companyHomeTitle];
        
        companyHomeTitle.numberOfLines =2;
        companyHomeTitle.font =[UIFont systemFontOfSize:PxFont(22)];
        
        downLoadBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:downLoadBtn];
        downLoadBtn.frame =CGRectMake(YYBorderX*2+90, YYBorderY*2+35, 100, 20);
        [downLoadBtn setTitle:@"230" forState:UIControlStateNormal];
        downLoadBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        
        [downLoadBtn setImage:[UIImage imageNamed:@"companyDownload_img"] forState:UIControlStateNormal];
        [downLoadBtn setTitleColor:HexRGB(0xa8a8a8) forState:UIControlStateNormal];
        
        zanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:zanBtn];
        zanBtn.frame =CGRectMake(200, YYBorderY*2+35, 100, 20);
        [zanBtn setTitle:@"23" forState:UIControlStateNormal];
        zanBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        zanBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 7, 0, 0);
        [zanBtn setImage:[UIImage imageNamed:@"browser_number_icon"] forState:UIControlStateNormal];
        [zanBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
        
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
