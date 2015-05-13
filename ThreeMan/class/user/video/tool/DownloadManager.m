//
//  DownloadManager.m
//  ThreeMan
//
//  Created by tianj on 15/5/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

+ (void)setDelegate:(id<DownloadDelegate>)delegate
{
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [UrlSessionDownload shareInstance].delegate = delegate;
    }else{
        [AFDownload shareInstance].delegate = delegate;
    }
}

+ (void)downloadFileWithUrl:(NSString *)urlStr type:(NSString *)type fileInfo:(NSDictionary *)fileInfo
{
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] downloadFileWithUrl:urlStr type:type fileInfo:fileInfo];
    }else{
        [[AFDownload shareInstance] downloadFileWithUrl:urlStr type:type fileInfo:fileInfo];
    }
}


+ (NSMutableArray *)arrayOfFinished
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [array addObjectsFromArray:[UrlSessionDownload shareInstance].finishArray];
    }else{
        [array addObjectsFromArray:[AFDownload shareInstance].finishArray];
    }
    return array;
}

+ (NSMutableArray *)arrayOfUnfinished
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [array addObjectsFromArray:[UrlSessionDownload shareInstance].unfinishArray];
    }else{
        [array addObjectsFromArray:[AFDownload shareInstance].unfinishArray];
    }
    return array;
}


+ (void)stopDownload:(DownloadFileModel *)fileModel
{
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] stopDownload:fileModel];
    }else{
        [[AFDownload shareInstance] stopDownload:fileModel];
    }
    
}

+ (void)resumeDownload:(DownloadFileModel *)fileModel
{
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] resumeDownload:fileModel];
    }else{
        [[AFDownload shareInstance] resumeDownload:fileModel];
    }
    
}

+ (void)cancelDownload:(DownloadFileModel *)fileModel
{
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] cancelDownload:fileModel];
    }else{
        [[AFDownload shareInstance] cancelDownload:fileModel];
    }
}

+ (void)cancelDownloads:(NSArray *)arr
{
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] cancelDownloads:arr];
    }else{
        [[AFDownload shareInstance] cancelDownloads:arr];
    }
}

+ (void)deleteFinisedFiles:(NSArray *)arr
{
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
        [[UrlSessionDownload shareInstance] deleteFinisedFiles:arr];
    }else{
        [[AFDownload shareInstance] deleteFinisedFiles:arr];
    }

}

@end
