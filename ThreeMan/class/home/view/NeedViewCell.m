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

@synthesize needImage,needSmailImage,needTitle,zanBtn;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(YYBorderX, YYBorderX, kWidth-YYBorderX*2, 80)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        
        needImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderW, borderW,imageW, imageH)];
        [backCell addSubview:needImage];
        needImage.backgroundColor =[UIColor redColor];
        needImage.userInteractionEnabled =YES;
        
        needSmailImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderW*2+imageW, YYBorderY+borderW, 30, 20)];
        [backCell addSubview:needSmailImage];
        needSmailImage.backgroundColor =[UIColor redColor];
        needSmailImage.userInteractionEnabled =YES;

        
        needTitle =[[UILabel alloc]initWithFrame:CGRectMake(borderW*2+imageW, YYBorderY, kWidth-YYBorderX*2-imageW-borderW*2, 50)];
        needTitle.backgroundColor =[UIColor clearColor];
        needTitle.text =@"首行缩进根据用户昵称自动调整 ";
        [backCell addSubview:needTitle];
//        [needTitle sizeToFit];
        needTitle.textColor =HexRGB(0x323232);
        self . needTitle . adjustsFontSizeToFitWidth  =  YES ;
        
//        self . needTitle . adjustsLetterSpacingToFitWidth  =  YES ;
        
        
        needTitle.numberOfLines =2;
        needTitle.font =[UIFont systemFontOfSize:20];
        
        UILabel*  needRed =[[UILabel alloc]initWithFrame:CGRectMake(borderW*2+imageW, borderW+needTitle.frame.size.height, 60, 20)];
        needRed.backgroundColor =[UIColor redColor];
        needRed.text =@"新东方恒仁大学";
        [backCell addSubview:needRed];
        needRed.font =[UIFont systemFontOfSize:12];
        needRed.textColor=HexRGB(0x959595);
    
        zanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:zanBtn];
        zanBtn.frame =CGRectMake(backCell.frame.size.width-80, borderW+needTitle.frame.size.height, 70, 20);
        [zanBtn setTitle:@"23" forState:UIControlStateNormal];

        [zanBtn setImage:[UIImage imageNamed:@"nav_return_pre"] forState:UIControlStateNormal];
        [zanBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [zanBtn setBackgroundColor:[UIColor redColor]];
        
                
        [self resetContent];
        
    }
    return self;
}
- ( void )resetContent{
    
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString : self . needTitle . text ];
    
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    
    paragraphStyle. alignment = NSTextAlignmentLeft ;
    
    
//    paragraphStyle. maximumLineHeight = 40 ;  //最大的行高
    
    paragraphStyle. lineSpacing = 3 ;  //行自定义行高度
    
    [paragraphStyle setFirstLineHeadIndent :30 + 5 ]; //首行缩进 根据用户昵称宽度在加5个像素
    
    [attributedString addAttribute : NSParagraphStyleAttributeName value :paragraphStyle range : NSMakeRange ( 0 , [ self . needTitle . text length ])];
    
    self . needTitle . attributedText = attributedString;
    
    [ self . needTitle sizeToFit ];
    needTitle.font =[UIFont systemFontOfSize:PxFont(23)];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
