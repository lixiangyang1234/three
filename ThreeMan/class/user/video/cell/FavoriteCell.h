//
//  FavoriteCell.h
//  ThreeMan
//
//  Created by tianj on 15/4/3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteItem.h"

@interface FavoriteCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;


- (void)configureForCell:(FavoriteItem *)item;

@end
