//
//  courseEightModel.m
//  ThreeMan
//
//  Created by YY on 15-4-15.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "courseEightModel.h"

@implementation courseEightModel
@synthesize courseContent,courseHits,courseImgurl,courseName,courseTitle;
-(instancetype)initWithDictonaryForCourseEight:(NSDictionary *)dict
{
    if ([super self]) {
        self.courseContent =dict[@"content"];
        self.courseTitle =dict[@"title"];
        self.courseName =dict[@"name"];
        self.courseImgurl =dict[@"imgurl"];
        self.courseHits =[dict[@"hits"]intValue];

    }
    return self;
}
@end
