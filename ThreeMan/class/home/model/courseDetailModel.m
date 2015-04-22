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
        self.iscollect =[dict[@"iscollect"]intValue];

        self.courseTitle =dict[@"title"];
        self.courseCompanyname =dict[@"companyname"];
      

    }
    return self;
}
-(instancetype)initWithDictnoaryForCourseRecommend:(NSDictionary *)dict{
    if ([super self]) {
        self.recommednAddtime =dict[@"addtime"];
        self.recommendContent =dict[@"content"];
        self.recommendImg =dict[@"img"];
        self.recommendUseame =dict[@"username"];
        self.recommendId =[dict[@"id"]intValue];

        
    }
    return self;
}

-(instancetype)initWithDictnoaryForCourseAnswer:(NSDictionary *)dict{
    if ([super self]) {
        self.answerAddtime =dict[@"addtime"];
        self.answerContent =dict[@"content"];
        self.answerImg =dict[@"logo"];
        self.answerName =dict[@"companyname"];
        self.answerTitle =dict[@"title"];
        self.answerId =[dict[@"id"]intValue];
        
        
    }
    return self;
}

@end
