//
//  DownloadFileModel.m
//  DownloadManager
//
//  Created by tianj on 15/4/30.
//  Copyright (c) 2015年 tianj. All rights reserved.
//

#import "DownloadFileModel.h"

@implementation DownloadFileModel

- (BOOL)isVideo
{
    if (self.type&&[self.type isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end
