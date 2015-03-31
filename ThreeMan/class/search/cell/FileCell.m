//
//  FileCell.m
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        CGFloat leftDis = 5,topDis = 5;
        CGFloat height = 47;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, kWidth-8*2,height)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftDis, topDis,65, height-topDis*2)];
        [bgView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDis+_imgView.frame.size.width+8, topDis, 180,20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = HexRGB(0x323232);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:_titleLabel];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDis+_imgView.frame.size.width+10, height-15-5, 180, 15)];
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.textColor = HexRGB(0x959595);
        _desLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:_desLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,height-1,bgView.frame.size.width,1)];
        line.backgroundColor = HexRGB(0xe0e0e0);
        [bgView addSubview:line];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
