//
//  courseDetailModel.m
//  ThreeMan
//
//  Created by YY on 15-4-16.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "courseDetailModel.h"

@implementation courseDetailModel
@synthesize courseImgurl,courseCompanyname,courseContent,courseDownloadnum,courseId,courseNum,courseTitle;
-(instancetype)initWithDictnoaryForCourseDetail:(NSDictionary *)dict{
    if ([super self ]) {
        self.courseImgurl =dict[@"imgurl"];
        self.courseId =[dict[@"id"]intValue];
        self.courseDownloadnum =[dict[@"Downloadnum"]intValue];
        self.courseNum =[dict[@"num"]intValue];
        self.courseContent =dict[@"content"];
        self.courseTitle =dict[@"title"];
        self.courseCompanyname =dict[@"companyname"];
      

    }
    return self;
}
@end
