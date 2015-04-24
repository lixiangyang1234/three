//
//  DateManeger.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManeger : NSObject


/**
 *  获取当前时间的时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)getCurrentTimeStamps;

/**
 *  有时间戳得到date
 *
 *  @param timeStamps 时间戳
 *
 *  @return date对象
 */
+ (NSDate *)getDateFromTimeStamps:(NSString *)timeStamps;

/**
 *  判断date是否是当前的时间
 *
 *  @param date <#date description#>
 *
 *  @return 返回ture表示是
 */
+ (BOOL)isTodayTime:(NSDate *)date;

@end
