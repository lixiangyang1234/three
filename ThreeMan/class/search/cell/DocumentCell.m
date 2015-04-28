//
//  DocumentCell.m
//  ThreeMan
//
//  Created by tianj on 15/4/27.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "DocumentCell.h"
#import "AdaptationSize.h"

#define YYBorderX 8
#define YYBorderY 10

@implementation DocumentCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backCell =[[UIView alloc]initWithFrame:CGRectMake(YYBorderX, 8, kWidth-YYBorderX*2, 80)];
        [self.contentView addSubview:backCell];
        backCell.backgroundColor = HexRGB(0xffffff);
        //底部线条
        UIView *topLie =[[UIView alloc]initWithFrame:CGRectMake(0, backCell.frame.size.height-0.5, backCell.frame.size.width, 0.5)];
        [backCell addSubview:topLie];
        topLie.backgroundColor =HexRGB(0xcacaca);
        
        _companyHomeImage =[[UIImageView alloc]initWithFrame:CGRectMake(5,5,123, 70)];
        [backCell addSubview:_companyHomeImage];
        _companyHomeImage.backgroundColor =[UIColor clearColor];
        _companyHomeImage.userInteractionEnabled =YES;
        
        _companyHomeSmailImage =[[typeView alloc]initWithFrame:CGRectMake(_companyHomeImage.frame.origin.x+_companyHomeImage.frame.size.width+5, 10,27, 15)];
        [backCell addSubview:_companyHomeSmailImage];
        _companyHomeSmailImage.backgroundColor =[UIColor clearColor];
        _companyHomeSmailImage.userInteractionEnabled =YES;
        
        
        _companyHomeTitle =[[UILabel alloc]initWithFrame:CGRectZero];
        _companyHomeTitle.backgroundColor =[UIColor clearColor];
        _companyHomeTitle.textColor = HexRGB(0x323232);
        [backCell addSubview:_companyHomeTitle];
        
        _companyHomeTitle.numberOfLines =2;
        _companyHomeTitle.font =[UIFont systemFontOfSize:15];
        
        _downLoadBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:_downLoadBtn];
        _downLoadBtn.frame =CGRectMake(_companyHomeImage.frame.origin.x+_companyHomeImage.frame.size.width+9,backCell.frame.size.height-25-3,70, 25);
        _downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _downLoadBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        
        [_downLoadBtn setImage:[UIImage imageNamed:@"companyDownload_img"] forState:UIControlStateNormal];
        _downLoadBtn.userInteractionEnabled = NO;
        [_downLoadBtn setTitleColor:HexRGB(0xa8a8a8) forState:UIControlStateNormal];
        
        _zanBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [backCell addSubview:_zanBtn];
        _zanBtn.frame =CGRectMake(_downLoadBtn.frame.origin.x+_downLoadBtn.frame.size.width+5,_downLoadBtn.frame.origin.y,70, 25);
        _zanBtn.userInteractionEnabled = NO;
        _zanBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _zanBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 7, 0, 0);
        _zanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_zanBtn setImage:[UIImage imageNamed:@"browser_number_icon"] forState:UIControlStateNormal];
        [_zanBtn setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    }
    return self;
}

- (void)setObject:(FileModel *)fileModel
{
    [_companyHomeImage setImageWithURL:[NSURL URLWithString:fileModel.img] placeholderImage:placeHoderImage2];
    CGSize size = [AdaptationSize getSizeFromString:fileModel.title Font:[UIFont systemFontOfSize:15] withHight:20 withWidth:CGFLOAT_MAX];
    if (size.width<=(kWidth-YYBorderX*2-(_companyHomeSmailImage.frame.origin.x+_companyHomeSmailImage.frame.size.width+15))) {
        _companyHomeTitle.frame = CGRectMake(_companyHomeSmailImage.frame.origin.x+_companyHomeSmailImage.frame.size.width+5,7,size.width,20);
        _companyHomeTitle.text = fileModel.title;
    }else{
        _companyHomeTitle.frame = CGRectMake(_companyHomeSmailImage.frame.origin.x,7,kWidth-YYBorderX*2-_companyHomeSmailImage.frame.origin.x-5-10,40);
        _companyHomeTitle.text = [NSString stringWithFormat:@"       %@",fileModel.title];
    }
    [_companyHomeSmailImage typeID:1];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
