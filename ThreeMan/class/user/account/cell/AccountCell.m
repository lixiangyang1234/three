//
//  AccountCell.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, kWidth-8*2,55)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8, 200,20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = HexRGB(0x323232);
        [bgView addSubview:self.titleLabel];
        
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x,self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5,200, 15)];
        self.desLabel.backgroundColor = [UIColor clearColor];
        self.desLabel.font = [UIFont systemFontOfSize:13];
        self.desLabel.textColor = HexRGB(0x959595);
        [bgView addSubview:self.desLabel];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-8-100,5,100, 20)];
        self.amountLabel.textAlignment = NSTextAlignmentRight;
        self.amountLabel.backgroundColor = [UIColor clearColor];
        self.amountLabel.font = [UIFont systemFontOfSize:18];
        self.amountLabel.textColor = HexRGB(0x1c8cc6);
        [bgView addSubview:self.amountLabel];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-8-100,self.desLabel.frame.origin.y,100, 15)];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont systemFontOfSize:13];
        self.dateLabel.textColor = HexRGB(0x959595);
        [bgView addSubview:self.dateLabel];

        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.frame.size.height-0.5,bgView.frame.size.width, 0.5)];
        [bgView addSubview:self.line];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
