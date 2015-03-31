//
//  EnterpriseCell.m
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "EnterpriseCell.h"

@implementation EnterpriseCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xf3f3f3);
        CGFloat heigth = 150;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0,kWidth-10*2,heigth)];
        bgView.backgroundColor = [UIColor whiteColor];
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self.contentView addSubview:bgView];
        
        [bgView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, kWidth-10*2-100,25)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_titleLabel];
        
        _littleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10+_titleLabel.frame.size.height+5,100, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_littleLabel];
        
        CGFloat y =  _littleLabel.frame.origin.y+_littleLabel.frame.size.height+5;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,y, kWidth-10*2-100,heigth-y-5)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_contentLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, heigth-1, bgView.frame.size.width,1)];
        line.backgroundColor = HexRGB(0xf3f3f3);
        [bgView addSubview:line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
