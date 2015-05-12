//
//  UrlSessionDownload.h
//  ThreeMan
//
//  Created by tianj on 15/5/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownloadFileModel.h"
#import "CommonHelper.h"
#import "DownloadDelegate.h"

@interface UrlSessionDownload : NSObject<NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>


@property (nonatomic,strong) NSMutableDictionary *fileDic;
@property (nonatomic,strong) NSMutableDictionary *sessionDic;        //对象urlsession
@property (nonatomic,strong) NSMutableDictionary *downloadTaskDic;   //对象downloadtask
@property (nonatomic,strong) NSMutableArray *finishArray;   //已完成下载任务
@property (nonatomic,strong) NSMutableArray *unfinishArray; //未完成下砸任务
@property (nonatomic,assign) id<DownloadDelegate> delegate;

+ (UrlSessionDownload *)shareInstance;

/**
 *  下载入口
 *
 *  @param url      下载链接
 *  @param type     文件类型  0表示视频  1表示文件
 *  @param fileInfo 文件信息 如文件对图片链接 文件标题等
 */
- (void)downloadFileWithUrl:(NSString *)urlStr type:(NSString *)type fileInfo:(NSDictionary *)fileInfo;


- (void)stopDownload:(DownloadFileModel *)fileModel;


- (void)resumeDownload:(DownloadFileModel *)fileModel;


- (void)cancelDownload:(DownloadFileModel *)fileModel;

//存储未下载完成文件
- (void)saveunFinishedFile;

- (void)loadunFinishedFile;

@end
