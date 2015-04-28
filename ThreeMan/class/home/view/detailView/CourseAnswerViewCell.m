//
//  CourseAnswerViewCell.m
//  ThreeMan
//
//  Created by YY on 15-4-3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseAnswerViewCell.h"
#define YYBORDERWH   16
#define borderwh    11
@implementation CourseAnswerViewCell
@synthesize answerImage,answerTitle,timeAnswerLabel,companyAnswerImage,contentAnswerLabel,nameAnswerLabel,backLineCell,backCell;
- (void)awakeFromNib {
    // Initialization code   what_img
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        backCell =[[UIView alloc]initWithFrame:CGRectMake(borderwh, 0, kWidth-borderwh, 100)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        backLineCell =[[UIView alloc]initWithFrame:CGRectMake(0, backCell.frame.size.height-1, kWidth-borderwh, 1)];
        [backCell addSubview:backLineCell];
        backLineCell.backgroundColor =HexRGB(0xcacaca);
        answerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, borderwh, 24, 21)];
        [backCell addSubview:answerImage];
        answerImage.backgroundColor =[UIColor clearColor];
        answerImage.userInteractionEnabled =YES;
        answerImage.image =[UIImage imageNamed:@"what_img"];
        
        
        CGFloat imageW =answerImage.frame.origin.x+answerImage.frame.size.width;
        
        answerTitle =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, borderwh-4, self.frame.size.width-borderwh*3 , 30)];
        answerTitle.backgroundColor =[UIColor clearColor];
        [backCell addSubview:answerTitle];
        answerTitle.font =[UIFont systemFontOfSize:PxFont(18)];
        answerTitle.textColor =HexRGB(0x323232);
        CGFloat titleH =answerTitle.frame.size.height+answerTitle.frame.origin.y;
        
        contentAnswerLabel =[[UILabel alloc]initWithFrame:CGRectMake(borderwh, titleH,self.frame.size.width-borderwh*3 , 50)];
        contentAnswerLabel.backgroundColor =[UIColor clearColor];
       
        [backCell addSubview:contentAnswerLabel];
        contentAnswerLabel.numberOfLines =0;
        contentAnswerLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        contentAnswerLabel.textColor =HexRGB(0x655555);
        CGFloat contentH =contentAnswerLabel.frame.size.height+contentAnswerLabel.frame.origin.y;
        
        companyAnswerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, contentH, 26, 26)];
        [backCell addSubview:companyAnswerImage];
        companyAnswerImage.backgroundColor =[UIColor clearColor];
        companyAnswerImage.userInteractionEnabled =YES;
        companyAnswerImage.layer.cornerRadius =13;
        companyAnswerImage.layer.masksToBounds=YES;
        companyAnswerImage.layer.borderWidth=1.0f;
        companyAnswerImage.layer.borderColor =HexRGB(0xdde5eb) .CGColor;
        

        nameAnswerLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, contentH, 165 , 30)];
        nameAnswerLabel.backgroundColor =[UIColor clearColor];
        nameAnswerLabel.text =@"大头儿子";
        [backCell addSubview:nameAnswerLabel];
        nameAnswerLabel.numberOfLines =2;
        nameAnswerLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        nameAnswerLabel.textColor =HexRGB(0xa3a3a3);
        
        timeAnswerLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-90, contentH, 70, 30)];
        timeAnswerLabel.backgroundColor =[UIColor clearColor];
        timeAnswerLabel.text =@"2015-03-04";
        [backCell addSubview:timeAnswerLabel];
        timeAnswerLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        timeAnswerLabel.textColor =HexRGB(0xa3a3a3);

        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
