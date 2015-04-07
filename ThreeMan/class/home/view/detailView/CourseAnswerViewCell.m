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
@synthesize answerImage,answerTitle,timeAnswerLabel,companyAnswerImage,contentAnswerLabel,nameAnswerLabel;
- (void)awakeFromNib {
    // Initialization code   what_img
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-YYBORDERWH, 120)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        UIView *backLineCell =[[UIView alloc]initWithFrame:CGRectMake(0, backCell.frame.size.height-1, self.frame.size.width-YYBORDERWH, 1)];
        [self addSubview:backLineCell];
        backLineCell.backgroundColor =HexRGB(0xcacaca);
        
        answerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, borderwh, 24, 21)];
        [backCell addSubview:answerImage];
        answerImage.backgroundColor =[UIColor clearColor];
        answerImage.userInteractionEnabled =YES;
        answerImage.image =[UIImage imageNamed:@"what_img"];
        
        
        CGFloat imageW =answerImage.frame.origin.x+answerImage.frame.size.width;
        
        answerTitle =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, borderwh, self.frame.size.width-borderwh*3 , 30)];
        answerTitle.backgroundColor =[UIColor clearColor];
        answerTitle.text =@"大头儿子小偷粑粑";
        [backCell addSubview:answerTitle];
        answerTitle.font =[UIFont systemFontOfSize:PxFont(22)];
        answerTitle.textColor =HexRGB(0x323232);
        CGFloat titleH =answerTitle.frame.size.height+answerTitle.frame.origin.y;
        
        contentAnswerLabel =[[UILabel alloc]initWithFrame:CGRectMake(borderwh, titleH,self.frame.size.width-borderwh*3 , 50)];
        contentAnswerLabel.backgroundColor =[UIColor clearColor];
        contentAnswerLabel.text =@"首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整首行缩进根据用户昵称自动调整 ";
        [backCell addSubview:contentAnswerLabel];
        contentAnswerLabel.numberOfLines =3;
        contentAnswerLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        contentAnswerLabel.textColor =HexRGB(0x655555);
        CGFloat contentH =contentAnswerLabel.frame.size.height+contentAnswerLabel.frame.origin.y;
        
        companyAnswerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, contentH, 26, 26)];
        [backCell addSubview:companyAnswerImage];
        companyAnswerImage.backgroundColor =[UIColor redColor];
        companyAnswerImage.userInteractionEnabled =YES;
        companyAnswerImage.layer.cornerRadius =13;
        companyAnswerImage.layer.masksToBounds=YES;
        companyAnswerImage.layer.borderWidth=1.0f;
        companyAnswerImage.layer.borderColor =HexRGB(0xdde5eb) .CGColor;
        

        nameAnswerLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, contentH, 100 , 30)];
        nameAnswerLabel.backgroundColor =[UIColor clearColor];
        nameAnswerLabel.text =@"大头儿子";
        [backCell addSubview:nameAnswerLabel];
        nameAnswerLabel.numberOfLines =2;
        nameAnswerLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        nameAnswerLabel.textColor =HexRGB(0xa3a3a3);
        
        timeAnswerLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-120, contentH, 80, 30)];
        timeAnswerLabel.backgroundColor =[UIColor clearColor];
        timeAnswerLabel.text =@"2015-03-04";
        [backCell addSubview:timeAnswerLabel];
        timeAnswerLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        timeAnswerLabel.textColor =HexRGB(0xa3a3a3);

        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
