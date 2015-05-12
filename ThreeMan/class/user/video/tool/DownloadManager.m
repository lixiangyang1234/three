//
//  DownloadManager.m
//  ThreeMan
//
//  Created by tianj on 15/5/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

+ (DownloadManager *)shareInstance
{
    static DownloadManager *manager = nil;
    @synchronized(self){
        if (manager == nil) {
            manager = [[DownloadManager alloc] init];
        }
    }
    return manager;
}


- (void)setDelegate:(id<DownloadDelegate>)delegate
{
    _delegate = delegate;
    if (![UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [UrlSessionDownload shareInstance].delegate = _delegate;
    }else{
        [AFDownload shareInstance].delegate = _delegate;
    }
}

- (void)downloadFileWithUrl:(NSString *)urlStr type:(NSString *)type fileInfo:(NSDictionary *)fileInfo
{
    if (![UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] downloadFileWithUrl:urlStr type:type fileInfo:fileInfo];
    }else{
        [[AFDownload shareInstance] downloadFileWithUrl:urlStr type:type fileInfo:fileInfo];
    }
}


- (NSMutableArray *)finishedArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    if (![UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [array addObjectsFromArray:[UrlSessionDownload shareInstance].finishArray];
    }else{
        [array addObjectsFromArray:[AFDownload shareInstance].finishArray];
    }
    return array;
}


- (NSMutableArray *)unFinidhedArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    if (![UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [array addObjectsFromArray:[UrlSessionDownload shareInstance].unfinishArray];
    }else{
        [array addObjectsFromArray:[AFDownload shareInstance].unfinishArray];
    }
    return array;
}


- (void)stopDownload:(DownloadFileModel *)fileModel
{
    if (![UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] stopDownload:fileModel];
    }else{
        [[AFDownload shareInstance] stopDownload:fileModel];
    }
    
}

- (void)resumeDownload:(DownloadFileModel *)fileModel
{
    if (![UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] resumeDownload:fileModel];
    }else{
        [[AFDownload shareInstance] resumeDownload:fileModel];
    }
    
}

- (void)cancelDownload:(DownloadFileModel *)fileModel
{
    if (![UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] cancelDownload:fileModel];
    }else{
        [[AFDownload shareInstance] cancelDownload:fileModel];
    }
}


@end
