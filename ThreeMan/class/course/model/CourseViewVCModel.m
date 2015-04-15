//
//  CourseViewVCModel.m
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseViewVCModel.h"

@implementation CourseViewVCModel
@synthesize imgurl,title,description ,courseID,detailContent,detailDescription,detaileImgurl,detailTitle,debugDescription;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.courseID = value;
    }
}
-(instancetype)initWithDictionaryForCourseDetail:(NSDictionary *)dict{
    if (self =[super init]) {
        detailTitle =dict[@"title"];
        detaileImgurl =dict[@"imgurl"];
        detailDescription=dict[@"description"];
        detailContent=dict[@"content"];
  
    }
    return self;
}


@end
