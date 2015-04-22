//
//  CompanyHomeViewCell.h
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "typeView.h"
@interface CompanyHomeViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *companyHomeImage;
@property (nonatomic,strong)UILabel *companyHomeTitle;
@property (nonatomic,strong)typeView *companyHomeSmailImage;
@property(nonatomic,strong)UIButton *zanBtn;
@property(nonatomic,strong)UIButton *downLoadBtn;

@end
