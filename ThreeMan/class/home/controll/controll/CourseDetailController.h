//
//  CourseDetailController.h
//  ThreeMan
//
//  Created by YY on 15-3-30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailController : LeftTitleController
@property(nonatomic,strong)NSString *courseDetailID;
@property(nonatomic,strong)NSMutableArray *detailArray;
@property(nonatomic,strong)NSMutableArray *recommendArray;
@property(nonatomic,strong)NSMutableArray *answerArray;

//购买
@property(nonatomic,assign)int  bySuccessCode;
@property(nonatomic,copy)NSString *bySuccessStr;

@property(nonatomic,copy)NSString *byFailStr;

@end
