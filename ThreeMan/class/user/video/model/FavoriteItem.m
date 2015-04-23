//
//  FavoriteItem.m
//  ThreeMan
//
//  Created by tianj on 15/4/3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "FavoriteItem.h"

@implementation FavoriteItem

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.mid = value;
    }
}

@end
