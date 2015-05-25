//
//  UnfinishedCell.m
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "UnfinishedCell.h"
#import "CommonHelper.h"

#define titleFont [UIFont systemFontOfSize:15]

@interface UnfinishedCell ()
{
    UIView *bgView;
}
@end

@implementation UnfinishedCell

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
        
        _progressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _progressView.center = CGPointMake(bgView.frame.size.width-10-_progressView.frame.size.width/2,bgView.frame.size.height/2);
        [bgView addSubview:_progressView];
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-100-5,_progressView.frame.origin.y+_progressView.frame.size.height+5, 100, 15)];
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.textAlignment = NSTextAlignmentRight;
        _progressLabel.textColor = HexRGB(0x323232);
        _progressLabel.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:_progressLabel];
        
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
    
    if (fileModel.fileReceivedSize&&fileModel.fileReceivedSize.length!=0&&fileModel.totalSize&&fileModel.totalSize.length!=0) {
        self.progressLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonHelper transformToM:fileModel.fileReceivedSize],[CommonHelper transformToM:fileModel.totalSize]];
        self.progressView.progress = [fileModel.fileReceivedSize floatValue]/[fileModel.totalSize floatValue];
    }
    if (fileModel.isDownloading) {
        self.progressView.downloadState = loadingState;
    }else{
        
        if (fileModel.willDownloading) {
            self.progressView.downloadState = waitingState;
            self.progressLabel.text = @"等 待";
            
        }else{
            self.progressView.downloadState = stopState;
            self.progressLabel.text = @"暂 停";
        }
    }

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
