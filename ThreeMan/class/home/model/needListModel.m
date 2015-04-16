//
//  needListModel.m
//  ThreeMan
//
//  Created by YY on 15-4-15.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "needListModel.h"

@implementation needListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.categoryId =value;
    }
    if ([key isEqualToString:@"type"]) {
        self.categoryType =value;
    }if ([key isEqualToString:@"hits"]) {
        self.categoryHits =value;
    }
    
}

@end
