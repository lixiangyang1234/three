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
//
+ (void)statusesWithCourseID:(NSString *)course_id CourseSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    NSDictionary *parmDict =[NSDictionary dictionaryWithObjectsAndKeys:course_id,@"id", nil];
    [HttpTool postWithPath:@"getSsxDetail" params:parmDict success:^(id JSON, int code, NSString *msg) {
        NSMutableArray *status =[[NSMutableArray alloc]init];
        NSDictionary *dict =JSON[@"data"][@"ssx_detail"];
        NSLog(@"%@",dict);
        if (![dict isKindOfClass:[NSNull class]]) {
            CourseViewVCModel *courseDetailModel =[[CourseViewVCModel alloc]initWithDictionaryForCourseDetail:dict];
            [status addObject:courseDetailModel];
            success(status);

        }else{
            success(nil);
            
        }
//        success(status);

    } failure:^(NSError *error) {
        
    }];
}
@end
