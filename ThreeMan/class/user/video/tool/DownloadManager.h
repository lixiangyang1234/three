//
//  DownloadManager.h
//  ThreeMan
//
//  Created by tianj on 15/5/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlSessionDownload.h"
#import "AFDownload.h"
#import "DownloadDelegate.h"
#import "DownloadFileModel.h"

@interface DownloadManager : NSObject

+ (void)downloadFileWithUrl:(NSString *)urlStr type:(NSString *)type fileInfo:(NSDictionary *)fileInfo;


+ (void)stopDownload:(DownloadFileModel *)fileModel;


+ (void)resumeDownload:(DownloadFileModel *)fileModel;


+ (void)cancelDownload:(DownloadFileModel *)fileModel;

+ (NSMutableArray *)arrayOfFinished;


+ (NSMutableArray *)arrayOfUnfinished;


+ (void)setDelegate:(id<DownloadDelegate>)delegate;

+ (void)deleteFinisedFiles:(NSArray *)arr;

+ (void)cancelDownloads:(NSArray *)arr;


@end
