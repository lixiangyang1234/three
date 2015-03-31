//
//  PatternCell.m
//  ThreeMan
//
//  Created by tianj on 15/3/31.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "PatternCell.h"

@implementation PatternCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8,kWidth-8*2,80)];
        bgView.backgroundColor = HexRGB(0xffffff);
        [self.contentView addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,123,bgView.frame.size.height-5*2)];
        [bgView addSubview:_imgView];
        
        
        CGFloat x = _imgView.frame.size.width+_imgView.frame.origin.x+13;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,5,bgView.frame.size.width-x-10,50)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = HexRGB(0x323232);
        _titleLabel.numberOfLines = 2;
        [bgView addSubview:_titleLabel];
        
        
        UILabel *readTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, 60,45,15)];
        readTitle.backgroundColor = [UIColor clearColor];
        readTitle.text = @"点击量";
        readTitle.textColor = HexRGB(0x959595);
        readTitle.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:readTitle];
        
        _readLabel = [[UILabel alloc] initWithFrame:CGRectMake(readTitle.frame.origin.x+readTitle.frame.size.width,60,100,15)];
        _readLabel.backgroundColor = [UIColor clearColor];
        _readLabel.font = [UIFont systemFontOfSize:13];
        _readLabel.textColor = HexRGB(0x1c8cc6);
        [bgView addSubview:_readLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
