//
//  MessageCell.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "MessageCell.h"

#define borderwh 8

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        
        UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(borderwh,8, kWidth-borderwh*2, 66)];
        
        [self.contentView addSubview:bgView];
        bgView.backgroundColor =[UIColor whiteColor];
        
        _headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(borderwh, borderwh, 50, 50)];
        [bgView addSubview:_headerImage];
        _headerImage.backgroundColor =[UIColor redColor];
        _headerImage.userInteractionEnabled =YES;
        _headerImage.layer.cornerRadius =_headerImage.frame.size.width/2;
        _headerImage.layer.masksToBounds=YES;
        CGFloat imageW =_headerImage.frame.origin.x+_headerImage.frame.size.width;
        
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh,12,150, 20)];
        _titleLabel.backgroundColor =[UIColor clearColor];
        [bgView addSubview:_titleLabel];
        _titleLabel.font =[UIFont systemFontOfSize:15];
        _titleLabel.textColor =HexRGB(0x323232);
        
        _dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(bgView.frame.size.width-8-80,20,80, 10)];
        _dateLabel.backgroundColor =[UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font =[UIFont systemFontOfSize:13];
        _dateLabel.textColor =HexRGB(0x959595);
        [bgView addSubview:_dateLabel];
        
        CGFloat titleH =_titleLabel.frame.origin.y+_titleLabel.frame.size.height+5;
        _contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(imageW+borderwh, titleH, bgView.frame.size.width-borderwh*2-imageW, 20)];
        _contentLabel.backgroundColor =[UIColor clearColor];
        [bgView addSubview:_contentLabel];
        _contentLabel.font =[UIFont systemFontOfSize:13];
        _contentLabel.textColor =HexRGB(0x737373);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height-1,bgView.frame.size.width, 1)];
        line.backgroundColor = HexRGB(0xcacaca);
        [bgView addSubview:line];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
