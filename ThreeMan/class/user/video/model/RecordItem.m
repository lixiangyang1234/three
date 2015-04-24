//
//  RecordItem.m
//  ThreeMan
//
//  Created by tianj on 15/4/9.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RecordItem.h"

@implementation RecordItem

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.mid = value;
    }
}

@end
