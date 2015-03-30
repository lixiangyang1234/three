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
        self.backgroundColor = HexRGB(0xf3f3f3);
        CGFloat leftDis = 5,topDis = 5;
        CGFloat height = 80;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kWidth-10*2,height)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftDis, topDis, 100, height-topDis*2)];
        [bgView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDis+_imgView.frame.size.width+10, topDis, 180, 25)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_titleLabel];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDis+_imgView.frame.size.width+10, height-topDis-20, 180, 20)];
        _desLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_desLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,height-1,bgView.frame.size.width,1)];
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
