//
//  UserItem.m
//  ThreeMan
//
//  Created by tianj on 15/4/14.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
}


- (BOOL)imageExists
{
    if (self.img&&![self.img isKindOfClass:[NSNull class]]&&self.img.length!=0) {
        return YES;
    }
    return NO;
}

- (BOOL)isBusinessUser
{
    if ([self.type isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isBusinessUserWithType:(NSString *)type
{
    if ([type isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end
