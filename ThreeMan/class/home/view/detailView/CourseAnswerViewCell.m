//
//  CourseAnswerViewCell.m
//  ThreeMan
//
//  Created by YY on 15-4-3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseAnswerViewCell.h"
#import "AdaptationSize.h"
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
        //背景图
        backCell =[[UIView alloc]init];//WithFrame:CGRectMake(borderwh, 0, kWidth-borderwh, 100)];
        [self addSubview:backCell];
        backCell.backgroundColor =[UIColor whiteColor];
        
        backLineCell =[[UIView alloc]init ];//WithFrame:CGRectMake(0, backCell.frame.size.height-1, kWidth-borderwh, 1)];
        [backCell addSubview:backLineCell];
        backLineCell.backgroundColor =HexRGB(0xcacaca);
           //问号图片
        answerImage =[[UIImageView alloc]init];//WithFrame:CGRectMake(borderwh, borderwh, 24, 21)];
        [backCell addSubview:answerImage];
        answerImage.backgroundColor =[UIColor clearColor];
        answerImage.userInteractionEnabled =YES;
        answerImage.image =[UIImage imageNamed:@"what_img"];
        
        
//        CGFloat imageW =answerImage.frame.origin.x+answerImage.frame.size.width;
//        标题
        answerTitle =[[UILabel alloc]init ];//WithFrame:CGRectMake(imageW+borderwh, borderwh-4, self.frame.size.width-borderwh*3 , 30)];
        answerTitle.backgroundColor =[UIColor clearColor];
        [backCell addSubview:answerTitle];
        answerTitle.font =[UIFont systemFontOfSize:PxFont(18)];
        answerTitle.textColor =HexRGB(0x323232);
//        CGFloat titleH =answerTitle.frame.size.height+answerTitle.frame.origin.y;
        //内容
        contentAnswerLabel =[[UILabel alloc]init ];//]WithFrame:CGRectMake(borderwh, titleH,self.frame.size.width-borderwh*3 , 50)];
        contentAnswerLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:contentAnswerLabel];
        contentAnswerLabel.numberOfLines =0;
        contentAnswerLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        contentAnswerLabel.textColor =HexRGB(0x655555);
//        CGFloat contentH =contentAnswerLabel.frame.size.height+contentAnswerLabel.frame.origin.y;
  //公司头像
        companyAnswerImage =[[UIImageView alloc]init ];//WithFrame:CGRectMake(borderwh, contentH, 26, 26)];
        [backCell addSubview:companyAnswerImage];
        companyAnswerImage.backgroundColor =[UIColor clearColor];
        companyAnswerImage.userInteractionEnabled =YES;
        companyAnswerImage.layer.cornerRadius =13;
        companyAnswerImage.layer.masksToBounds=YES;
        companyAnswerImage.layer.borderWidth=1.0f;
        companyAnswerImage.layer.borderColor =HexRGB(0xdde5eb) .CGColor;
        
//公司名字
        nameAnswerLabel =[[UILabel alloc]init ];//WithFrame:CGRectMake(imageW+borderwh, contentH, 165 , 30)];
        nameAnswerLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:nameAnswerLabel];
        nameAnswerLabel.numberOfLines =2;
        nameAnswerLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        nameAnswerLabel.textColor =HexRGB(0xa3a3a3);
//        时间
        timeAnswerLabel =[[UILabel alloc]init ];//WithFrame:CGRectMake(self.frame.size.width-90, contentH, 70, 30)];
        timeAnswerLabel.backgroundColor =[UIColor clearColor];
        [backCell addSubview:timeAnswerLabel];
        timeAnswerLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        timeAnswerLabel.textColor =HexRGB(0xa3a3a3);

        
    }
    return self;
}
-(void)setObjectCell:(courseDetailModel *)object{
    CGSize contentSize =[AdaptationSize getSizeFromString:object.answerContent Font:[UIFont systemFontOfSize:PxFont(18)] withHight:CGFLOAT_MAX withWidth:kWidth-borderwh*3-borderwh*2];
    NSLog(@"fffff------------>>>%f",contentSize.height);
    if (contentSize.height>110) {
        contentSize.height =contentSize.height-16;
    }
    backCell.frame =CGRectMake(0, 0, self.frame.size.width, contentSize.height+72);
    backLineCell.frame =CGRectMake(0, backCell.frame.size.height-1, kWidth-borderwh, 1);
    
    answerImage.frame=CGRectMake(borderwh, borderwh, 24, 21);
    answerImage.image =[UIImage imageNamed:@"what_img"];
    
    CGFloat imageW =answerImage.frame.origin.x+answerImage.frame.size.width;
    answerTitle.frame=  CGRectMake(imageW+borderwh, borderwh-4, self.frame.size.width-borderwh*3 , 30);
    answerTitle.text =object.answerTitle;
    
    CGFloat titleH =answerTitle.frame.size.height+answerTitle.frame.origin.y;
    contentAnswerLabel.frame =CGRectMake(borderwh, titleH,self.frame.size.width-borderwh*3 , contentSize.height);
    contentAnswerLabel.text =object.answerContent;
    
    CGFloat contentH =contentAnswerLabel.frame.size.height+contentAnswerLabel.frame.origin.y;
    companyAnswerImage.frame =CGRectMake(borderwh, contentH, 26, 26);
    [companyAnswerImage setImageWithURL:[NSURL URLWithString:object.answerImg] placeholderImage:placeHoderImage1];
    
    nameAnswerLabel.frame =CGRectMake(imageW+borderwh, contentH, 165 , 30);
    nameAnswerLabel.text =object.answerName;
    
    timeAnswerLabel.frame =CGRectMake(self.frame.size.width-90, contentH, 70, 30);
    timeAnswerLabel.text =object.answerAddtime;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
