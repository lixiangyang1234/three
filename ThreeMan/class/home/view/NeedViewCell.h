//
//  NeedViewCell.h
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *needImage;
@property (nonatomic,strong)UILabel *needTitle;
@property (nonatomic,strong)UIImageView *needSmailImage;
@property(nonatomic,strong)UIButton *zanBtn;
@property(nonatomic,strong)UILabel *companyName;
@property(nonatomic,copy)NSString *titleStr;
@end
