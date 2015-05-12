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
@property (nonatomic,readonly) NSMutableArray *finishedArray;
@property (nonatomic,readonly) NSMutableArray *unFinidhedArray;
@property (nonatomic,assign) id<DownloadDelegate> delegate;


+ (DownloadManager *)shareInstance;


- (void)downloadFileWithUrl:(NSString *)urlStr type:(NSString *)type fileInfo:(NSDictionary *)fileInfo;


- (void)stopDownload:(DownloadFileModel *)fileModel;


- (void)resumeDownload:(DownloadFileModel *)fileModel;


- (void)cancelDownload:(DownloadFileModel *)fileModel;

@end
