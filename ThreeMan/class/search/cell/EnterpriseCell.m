//
//  EnterpriseCell.m
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "EnterpriseCell.h"

@interface EnterpriseCell ()
{
    UIView *bgView;
}

@end

@implementation EnterpriseCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        CGFloat height = 90;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 0,kWidth-8*2,height)];
        bgView.backgroundColor = [UIColor whiteColor];
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 38, 38)];
        _imgView.layer.cornerRadius = 38/2;
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.borderColor = HexRGB(0xdde5eb).CGColor;
        _imgView.layer.borderWidth = 1;
        [self.contentView addSubview:bgView];
        
        [bgView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.frame.origin.x+_imgView.frame.size.width+25, 8, kWidth-10*2-100,18)];
        _titleLabel.textColor = HexRGB(0x323232);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_titleLabel];
        
        _littleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+2,100, 10)];
        _littleLabel.font = [UIFont systemFontOfSize:12];
        _littleLabel.textColor = HexRGB(0x959595);
        _littleLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_littleLabel];
        
        CGFloat y =  _littleLabel.frame.origin.y+_littleLabel.frame.size.height;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x,y, kWidth-10*2-_titleLabel.frame.origin.x,height-y-3)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = HexRGB(0x1c8cc6);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_contentLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5, bgView.frame.size.width,0.5)];
        line.backgroundColor = HexRGB(0xe0e0e0);
        [bgView addSubview:line];
        
        self.selectedBackgroundView = [[UIView alloc] init];
        self.multipleSelectionBackgroundView = [[UIView alloc] init];

        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    bgView.backgroundColor = HexRGB(0xffffff);
    if ([UIDevice currentDevice].systemVersion.floatValue<7.0) {
        self.contentView.frame = self.bounds;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    bgView.backgroundColor = HexRGB(0xffffff);
    // Configure the view for the selected state
}

@end
