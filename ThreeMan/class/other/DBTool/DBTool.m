//
//  DBTool.m
//  ThreeMan
//
//  Created by apple on 15/4/12.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "DBTool.h"

static DBTool *_instance;
@implementation DBTool
+ (DBTool *)shareDBToolClass
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DBTool alloc] init];
    });
    
    return _instance;
}


- (void)openDB
{
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Model.sqlite"];
//    NSLog(@"0---------%@",path);
    
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (error)
    {
        NSLog(@"打开数据库失败 - %@",error.localizedDescription);
    }
    else
    {
        NSLog(@"打开数据库成功！");
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = store;
        
    }
    
    
}

#pragma mark - 存储button
- (void)saveTitleButtonWithEntity:(id)entity
{
    NSDictionary *dict = (NSDictionary *)entity;
    
    NSString *tTag = dict[@"t_tag"];
    
    // 先去检索，如果存在，就不保存，不存在就去保存
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TitleButtonModel"];
    BOOL isSave = false;
    NSArray *result = [_context executeFetchRequest:request error:nil];
    for (TitleButtonModel *titleButtonModel in result)
    {
        if ([dict[@"t_title"] isEqualToString:titleButtonModel.t_title])
        {
            isSave = true;
        }
    }
    
    if (!isSave)
    {
        TitleButtonModel *titleButtonModel = [NSEntityDescription insertNewObjectForEntityForName:@"TitleButtonModel" inManagedObjectContext:_context];
       
        titleButtonModel.t_tag = dict[@"t_tag"];
        titleButtonModel.t_title = dict[@"t_title"];
        titleButtonModel.c_tag = tTag;
        titleButtonModel.c_title = dict[@"c_title"];
        
        if ([tTag isEqualToString:@"100"])
        {
            titleButtonModel.t_isselected = @1;
        }
        
        if ([_context save:nil])
        {
//            NSLog(@"保存成功！");
        }
        else
        {
            NSLog(@"保存失败！");
        }

    }
    
}

- (void)updateSelectedStyleByTTag:(NSString *)t_tag withCTag:(NSString *)c_tag
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TitleButtonModel"];
    
    NSArray *allResult = [_context executeFetchRequest:request error:nil];
    for (TitleButtonModel *titleButtonModel in allResult)
    {
        titleButtonModel.t_isselected = @0;
    }
    
    
    
    request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"t_tag = '%@'",t_tag]];
    NSArray *result = [_context executeFetchRequest:request error:nil];
    
    
    if (result.count != 0)
    {
        TitleButtonModel *titleButtonModel = [result objectAtIndex:0];
        titleButtonModel.t_isselected = @1;
        
        if([titleButtonModel.t_tag isEqualToString:@"101"])
        {
            titleButtonModel.c_tag = c_tag;
        }
    }
    
    
    if ([_context save:nil])
    {
//        NSLog(@"保存成功！");
    }
    else
    {
        NSLog(@"保存失败！");
    }
    
}

- (NSArray *)getNewTitleButtonArray
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TitleButtonModel"];
    request.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"t_isselected = '%@'",@1]];
    NSArray *result = [_context executeFetchRequest:request error:nil];
    
    return result;
    
}

- (void)deleteAllEntity
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TitleButtonModel"];
    
    NSArray *result = [_context executeFetchRequest:request error:nil];
    
    for (TitleButtonModel *model in result)
    {
        [_context deleteObject:model];
    }

    if ([_context save:nil])
    {
//        NSLog(@"删除成功！");
    }
    else
    {
        NSLog(@"删除失败！");
    }
}

@end
