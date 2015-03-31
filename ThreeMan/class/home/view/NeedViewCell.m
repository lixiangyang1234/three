//
//  NeedViewCell.m
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "NeedViewCell.h"

#define YYBorderX 10
#define YYBorderY 10
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
        
        needImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBorderX, YYBorderY, 80, 60)];
        [backCell addSubview:needImage];
        needImage.backgroundColor =[UIColor redColor];
        needImage.userInteractionEnabled =YES;
        
        needSmailImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBorderX*2+80, YYBorderY, 30, 20)];
        [backCell addSubview:needSmailImage];
        needSmailImage.backgroundColor =[UIColor redColor];
        needSmailImage.userInteractionEnabled =YES;

        
        needTitle =[[UILabel alloc]initWithFrame:CGRectMake(YYBorderX*2+80, YYBorderY, kWidth-YYBorderX*2-110, 50)];
        needTitle.backgroundColor =[UIColor clearColor];
        needTitle.text =@"首行缩进根据用户昵称自动调整 ";
        [backCell addSubview:needTitle];
//        [needTitle sizeToFit];
        self . needTitle . adjustsFontSizeToFitWidth  =  YES ;
        
//        self . needTitle . adjustsLetterSpacingToFitWidth  =  YES ;
        
        
        needTitle.numberOfLines =2;
        needTitle.font =[UIFont systemFontOfSize:20];
        
        UILabel*  needRed =[[UILabel alloc]initWithFrame:CGRectMake(YYBorderX*2+80, YYBorderY*2+30, 50, 30)];
        needRed.backgroundColor =[UIColor clearColor];
        needRed.text =@"浏览量";
        [backCell addSubview:needRed];
        needRed.font =[UIFont systemFontOfSize:12];
        
    
        zanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:zanBtn];
        zanBtn.frame =CGRectMake(200, YYBorderY*2+30, 70, 20);
        [zanBtn setTitle:@"23" forState:UIControlStateNormal];

        [zanBtn setImage:[UIImage imageNamed:@"nav_return_pre"] forState:UIControlStateNormal];
        [zanBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        
                
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
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
