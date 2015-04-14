//
//  homeViewControllTool.m
//  ThreeMan
//
//  Created by YY on 15-4-10.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "homeViewControllTool.h"
#import "homeViewArrayModel.h"
@implementation homeViewControllTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure{
    
    //    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    [HttpTool postWithPath:@"getIndex" params:nil success:^(id JSON, int code, NSString *msg) {
        NSMutableArray *statuses =[NSMutableArray array];
        
        //        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict =JSON[@"data"];
        
        homeViewArrayModel *homeModel =[[homeViewArrayModel alloc]initWithForHomeArray:dict];
        
        [statuses addObject:homeModel];
        
        
        
//        NSLog(@"--------%@",dict);
        success (statuses);

    } failure:^(NSError *error) {
        
       
    }];
}

@end
