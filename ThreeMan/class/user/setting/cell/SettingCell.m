//
//  SettingCell.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 0,kWidth-8*2, 42)];
        _bgView.backgroundColor = HexRGB(0xffffff);
        [self.contentView addSubview:_bgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,200,42)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = HexRGB(0x323232);
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [_bgView addSubview:self.titleLabel];
        
        self.nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 15)];
        self.nextImage.center = CGPointMake(kWidth-8*2-15, 42/2);
        self.nextImage.image = [UIImage imageNamed:@"next"];;
        [self.bgView addSubview:self.nextImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
