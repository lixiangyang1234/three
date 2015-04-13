//
//  CourseViewVCModel.m
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseViewVCModel.h"

@implementation CourseViewVCModel
@synthesize courseContent,courseHeaderImage,courseTitle,courseID;
-(instancetype)initWithDictionaryForCourse:(NSDictionary *)dict{
    if (self=[super init]) {
        courseTitle =dict[@"title"];
        courseHeaderImage =dict[@"imgurl"];
        courseContent=dict[@"description"];
        courseID =[dict[@"id"]intValue];
    }
    return self;
}
@end
