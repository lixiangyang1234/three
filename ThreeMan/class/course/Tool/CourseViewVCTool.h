//
//  CourseViewVCTool.h
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSMutableArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);

@interface CourseViewVCTool : NSObject
+ (void)statusesWithCourseID:(NSString *)course_id CourseSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;
@end
