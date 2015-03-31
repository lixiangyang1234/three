//
//  HotCell.m
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "HotCell.h"

@implementation HotCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        CGFloat leftDis = 16;
        CGFloat space = 9;
        CGFloat topDis = 9;
        CGFloat width = (kWidth-leftDis*2-space*2)/3;
        
        self.firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.firstBtn.frame = CGRectMake(leftDis, topDis, width, 35);
        [self.firstBtn setTitleColor:HexRGB(0x323232) forState:UIControlStateNormal];
        self.firstBtn.backgroundColor = [UIColor whiteColor];
        self.firstBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.firstBtn.layer.cornerRadius = 3.0f;
        self.firstBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.firstBtn];
        
        self.secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.secondBtn.frame = CGRectMake(leftDis+width+space, topDis, width, 35);
        [self.secondBtn setTitleColor:HexRGB(0x323232) forState:UIControlStateNormal];
        self.secondBtn.backgroundColor = [UIColor whiteColor];
        self.secondBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.secondBtn.layer.cornerRadius = 3.0f;
        self.secondBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.secondBtn];
        
        self.thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.thirdBtn.frame = CGRectMake(leftDis+width*2+space*2, topDis, width, 35);
        [self.thirdBtn setTitleColor:HexRGB(0x323232) forState:UIControlStateNormal];
        self.thirdBtn.backgroundColor = [UIColor whiteColor];
        self.thirdBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.thirdBtn.layer.cornerRadius = 3.0f;
        self.thirdBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.thirdBtn];


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
