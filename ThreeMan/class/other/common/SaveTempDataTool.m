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

+(void)archiveClass:(NSMutableArray *)array FileName:(NSString *)fileName
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array];
    [archiver finishEncoding];
    [data writeToFile:[self getFilePathWithFileName:fileName] atomically:YES];
}

+ (NSMutableArray *)unarchiveClassWithFileName:(NSString *)fileName
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self getFilePathWithFileName:fileName]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray *array = [unarchiver decodeObject];
    [unarchiver finishDecoding];
    return array;
}

+ (void)removeFile:(NSString *)fileName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [self getFilePathWithFileName:fileName];
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
}

@end
