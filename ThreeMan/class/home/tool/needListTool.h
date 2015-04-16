//
//  needListTool.h
//  ThreeMan
//
//  Created by YY on 15-4-15.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StatusSuccessBlock) (NSMutableArray * status);
typedef void (^StatusFailBlock) (NSError *error);
@interface needListTool : NSObject
+(void)StatusWithNeedListId:(NSString *)needid needType:(NSString *)type Success:(StatusSuccessBlock)success failure:(StatusFailBlock)error;
@end
