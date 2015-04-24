//
//  NeedViewCell.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "NeedViewCell.h"
#define YYBorderX    8         //外边界宽
#define YYBorderY    4        //外边界高
#define borderW      5       //内边界
#define imageW       124    //图片宽
#define imageH       70    //图片高
@implementation NeedViewCell

@synthesize needImage,needSmailImage,needTitle,zanBtn,companyName;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(YYBorderX, YYBorderX, kWidth-YYBorderX*2, 80)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        
        //底部线条
        UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(0, backCell.frame.size.height-1, backCell.frame.size.width, 1)];
        [backCell addSubview:topLie];
        topLie.backgroundColor =HexRGB(0xcacaca);
        
        needImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderW, borderW,imageW, imageH)];
        [backCell addSubview:needImage];
        needImage.backgroundColor =[UIColor whiteColor];
        needImage.userInteractionEnabled =YES;
        needImage.image =placeHoderImage3;
       

        
        needTitle =[[UILabel alloc]initWithFrame:CGRectMake(borderW*2+imageW, YYBorderY, kWidth-YYBorderX*2-imageW-borderW*2, 40)];
        needTitle.backgroundColor =[UIColor clearColor];
        [backCell addSubview:needTitle];
        needTitle.textColor =HexRGB(0x323232);
        needTitle.numberOfLines =2;
        needTitle .font =[UIFont systemFontOfSize:PxFont(20)];

        needSmailImage =[[typeView alloc]initWithFrame:CGRectMake(borderW*2+imageW, YYBorderY+borderW, 30, 20)];
        [backCell addSubview:needSmailImage];
        needSmailImage.backgroundColor =[UIColor clearColor];
    

        needSmailImage.userInteractionEnabled =YES;
        companyName =[[UILabel alloc]initWithFrame:CGRectMake(borderW*2+imageW, backCell.frame.size.height-25, 115, 20)];
        companyName.backgroundColor =[UIColor clearColor];
        companyName.text =@"新东方恒仁大学";
        [backCell addSubview:companyName];
        companyName.font =[UIFont systemFontOfSize:12];
        companyName.textColor=HexRGB(0x959595);
    
        zanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:zanBtn];
        zanBtn.frame =CGRectMake(backCell.frame.size.width-60, backCell.frame.size.height-25, 55, 20);
        zanBtn .titleEdgeInsets =UIEdgeInsetsMake(0, 7, 0, 0);
        [zanBtn setImage:[UIImage imageNamed:@"browser_number_icon"] forState:UIControlStateNormal];
        [zanBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
        zanBtn .titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [zanBtn setBackgroundColor:[UIColor clearColor]];
        
                
//        [self resetContent];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
