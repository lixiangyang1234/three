//
//  homeViewControllTool.m
//  ThreeMan
//
//  Created by YY on 15-4-10.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "homeViewControllTool.h"
#import "homeViewArrayModel.h"
#import "courseEightModel.h"
#import "nineBlockModel.h"
@implementation homeViewControllTool
//首页
+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    
    [HttpTool postWithPath:@"getIndex" params:nil success:^(id JSON, int code, NSString *msg) {
        NSMutableArray *statuses =[NSMutableArray array];
        
       
        NSDictionary *dict =JSON[@"data"];
//        NSLog(@"%@",JSON);
        homeViewArrayModel *homeModel =[[homeViewArrayModel alloc]initWithForHomeArray:dict];
        
        [statuses addObject:homeModel];
        
            success (statuses);

    } failure:^(NSError *error) {
        failure(error);
    }];
}
//八大课程
+ (void)statusesWithCourseEightID:(NSString *)coursrId Success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:coursrId,@"id", nil];
    [HttpTool postWithPath:@"getCourseDetail" params:paramDic success:^(id JSON, int code, NSString *msg) {
        NSDictionary *dict =JSON[@"data"][@"course_detail"];
        NSLog(@"%@",JSON);
        NSMutableArray *status =[[NSMutableArray alloc]init];
        if (![dict isKindOfClass:[NSNull class]]) {
            courseEightModel *courseModel =[[courseEightModel alloc]initWithDictonaryForCourseEight:dict];
            [status addObject:courseModel];
            success(status);
        }else{
            success(nil);
        }
            } failure:^(NSError *error) {
                failure(error);
    }];
}
+ (void)statusesWithNineBlockID:(NSString *)nineID Success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
    {
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:nineID,@"id", nil];
    [HttpTool postWithPath:@"getNeed1" params:paramDic success:^(id JSON, int code, NSString *msg) {
        NSMutableArray *status =[NSMutableArray array];
        NSDictionary *dict =JSON[@"data"][@"category"];
       
        if (![dict isKindOfClass:[NSNull class]]) {
//            nineBlockModel *nineModel =[[nineBlockModel alloc]initWithDictonaryForNineBlock:dict];
            [status addObject:dict];
            success(status);
        }else {
            success (nil);
        }
        
    
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
