//
//  DateManeger.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DateManeger.h"

@implementation DateManeger


+ (NSString *)getCurrentTimeStamps{
    NSDate *now = [NSDate date];
    NSString *currentTime = [NSString stringWithFormat:@"%ld",(long)[now timeIntervalSince1970]];
    return currentTime;
}


+ (NSDate *)getDateFromTimeStamps:(NSString *)timeStamps
{
    return [NSDate dateWithTimeIntervalSince1970:[timeStamps doubleValue]];
}

+ (BOOL)isTodayTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateSMS = [formatter stringFromDate:date];
    NSString *dateNow = [formatter stringFromDate:[NSDate date]];
    if ([dateSMS isEqualToString:dateNow]) {
        return YES;
    }
    return NO;
}

@end
