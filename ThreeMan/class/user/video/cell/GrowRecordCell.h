//
//  GrowRecordCell.h
//  ThreeMan
//
//  Created by tianj on 15/5/22.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordItem.h"

@interface GrowRecordCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;

- (void)configureForCell:(RecordItem *)item;


@end
