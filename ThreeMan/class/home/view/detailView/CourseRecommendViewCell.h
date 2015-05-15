//
//  CourseRecommendViewCell.h
//  ThreeMan
//
//  Created by YY on 15-4-3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "courseDetailModel.h"
#import "AdaptationSize.h"
@interface CourseRecommendViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headerRecommendImage;
@property(nonatomic,strong)UILabel *nameRecomendLabel;
@property(nonatomic,strong)UILabel *timeRecomendLabel;
@property(nonatomic,strong)UILabel *contentRecomendLabel;
@property(nonatomic,strong)UIView *backCell;
@property(nonatomic,strong)UIView *backLineCell;
-(void)setObjectRecommendItem:(courseDetailModel *)item;
@end
