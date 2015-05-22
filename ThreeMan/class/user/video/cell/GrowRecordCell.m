//
//  GrowRecordCell.m
//  ThreeMan
//
//  Created by tianj on 15/5/22.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "GrowRecordCell.h"
#define titleFont [UIFont systemFontOfSize:15]

@interface GrowRecordCell ()
{
    UIView *bgView;
}

@end

@implementation GrowRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(8,0,kWidth-8*2,80)];
        bgView.backgroundColor = HexRGB(0xffffff);
        [self.contentView addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,123,bgView.frame.size.height-5*2)];
        [bgView addSubview:_imgView];
        
        
        CGFloat x = _imgView.frame.size.width+_imgView.frame.origin.x+13;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,5,bgView.frame.size.width-x-35,50)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = titleFont;
        _titleLabel.textColor = HexRGB(0x323232);
        _titleLabel.numberOfLines = 2;
        [bgView addSubview:_titleLabel];
        
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x,bgView.frame.size.height-15-10,100,15)];
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.font = [UIFont systemFontOfSize:13];
        _desLabel.textColor = HexRGB(0x9a9a9a);
        [bgView addSubview:_desLabel];
        
        self.selectedBackgroundView = [[UIView alloc] init];
        self.multipleSelectionBackgroundView = [[UIView alloc] init];
        
    }
    return self;
}


- (void)configureForCell:(RecordItem *)item
{
    self.titleLabel.text = item.title;
    CGSize size = [AdaptationSize getSizeFromString:item.title Font:titleFont withHight:CGFLOAT_MAX withWidth:self.titleLabel.frame.size.width];
    if (size.width>self.titleLabel.frame.size.width) {
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width,50);
    }else{
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width,size.height+2);
    }
    [self.imgView setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:placeHoderImage3];
    self.desLabel.text = item.companyname;
    
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
