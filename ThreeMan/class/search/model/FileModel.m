//
//  FileModel.m
//  ThreeMan
//
//  Created by tianj on 15/4/27.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
}

@end
