//
//  DownloadDelegate.h
//  模拟下载
//
//  Created by tianj on 15/3/23.
//  Copyright (c) 2015年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadFileModel.h"

@protocol DownloadDelegate <NSObject>

@optional

- (void)downloadFinished:(DownloadFileModel *)fileinfo;

- (void)downloadFailure:(DownloadFileModel *)fileinfo;

- (void)updateUI:(DownloadFileModel *)fileinfo progress:(float)progress;

@end
