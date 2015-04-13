//
//  DBTool.h
//  ThreeMan
//
//  Created by apple on 15/4/12.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "TitleButtonModel.h"


@interface DBTool : NSObject
{
    NSManagedObjectContext *_context;
}

+ (DBTool *)shareDBToolClass;

- (void)openDB;

- (void)saveTitleButtonWithEntity:(id)entity;
- (void)updateSelectedStyleByTTag:(NSString *)t_tag withCTag:(NSString *)c_tag;
- (NSArray *)getNewTitleButtonArray;
- (void)deleteAllEntity;

@end
