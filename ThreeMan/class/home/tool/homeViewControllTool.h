//
//  homeViewControllTool.h
//  ThreeMan
//
//  Created by YY on 15-4-10.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StatusSuccessBlock)(NSMutableArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);

@interface homeViewControllTool : NSObject
+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;

@end
