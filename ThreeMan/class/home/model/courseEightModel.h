//
//  courseEightModel.h
//  ThreeMan
//
//  Created by YY on 15-4-15.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface courseEightModel : NSObject
@property(nonatomic,copy)NSString *courseContent;
@property(nonatomic,copy)NSString *courseImgurl;
@property(nonatomic,copy)NSString *courseName;
@property(nonatomic,copy)NSString *courseTitle;
@property(nonatomic,assign)int courseHits;

-(instancetype)initWithDictonaryForCourseEight:(NSDictionary *)dict;

@end
