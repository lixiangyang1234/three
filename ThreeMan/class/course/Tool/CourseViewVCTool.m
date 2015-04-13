//
//  CourseViewVCTool.m
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseViewVCTool.h"
#import "CourseViewVCModel.h"
@implementation CourseViewVCTool
+(void)statusesWithCourseSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    [HttpTool postWithPath:@"getSsxList" params:nil success:^(id JSON) {
        NSDictionary *dict =JSON[@"response"][@"data"][@"ssx"];
        NSLog(@"%@",dict);
        NSMutableArray *statuses =[NSMutableArray array];

//        if (![dict isKindOfClass:[NSNull class]]) {
//            CourseViewVCModel *courseModel =[[CourseViewVCModel alloc]initWithDictionaryForCourse:dict];
//            [statuses addObject:courseModel];
            success(statuses);
//
//        }else{
//            success (nil);
//        }

    } failure:^(NSError *error) {
        
    }];
    
}
@end
