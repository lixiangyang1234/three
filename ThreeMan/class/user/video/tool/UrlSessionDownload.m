//
//  UrlSessionDownload.m
//  ThreeMan
//
//  Created by tianj on 15/5/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "UrlSessionDownload.h"
#import <CommonCrypto/CommonDigest.h>
#import "RemindView.h"
#import "AppDelegate.h"

#define MAX_DOWN_COUNT 3        //最大下载数量
#define BASE_PATH @"DownloadFile"  //存储的最上层目录名
#define VIDEO_PATH  @"Video"    //存储完成下载的视频目录名
#define TEMP_PATH @"Temp"      //临时存储目录
#define FINISHED_PATH_NAME @"finished"  //下载完成文件信息存储路径名
#define UNFINISHED_PATH_NAME @"unfinished"  //未下载完成文件信息存储路径名

@implementation UrlSessionDownload
+ (UrlSessionDownload *)shareInstance
{
    static UrlSessionDownload *manager = nil;
    @synchronized(self){
        if (manager == nil) {
            manager = [[UrlSessionDownload alloc] init];
        }
    }
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _fileDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        _sessionDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        _downloadTaskDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        _finishArray = [[NSMutableArray alloc] initWithCapacity:0];
        _unfinishArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadFinishedFile];
        [self loadunFinishedFile];
    }
    
    return self;
    
}

- (void)downloadFileWithUrl:(NSString *)urlStr type:(NSString *)type fileInfo:(NSDictionary *)fileInfo
{
    NSAssert(type != nil&&![type isEqualToString:@""], @"datasource must not nil or empty");
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    DownloadFileModel *fileModel = [[DownloadFileModel alloc] init];
    fileModel.fileName = url.lastPathComponent;
    fileModel.urlLink = urlStr;
    fileModel.fileInfo = [NSDictionary dictionaryWithDictionary:fileInfo];
    fileModel.type = type;
    fileModel.willDownloading = YES;
    fileModel.isDownloading = NO;
    
    NSString *targetPath = [CommonHelper getTargetPathWithBasepath:BASE_PATH subpath:[NSString stringWithFormat:@"%@_%@",VIDEO_PATH,[SystemConfig sharedInstance].uid]];
    
    NSString *basetempPath = [CommonHelper getTargetPathWithBasepath:BASE_PATH subpath:[NSString stringWithFormat:@"%@_%@",TEMP_PATH,[SystemConfig sharedInstance].uid]];
    NSString *baseTempFilePath = [CommonHelper getTargetPathWithBasepath:BASE_PATH subpath:[NSString stringWithFormat:@"%@_%@",TEMP_PATH,[SystemConfig sharedInstance].uid]];
    
    //下载最终路径
    targetPath = [targetPath stringByAppendingPathComponent:url.lastPathComponent];
    //ios7以下系统用 临时缓存路径
    NSString *tempPath = [basetempPath stringByAppendingPathComponent:url.lastPathComponent];
    fileModel.targetPath = targetPath;
    fileModel.tempPath = tempPath;
    
    NSString *tempfilePath = [baseTempFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileModel.fileName]];
    fileModel.tempfilePath = tempfilePath;
    
    //该文件已下载完成
    if ([CommonHelper isExistFile:fileModel.targetPath]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经下载过了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //存在于临时文件夹里
    if([CommonHelper isExistFile:tempfilePath])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经在下载列表中" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:fileModel.fileName,@"filename",fileModel.urlLink,@"urllink",fileModel.targetPath,@"targetpath",fileModel.tempfilePath,@"tempfilepath",fileModel.tempPath,@"temppath",fileModel.fileReceivedSize,@"filerecievesize",nil];
    
    if ([filedic writeToFile:fileModel.tempfilePath atomically:YES]) {
        NSString *identify = [self getIdentify:fileModel.fileName];
        
        [self.fileDic setObject:fileModel forKey:identify];
        
        [self.unfinishArray addObject:fileModel];
        
        NSURLSession *urlSession = [self backgroundSession:identify];
        [self.sessionDic setObject:urlSession forKey:identify];
        
        
        [self saveunFinishedFile];
        
        [self nextRequest];

        [RemindView showViewWithTitle:@"已加入下载队列" location:MIDDLE];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:addNewDownload object:nil];
    }
}

//当某个文件下载完成后  查看可否其他下载任务 有则加入下载队列下载
- (void)nextRequest
{
    if (self.unfinishArray.count==0) {
        return;
    }
    int count = 0;
    DownloadFileModel *file;
    //检查当前正在下载的文件个数  并找出第一个等待下载的文件
    for (DownloadFileModel *fileModel in self.unfinishArray) {
        if (fileModel.isDownloading) {
            count++;
        }
        if (fileModel.isDownloading==NO&&fileModel.willDownloading) {
            if (!file) {
                file = fileModel;
            }
        }
    }
    //如果正在下载的文件个数<最大可下载个数
    if (count<MAX_DOWN_COUNT) {
        
        if (file) {
            NSString *identify = [self getIdentify:file.fileName];
            DownloadFileModel *file = [self.fileDic objectForKey:identify];
            
            file.isDownloading = YES;
            file.willDownloading = NO;
            
            NSURLSession *urlsession = [self.sessionDic objectForKey:identify];
            if (file.resumeData) {
                NSURLSessionDownloadTask *downloadTask = [urlsession downloadTaskWithResumeData:file.resumeData];
                
                [self.downloadTaskDic setObject:downloadTask forKey:identify];
                [downloadTask resume];
                
            }else{
                
                NSURL *url = [NSURL URLWithString:[file.urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLSessionDownloadTask *downloadTask = [urlsession downloadTaskWithRequest:request];
                
                [downloadTask resume];
                [self.downloadTaskDic setObject:downloadTask forKey:identify];
            }
        }
    }
}


- (void)stopDownload:(DownloadFileModel *)fileModel
{
    NSString *identify = [self getIdentify:fileModel.fileName];
    DownloadFileModel *file = [self.fileDic objectForKey:identify];
    file.isDownloading = NO;
    NSURLSessionDownloadTask *downloadTask = [self.downloadTaskDic objectForKey:identify];
    [downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (resumeData) {
            file.resumeData = [[NSData alloc] initWithData:resumeData];
        }
    }];
    
    //当停止某个任务后  同时看看有没有等待下载的任务  有就加入下载
    [self nextRequest];
    
}


- (void)resumeDownload:(DownloadFileModel *)fileModel
{
    //查看当前下载数量已满
    int count = 0;
    for (DownloadFileModel *fileModel in self.unfinishArray) {
        if (fileModel.isDownloading) {
            count++;
        }
    }
    
    //下载数量未满
    NSString *identify = [self getIdentify:fileModel.fileName];
    DownloadFileModel *file = [self.fileDic objectForKey:identify];
    
    if (count<MAX_DOWN_COUNT) {
        
        if ([self.unfinishArray containsObject:file]) {
            file.isDownloading = YES;
            
            NSURLSession *urlsession = [self.sessionDic objectForKey:identify];
            
            if (file.resumeData) {
                
                NSURLSessionDownloadTask *downloadTask = [urlsession downloadTaskWithResumeData:file.resumeData];
                
                [self.downloadTaskDic setObject:downloadTask forKey:identify];
                
                [downloadTask resume];
                
            }else{
                
                NSURL *url = [NSURL URLWithString:[fileModel.urlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                NSURLSessionDownloadTask *downloadTask = [urlsession downloadTaskWithRequest:request];
                
                [downloadTask resume];
                
                [self.downloadTaskDic setObject:downloadTask forKey:[self getIdentify:file.fileName]];
                
            }
        }else
            return;
        
        //下载数量已满 改为等待状态
    }else{
        
        if ([self.unfinishArray containsObject:file]) {
            file.willDownloading = YES;
        }
    }
}


//存储下载好的文件信息到沙盒中
- (void)saveFinishedFile
{
    
    NSMutableArray *finishedInfo = [[NSMutableArray alloc] init];
    for (DownloadFileModel *file in self.finishArray) {
        NSDictionary *filedic = [self setDictionaryForFileModel:file];
        [finishedInfo addObject:filedic];
    }
    
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.dat",FINISHED_PATH_NAME,[SystemConfig sharedInstance].uid]];
    
    if (![finishedInfo writeToFile:plistPath atomically:YES]) {
        NSLog(@"write phist fail");
    }
    
}

//从磁盘导出下载好的文件信息
- (void)loadFinishedFile
{
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.dat",FINISHED_PATH_NAME,[SystemConfig sharedInstance].uid]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath]) {
        NSMutableArray *finishedArr = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *dic in finishedArr) {
            DownloadFileModel *file = [[DownloadFileModel alloc] init];
            file.fileName = [dic objectForKey:@"filename"];
            file.urlLink = [dic objectForKey:@"urllink"];
            file.targetPath = [dic objectForKey:@"targetpath"];
            file.tempfilePath = [dic objectForKey:@"tempfilepath"];
            file.tempPath = [dic objectForKey:@"temppath"];
            file.fileInfo = [dic objectForKey:@"fileinfo"];
            file.type = [dic objectForKey:@"type"];
            
            [self.fileDic setObject:file forKey:[self getIdentify:file.fileName]];
            [self.finishArray addObject:file];

        }
    }
}

//存储未下载好的文件信息到沙盒中
- (void)saveunFinishedFile
{
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.dat",UNFINISHED_PATH_NAME,[SystemConfig sharedInstance].uid]];
    
    NSMutableArray *finishedInfo = [[NSMutableArray alloc] init];
    
    for (DownloadFileModel *file in self.unfinishArray) {
        NSDictionary *fileDic = [self setDictionaryForFileModel:file];
        [finishedInfo addObject:fileDic];
    }
    
    if (![finishedInfo writeToFile:plistPath atomically:YES]) {
        NSLog(@"write phist fail");
    }
}

//从磁盘导出未下载好的文件信息
- (void)loadunFinishedFile
{
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.dat",UNFINISHED_PATH_NAME,[SystemConfig sharedInstance].uid]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath]) {
        NSMutableArray *unfinishedArr = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *dic in unfinishedArr) {
            
            DownloadFileModel *file = [[DownloadFileModel alloc] init];
            file.fileName = [dic objectForKey:@"filename"];
            file.urlLink = [dic objectForKey:@"urllink"];
            file.targetPath = [dic objectForKey:@"targetpath"];
            file.tempfilePath = [dic objectForKey:@"tempfilepath"];
            file.tempPath = [dic objectForKey:@"temppath"];
            file.resumeData = [dic objectForKey:@"resumedata"];
            file.fileInfo = [dic objectForKey:@"fileinfo"];
            file.type = [dic objectForKey:@"type"];
            file.isDownloading = NO;
            file.willDownloading = NO;
            NSString *identify = [self getIdentify:file.fileName];
            [self.fileDic setObject:file forKey:identify];
            [_unfinishArray addObject:file];
            
            //创建session对象  这样可以获取上次退出程序时对应session的下载情况
            NSURLSession *urlSession = [self backgroundSession:identify];
            [self.sessionDic setObject:urlSession forKey:identify];
        }
    }
}

- (void)deleteFinisedFiles:(NSArray *)arr
{
    for (DownloadFileModel *file in arr) {
        [self deleteFinisedFile:file];
    }
}

- (void)deleteFinisedFile:(DownloadFileModel *)file
{
    NSString *identify = [self getIdentify:file.fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    DownloadFileModel *fileModel = [self.fileDic objectForKey:identify];
    
    if ([self.finishArray containsObject:fileModel]) {
        [self.finishArray removeObject:fileModel];
        if ([fileManager fileExistsAtPath:file.targetPath]) {
            [fileManager removeItemAtPath:file.targetPath error:nil];
        }
    }
    
    [self.fileDic removeObjectForKey:identify];
    //更新磁盘中已下载信息
    [self saveFinishedFile];
}

- (void)cancelDownload:(DownloadFileModel *)fileModel
{
    
    NSString *identify = [self getIdentify:fileModel.fileName];
    
    DownloadFileModel *file = [self.fileDic objectForKey:identify];
    
    [_unfinishArray removeObject:file];
    
    NSURLSession *urlsession = [self.sessionDic objectForKey:identify];
    
    [urlsession invalidateAndCancel];
    
    if ([self.downloadTaskDic objectForKey:identify]) {
        
        [self.downloadTaskDic removeObjectForKey:identify];
        
    }
    
    //移除临时缓存文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:fileModel.tempfilePath]) {
        
        [fileManager removeItemAtPath:fileModel.tempfilePath error:nil];
        
    }
    [self.fileDic removeObjectForKey:identify];

    [self saveunFinishedFile];
}



- (void)cancelDownloads:(NSArray *)arr
{
    for (DownloadFileModel *fileModel in arr) {
        [self cancelDownload:fileModel];
    }
}

- (NSURLSession *)backgroundSession:(NSString *)identify
{
    NSURLSession *backgroundSession =nil;
    NSURLSessionConfiguration *config;
    if ([self respondsToSelector:@selector(backgroundSessionConfigurationWithIdentifier:)]) {
        config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identify];
    }else{
        config = [NSURLSessionConfiguration backgroundSessionConfiguration:identify];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *wifi = [userDefaults objectForKey:@"wifi"];
    if (wifi) {
        if ([wifi isEqualToString:@"0"]) {
            config.allowsCellularAccess = NO;
        }else{
            //允许非wifi网络下载
            config.allowsCellularAccess = YES;
        }
    }else{
        config.allowsCellularAccess = NO;
    }
    backgroundSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return backgroundSession;
}

- (NSDictionary *)setDictionaryForFileModel:(DownloadFileModel *)file
{
    NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:file.fileName,@"filename",file.urlLink,@"urllink",file.targetPath,@"targetpath",file.tempfilePath,@"tempfilepath",file.tempPath,@"temppath",file.fileInfo,@"fileinfo",file.type,@"type",nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:filedic];

    if (file.resumeData) {
        [dict setObject:file.resumeData forKey:@"resumedata"];
    }
    if (file.fileReceivedSize) {
        [dict setObject:file.fileReceivedSize forKey:@"filerecievesize"];
    }
    return [dict copy];
}

- (NSString *)getIdentify:(NSString *)str
{
    return [NSString stringWithFormat:@"com.promo.threeMan.%@",str];
}

#pragma mark NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
}

#pragma mark  NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    DownloadFileModel *fileModel = [self.fileDic objectForKey:session.configuration.identifier];
    if (error == nil) {
        NSFileManager *manager = [NSFileManager defaultManager];
        //移除临时文件
        if ([manager fileExistsAtPath:fileModel.tempfilePath]) {
            [manager removeItemAtPath:fileModel.tempfilePath error:nil];
        }
        
        [_unfinishArray removeObject:fileModel];
        [_finishArray addObject:fileModel];
        
        
        [session finishTasksAndInvalidate];
        
        //更新沙盒中存储已完成任务信息
        [self saveFinishedFile];
        
        //更新沙盒中存储未完成任务信息
        [self saveunFinishedFile];
        
        [self nextRequest];
        
        if ([self.delegate respondsToSelector:@selector(downloadFinished:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate downloadFinished:fileModel];
            });
        }
        
    }else{
        
        fileModel.isDownloading = NO;
        
        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
            fileModel.resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
        }else{
            if ([self.delegate respondsToSelector:@selector(downloadFailure:)]) {
                [self.delegate downloadFailure:fileModel];
            }
        }
    }
}


#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //将临时缓存文件移到目标目标路径下
    DownloadFileModel *fileModel = [self.fileDic objectForKey:session.configuration.identifier];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *destinationURL = [NSURL fileURLWithPath:fileModel.targetPath];
    [fileManager removeItemAtURL:destinationURL error:NULL];
    BOOL ret =  [fileManager copyItemAtURL:location toURL:destinationURL  error:NULL];
    if (!ret) {
        //如果复制下载文件失败 则删除相关信息
        if ([_finishArray containsObject:fileModel]) {
            [_finishArray removeObject:fileModel];
            [self.fileDic removeObjectForKey:session.configuration.identifier];
            [self saveFinishedFile];
        }
    }
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //更新进度
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    DownloadFileModel *fileModel = [self.fileDic objectForKey:session.configuration.identifier];
    fileModel.fileReceivedSize = [NSString stringWithFormat:@"%lld",totalBytesWritten];
    fileModel.totalSize = [NSString stringWithFormat:@"%lld",totalBytesExpectedToWrite];
    if ([self.delegate respondsToSelector:@selector(updateUI:progress:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate updateUI:fileModel progress:progress];
            
        });
    }
}


@end
