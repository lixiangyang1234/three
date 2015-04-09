//
//  RecordDbService.m
//  ThreeMan
//
//  Created by tianj on 15/4/9.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RecordDbService.h"

#define DBNAME @"record.sqlite"

@implementation RecordDbService


+ (RecordDbService *)shareInstance
{
    static RecordDbService *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[RecordDbService alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        dbPath = [self getDbPathRecordDb];
        db = [FMDatabase databaseWithPath:dbPath];
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

//创建表格
- (BOOL)createRecordTable
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:dbPath] == NO) {
        if ([db open]) {
            NSString *sql = @"CREATE TABLE 'record' ('id' INTEGER PRIMARY KEY AUTOINCAEMENT NOT NULL,'avatar' VARCHAR(200),'title' VARCHAR(100),'source' VARCHAR(100),'date' VARCHAR(20))";
            BOOL res = [db executeUpdate:sql];
            if (res) {
                NSLog(@"success to create table");
            }else{
                NSLog(@"error to create table");
            }
            [db close];
            return res;
        }else{
            NSLog(@"error when open db");
            return NO;
        }
    }
    return YES;
}

//插入
- (BOOL)insertRecord:(RecordItem *)item
{
    if ([db open]) {
        NSString *sql = @"INSERT INTO 'record' ('id','avatar','title','source','date') VALUES (?,?,?,?,?)";
        BOOL res = [db executeUpdate:sql,item.uid,item.image,item.title,item.desc,item.date];
        [db close];
        return res;
    }else{
        return NO;
    }
    return YES;
}

//删除
- (BOOL)deleteRecord:(RecordItem *)item
{
    if ([db open]) {
        NSString *sql = @"DELETE FROM 'record' WHERE id = ?";
        BOOL res = [db executeUpdate:sql,item.uid];
        return res;
    }else{
        return NO;
    }
    return  YES;
}


//多项删除
- (void)multiDelRecord:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        RecordItem *item = [array objectAtIndex:i];
        [self deleteRecord:item];
    }
}

//获取所有记录
- (NSArray *)allRecord
{
    if ([db open]) {
        
        NSString *sql = @"SELECT * FROM 'record'";
        FMResultSet *rs = [db executeQuery:sql];
        NSMutableArray *array;
        while ([rs next]) {
            RecordItem *item;
            item.uid = [rs intForColumn:@"id"];
            item.image = [rs stringForColumn:@"avatar"];
            item.title = [rs stringForColumn:@"title"];
            item.desc = [rs stringForColumn:@"source"];
            item.date = [rs stringForColumn:@"date"];
            [array addObject:item];
        }
        
        return [array copy];
    }
    
    return nil;
}

//查看数据库是否存在该记录
- (BOOL)checkRecord:(RecordItem *)item
{
    if ([db open]) {
        NSString *sql = @"SELECT * FROM 'record' WHERE id = ?";
        FMResultSet *rs = [db executeQuery:sql,item.uid];
        int count = 0;
        while ([rs next]) {
            count++;
        }
        if (count>0) {
            return YES;
        }
        return NO;
    }
    return NO;
}


- (NSString *)getDbPathRecordDb
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:DBNAME];
    return path;
}

@end
