//
//  SaveTempDataTool.m
//  PEM
//
//  Created by house365 on 14-8-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SaveTempDataTool.h"
static SaveTempDataTool *shareInstance = nil;
@implementation SaveTempDataTool
+(SaveTempDataTool *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SaveTempDataTool alloc] init];
    });
    return shareInstance;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    if (shareInstance)
    {
        return shareInstance;
    }
    return [super allocWithZone:zone];
}


+ (NSString *)getFilePathWithFileName:(NSString *)fileName
{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.plist",fileName]];
}

+(BOOL)archiveClass:(NSMutableArray *)array FileName:(NSString *)fileName
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array];
    [archiver finishEncoding];
    BOOL ret = [data writeToFile:[self getFilePathWithFileName:fileName] atomically:YES];
    return ret;
}

+ (NSMutableArray *)unarchiveClassWithFileName:(NSString *)fileName
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self getFilePathWithFileName:fileName]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray *array = [unarchiver decodeObject];
    [unarchiver finishDecoding];
    return array;
}

+ (BOOL)removeFile:(NSString *)fileName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [self getFilePathWithFileName:fileName];
    BOOL ret = YES;
    if ([manager fileExistsAtPath:path]) {
      ret = [manager removeItemAtPath:path error:nil];
    }
    return ret;
}

@end
