//
//  RecordDbService.h
//  ThreeMan
//
//  Created by tianj on 15/4/9.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "RecordItem.h"

@interface RecordDbService : NSObject
{
    FMDatabase *db;
    FMDatabaseQueue *dbQueue;
    NSString *dbPath;
}

+ (RecordDbService *)shareInstance;

- (BOOL)createRecordTable;

- (BOOL)insertRecord:(RecordItem *)item;

- (BOOL)deleteRecord:(RecordItem *)item;

- (void)multiDelRecord:(NSArray *)array;

- (NSArray *)allRecord;

@end
