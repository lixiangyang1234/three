//
//  DocumentCell.h
//  ThreeMan
//
//  Created by tianj on 15/4/27.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "typeView.h"
#import "FileModel.h"

@interface DocumentCell : UITableViewCell

@property (nonatomic,strong)UIImageView *companyHomeImage;
@property (nonatomic,strong)UILabel *companyHomeTitle;
@property (nonatomic,strong)typeView *companyHomeSmailImage;
@property(nonatomic,strong)UIButton *zanBtn;
@property(nonatomic,strong)UIButton *downLoadBtn;


- (void)setObject:(FileModel *)fileModel;

@end
