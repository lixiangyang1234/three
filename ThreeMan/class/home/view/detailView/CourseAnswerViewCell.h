//
//  CourseAnswerViewCell.h
//  ThreeMan
//
//  Created by YY on 15-4-3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseAnswerViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *answerImage;
@property(nonatomic,strong)UIImageView *companyAnswerImage;
@property(nonatomic,strong)UILabel *answerTitle;
@property(nonatomic,strong)UILabel *timeAnswerLabel;
@property(nonatomic,strong)UILabel *nameAnswerLabel;
@property(nonatomic,strong)UILabel *contentAnswerLabel;

@end