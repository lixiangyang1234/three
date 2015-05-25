//
//  FinishedCell.h
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBtn.h"
#import "DownloadFileModel.h"

@interface FinishedCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) CustomBtn *recommendBtn;
@property (nonatomic,strong) CustomBtn *questionBtn;
@property (nonatomic,strong) UIButton *playBtn;

- (void)configureForCell:(DownloadFileModel *)fileModel;

@end
