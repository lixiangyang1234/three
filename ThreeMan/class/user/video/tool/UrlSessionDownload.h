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


@property (nonatomic,strong) NSMutableDictionary *fileDic;  //存储下载和未下载好的文件信息
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
 *  @param type     文件类型  1表示视频  其他表示文件
 *  @param fileInfo 文件信息 如文件对图片链接 文件标题等
 */

- (void)downloadFileWithUrl:(NSString *)urlStr type:(NSString *)type fileInfo:(NSDictionary *)fileInfo;

//暂停下载
- (void)stopDownload:(DownloadFileModel *)fileModel;

//开始/继续下载
- (void)resumeDownload:(DownloadFileModel *)fileModel;

//取消下载 完全取消 包括已下载的数据
- (void)cancelDownload:(DownloadFileModel *)fileModel;

//批量删除已下载好的文件
- (void)deleteFinisedFiles:(NSArray *)arr;

//批量取消下载任务
- (void)cancelDownloads:(NSArray *)arr;


@end
