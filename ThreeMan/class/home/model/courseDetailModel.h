//
//  courseDetailModel.h
//  ThreeMan
//
//  Created by YY on 15-4-16.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface courseDetailModel : NSObject
//详情
@property(nonatomic,copy)NSString *courseCompanyname;
@property(nonatomic,copy)NSString *courseContent;
@property(nonatomic,assign)int courseDownloadnum;
@property(nonatomic,assign)int courseId;
@property(nonatomic,copy)NSString *courseImgurl;
@property(nonatomic,assign)int courseNum;
@property(nonatomic,copy)NSString *courseTitle;
//推荐
@property(nonatomic,copy)NSString *recommednAddtime;
@property(nonatomic,copy)NSString *recommendContent;
@property(nonatomic,copy)NSString *recommendUseame;
@property(nonatomic,copy)NSString *recommendImg;
@property(nonatomic,assign)int recommendId;


//答疑
@property(nonatomic,copy)NSString *answerAddtime;
@property(nonatomic,copy)NSString *answerContent;
@property(nonatomic,copy)NSString *answerName;
@property(nonatomic,copy)NSString *answerImg;
@property(nonatomic,copy)NSString *answerTitle;
@property(nonatomic,assign)int answerId;


//详情
-(instancetype)initWithDictnoaryForCourseDetail:(NSDictionary *)dict;
//推荐
-(instancetype)initWithDictnoaryForCourseRecommend:(NSDictionary *)dict;

//答疑
-(instancetype)initWithDictnoaryForCourseAnswer:(NSDictionary *)dict;

@end
