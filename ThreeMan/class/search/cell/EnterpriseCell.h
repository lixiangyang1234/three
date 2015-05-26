//
//  EnterpriseCell.h
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterpriseItem.h"

@interface EnterpriseCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *littleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *line;


- (void)configureForCell:(EnterpriseItem *)item;


@end
