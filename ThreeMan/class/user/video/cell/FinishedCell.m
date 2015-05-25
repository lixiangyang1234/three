//
//  FinishedCell.m
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "FinishedCell.h"

#define titleFont [UIFont systemFontOfSize:15]


@interface FinishedCell ()
{
    UIView *bgView;
}
@end


@implementation FinishedCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe8e8e8);
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(8,4,kWidth-8*2,80)];
        bgView.backgroundColor = HexRGB(0xffffff);
        [self.contentView addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,123,bgView.frame.size.height-5*2)];
        [bgView addSubview:_imgView];
        
        
        CGFloat x = _imgView.frame.size.width+_imgView.frame.origin.x+10;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,5,bgView.frame.size.width-x-10-25,50)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = titleFont;
        _titleLabel.textColor = HexRGB(0x323232);
        _titleLabel.numberOfLines = 2;
        [bgView addSubview:_titleLabel];
        
        _recommendBtn = [[CustomBtn alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x,55,50,25)];
        [_recommendBtn setTitle:@"推荐" forState:UIControlStateNormal];
        [_recommendBtn setImage:[UIImage imageNamed:@"recommend"] forState:UIControlStateNormal];
        [bgView addSubview:_recommendBtn];
        
        _questionBtn = [[CustomBtn alloc] initWithFrame:CGRectMake(_recommendBtn.frame.origin.x+_recommendBtn.frame.size.width+10,_recommendBtn.frame.origin.y,50,25)];
        [_questionBtn setTitle:@"提问" forState:UIControlStateNormal];
        [_questionBtn setImage:[UIImage imageNamed:@"question"] forState:UIControlStateNormal];
        [bgView addSubview:_questionBtn];
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(0, 0, 25, 25);
        _playBtn.center = CGPointMake(bgView.frame.size.width-10-_playBtn.frame.size.width/2,bgView.frame.size.height/2);
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [bgView addSubview:_playBtn];
        
        
        self.selectedBackgroundView = [[UIView alloc] init];
        self.multipleSelectionBackgroundView = [[UIView alloc] init];

    }
    return self;
}


- (void)configureForCell:(DownloadFileModel *)fileModel
{
    NSDictionary *dic = fileModel.fileInfo;
    NSString *imageurl = [dic objectForKey:@"imgurl"];
    NSString *title = [dic objectForKey:@"title"];
    self.titleLabel.text = title;
    CGSize size = [AdaptationSize getSizeFromString:title Font:titleFont withHight:CGFLOAT_MAX withWidth:self.titleLabel.frame.size.width];
    if (size.width>self.titleLabel.frame.size.width) {
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width,50);
    }else{
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width,size.height+2);
    }

    [self.imgView setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:placeHoderImage];

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
