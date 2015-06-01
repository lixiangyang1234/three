//
//  AccountItem.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "AccountItem.h"

@implementation AccountItem

- (BOOL)isPayout
{
    if (self.type&&self.type.length!=0) {
        if ([self.type isEqualToString:@"1"]||[self.type isEqualToString:@"3"]) {
            return YES;
        }
    }
    return YES;
}

@end
