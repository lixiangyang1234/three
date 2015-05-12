//
//  AFDownload.m
//  ThreeMan
//
//  Created by tianj on 15/5/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "AFDownload.h"
#import <CommonCrypto/CommonDigest.h>
#import "RemindView.h"
#import "AppDelegate.h"

#define MAX_DOWN_COUNT 3        //最大下载数量
#define BASE_PATH @"DownloadFile"  //存储的最上层目录名
#define VIDEO_PATH  @"Video"    //存储完成下载的视频目录名
#define TEMP_PATH @"Temp"      //临时存储目录
#define FINISHED_PATH_NAME @"finished.dat"  //下载完成文件信息存储路径名
#define UNFINISHED_PATH_NAME @"unfinished.dat"  //未下载完成文件信息存储路径名


@implementation AFDownload
+ (AFDownload *)shareInstance
{
    static AFDownload *manager = nil;
    @synchronized(self){
        if (manager == nil) {
            manager = [[AFDownload alloc] init];
        }
    }
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _fileDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        _opertaionDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        _finishArray = [[NSMutableArray alloc] initWithCapacity:0];
        _unfinishArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadFinishedFile];
        [self loadunFinishedFile];
    }
    return self;
}


- (void)downloadFileWithUrl:(NSString *)urlStr type:(NSString *)type fileInfo:(NSDictionary *)fileInfo
{
    NSURL *url = [NSURL URLWithString:urlStr];
    DownloadFileModel *fileModel = [[DownloadFileModel alloc] init];
    fileModel.fileName = [self getFileNameForKey:urlStr];
    fileModel.urlLink = urlStr;
    fileModel.willDownloading = YES;
    fileModel.isDownloading = NO;
    
    NSString *targetPath = [CommonHelper getTargetPathWithBasepath:BASE_PATH subpath:VIDEO_PATH];
    
    NSString *basetempPath = [CommonHelper getTargetPathWithBasepath:BASE_PATH subpath:TEMP_PATH];
    
    //下载最终路径
    targetPath = [targetPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileModel.fileName,url.lastPathComponent]];
    //ios7以下系统用 临时缓存路径
    NSString *tempPath = [basetempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileModel.fileName,url.lastPathComponent]];
    fileModel.targetPath = targetPath;
    fileModel.tempPath = tempPath;
    
    NSString *tempfilePath = [basetempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileModel.fileName]];
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
    
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    BOOL reachable = reachability.reachable;
    if (!reachable) {
        [RemindView showViewWithTitle:@"网络未连接" location:TOP];
        return;
    }
    
    BOOL reachableWifi = reachability.reachableViaWiFi;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *wifi = [userDefaults objectForKey:@"wifi"];
    if (wifi) {
        if (!reachableWifi&&[wifi isEqualToString:@"0"]) {
            [RemindView showViewWithTitle:@"当前为非Wi-Fi网络环境" location:TOP];
            return;
        }
    }else{
        if (!reachableWifi) {
            [RemindView showViewWithTitle:@"当前为非Wi-Fi网络环境" location:TOP];
            return;
        }
    }

    
    
    NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:fileModel.fileName,@"filename",fileModel.urlLink,@"urllink",fileModel.targetPath,@"targetpath",fileModel.tempfilePath,@"tempfilepath",fileModel.tempPath,@"temppath",fileModel.fileReceivedSize,@"filerecievesize",fileModel.fileInfo,@"fileinfo",nil];
    
    if ([filedic writeToFile:fileModel.tempfilePath atomically:YES]) {
        NSString *identify = [self getIdentify:fileModel.fileName];
        
        [self.fileDic setObject:fileModel forKey:identify];
        
        [_unfinishArray addObject:fileModel];
        
        
        [self saveunFinishedFile];
        
        [self nextRequest];
    }
}

//当某个文件下载完成后  查看可否其他下载任务 有则加入下载队列下载
- (void)nextRequest
{
    if (self.fileDic.count==0) {
        return;
    }
    
    int count = 0;
    DownloadFileModel *file;
    //检查当前正在下载的文件个数  并找出第一个等待下载的文件
    for (NSString *key in self.fileDic) {
        DownloadFileModel *fileModel = [self.fileDic objectForKey:key];
        if (fileModel.isDownloading) {
            count++;
        }
        //找出一个可以下载的文件
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
            
            NSURL *url = [NSURL URLWithString:file.urlLink];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            unsigned long long downloadedBytes = 0;
            
            //检查文件是否已经下载了一部分
            if ([[NSFileManager defaultManager] fileExistsAtPath:file.tempPath]) {
                
                //获取已下载的文件长度
                downloadedBytes = [self fileSizeForPath:file.tempPath];
                
                if (downloadedBytes>0) {
                    NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
                    NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
                    [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
                    request = mutableURLRequest;
                }
            }
            //不使用缓存，避免断点续传出现问题
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
            
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            op.outputStream = [NSOutputStream outputStreamToFileAtPath:file.tempPath append:YES];
            
            [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                if (!file.totalSize) {
                    file.totalSize = [NSString stringWithFormat:@"%lld",totalBytesExpectedToRead];
                }
                file.fileReceivedSize = [NSString stringWithFormat:@"%lld",totalBytesRead+downloadedBytes];
                double progress = ((double)totalBytesRead+(double)downloadedBytes)/((double)downloadedBytes+(double)totalBytesExpectedToRead);
                NSLog(@"%f",progress);
                
                if ([self.delegate respondsToSelector:@selector(updateUI:progress:)]) {
                    [self.delegate updateUI:file progress:progress];
                }
            }];
            
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSFileManager *manager = [NSFileManager defaultManager];
                //移除临时文件
                if ([manager fileExistsAtPath:file.tempfilePath]) {
                    [manager removeItemAtPath:file.tempfilePath error:nil];
                }
                
                [_finishArray addObject:file];
                
                [self.fileDic removeObjectForKey:[self getIdentify:file.fileName]];
                //将下载好的文件从临时目录拷贝到目标目录下
                [manager copyItemAtPath:file.tempPath toPath:file.targetPath error:nil];
                //移除临时下载文件
                [manager removeItemAtPath:file.tempPath error:nil];
                
                [_unfinishArray removeObject:file];
                
                //更新沙盒中存储已完成任务信息
                [self saveFinishedFile];
                
                //更新沙盒中存储未完成任务信息
                [self saveunFinishedFile];
                
                [self nextRequest];
                
                if ([self.delegate respondsToSelector:@selector(downloadFinished:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate downloadFinished:file];
                    });
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                file.isDownloading = NO;
                if ([self.delegate respondsToSelector:@selector(downloadFailure:)]) {
                    [self.delegate downloadFailure:file];
                }
                
            }];
            [self.opertaionDic setObject:op forKey:identify];
            [op start];
        }
    }
}


- (void)stopDownload:(DownloadFileModel *)fileModel
{
    NSString *identify = [self getIdentify:fileModel.fileName];
    DownloadFileModel *file = [self.fileDic objectForKey:identify];
    file.isDownloading = NO;
    AFHTTPRequestOperation *op = [self.opertaionDic objectForKey:identify];
    
    [op cancel];
    
    [self.opertaionDic removeObjectForKey:identify];
    
    //当停止某个任务后  同时看看有没有等待下载的任务  有就加入下载
    [self nextRequest];
}


- (void)resumeDownload:(DownloadFileModel *)fileModel
{
    //查看当前下载数量已满
    int count = 0;
    for (NSString *key in self.fileDic) {
        DownloadFileModel *fileModel = [self.fileDic objectForKey:key];
        if (fileModel.isDownloading) {
            count++;
        }
    }
    NSString *identify = [self getIdentify:fileModel.fileName];
    DownloadFileModel *file = [self.fileDic objectForKey:identify];
    
    //下载数量未满
    if (count<MAX_DOWN_COUNT) {
        
        file.isDownloading = YES;
        
        NSURL *url = [NSURL URLWithString:file.urlLink];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        unsigned long long downloadedBytes = 0;
        
        //检查文件是否已经下载了一部分
        if ([[NSFileManager defaultManager] fileExistsAtPath:file.tempPath]) {
            
            //获取已下载的文件长度
            downloadedBytes = [self fileSizeForPath:file.tempPath];
            
            if (downloadedBytes>0) {
                
                NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
                NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
                [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
                request = mutableURLRequest;
                
            }
        }
        
        //不使用缓存，避免断点续传出现问题
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.outputStream = [NSOutputStream outputStreamToFileAtPath:file.tempPath append:YES];
        
        [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            if (!file.totalSize) {
                file.totalSize = [NSString stringWithFormat:@"%lld",totalBytesExpectedToRead];
            }
            file.fileReceivedSize = [NSString stringWithFormat:@"%lld",totalBytesRead+downloadedBytes];
            double progress = ((double)totalBytesRead+(double)downloadedBytes)/((double)downloadedBytes+(double)totalBytesExpectedToRead);
            NSLog(@"%f",progress);
            
            if ([self.delegate respondsToSelector:@selector(updateUI:progress:)]) {
                [self.delegate updateUI:file progress:progress];
            }
            
        }];
        
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSFileManager *manager = [NSFileManager defaultManager];
            
            [_finishArray addObject:file];
            
            [self.fileDic removeObjectForKey:[self getIdentify:file.fileName]];
            //将下载好的文件从临时路径拷贝到目标路径下
            [manager copyItemAtPath:file.tempPath toPath:file.targetPath error:nil];
            
            
            //移除plist临时文件
            [manager removeItemAtPath:fileModel.tempfilePath error:nil];
            
            
            //移除在临时路径下的下载文件
            [manager removeItemAtPath:file.tempPath error:nil];
            
            [_unfinishArray removeObject:file];
            
            //更新沙盒中存储已完成任务信息
            [self saveFinishedFile];
            
            //更新沙盒中存储未完成任务信息
            [self saveunFinishedFile];
            
            [self nextRequest];
            
            if ([self.delegate respondsToSelector:@selector(downloadFinished:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate downloadFinished:file];
                });
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            file.isDownloading = NO;
            if ([self.delegate respondsToSelector:@selector(downloadFailure:)]) {
                [self.delegate downloadFailure:file];
            }
        }];
        
        [self.opertaionDic setObject:op forKey:identify];
        [op start];
        
        //下载数量已满 改为等待状态
    }else{
        file.willDownloading = YES;
    }
}

- (void)cancelDownload:(DownloadFileModel *)fileModel
{
    NSString *identify = [self getIdentify:fileModel.fileName];
    DownloadFileModel *file = [self.fileDic objectForKey:identify];
    
    [self.fileDic removeObjectForKey:identify];
    [_unfinishArray removeObject:file];
    
    if ([self.opertaionDic objectForKey:identify]) {
        AFHTTPRequestOperation *op = [self.opertaionDic objectForKey:identify];
        [op cancel];
        [self.opertaionDic removeObjectForKey:identify];
    }
    
    //移除临时缓存文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileModel.tempfilePath]) {
        [fileManager removeItemAtPath:fileModel.tempfilePath error:nil];
    }
    //移除下载的数据
    if ([fileManager fileExistsAtPath:fileModel.tempPath]) {
        [fileManager removeItemAtPath:fileModel.tempPath error:nil];
    }
}


//存储下载好的文件信息到沙盒中
- (void)saveFinishedFile
{
    
    NSMutableArray *finishedInfo = [[NSMutableArray alloc] init];
    for (DownloadFileModel *file in self.finishArray) {
        NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:file.fileName,@"filename",file.urlLink,@"urllink",file.targetPath,@"targetpath",file.tempfilePath,@"tempfilepath",file.tempPath,@"temppath",file.fileReceivedSize,@"filerecievesize",file.fileInfo,@"fileinfo",nil];
        [finishedInfo addObject:filedic];
    }
    
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [document stringByAppendingPathComponent:FINISHED_PATH_NAME];
    
    if (![finishedInfo writeToFile:plistPath atomically:YES]) {
        NSLog(@"write phist fail");
    }
}


//从磁盘导出下载好的文件信息
- (void)loadFinishedFile
{
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [document stringByAppendingPathComponent:FINISHED_PATH_NAME];
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
            [self.finishArray addObject:file];
        }
    }
}

//存储未下载好的文件信息到沙盒中
- (void)saveunFinishedFile
{
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [document stringByAppendingPathComponent:UNFINISHED_PATH_NAME];
    
    NSMutableArray *finishedInfo = [[NSMutableArray alloc] init];
    for (DownloadFileModel *file in self.unfinishArray) {
        NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:file.fileName,@"filename",file.urlLink,@"urllink",file.targetPath,@"targetpath",file.tempfilePath,@"tempfilepath",file.tempPath,@"temppath",file.fileReceivedSize,@"filerecievesize",nil];
        [finishedInfo addObject:filedic];
    }
    
    if (![finishedInfo writeToFile:plistPath atomically:YES]) {
        NSLog(@"write phist fail");
    }
}

//从磁盘导出未下载好的文件信息
- (void)loadunFinishedFile
{
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [document stringByAppendingPathComponent:UNFINISHED_PATH_NAME];
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
            file.fileInfo = [dic objectForKey:@"fileinfo"];
            file.isDownloading = NO;
            file.willDownloading = NO;
            NSString *identify = [self getIdentify:file.fileName];
            [RemindView showViewWithTitle:[self getIdentify:file.fileName] location:TOP];
            [self.fileDic setObject:file forKey:identify];
            [_unfinishArray addObject:file];
            
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (DownloadFileModel *fileModel in _finishArray) {
        if ([file.fileName isEqualToString:fileModel.fileName]) {
            if ([fileManager fileExistsAtPath:file.targetPath]) {
                [fileManager removeItemAtPath:file.targetPath error:nil];
                [_finishArray removeObject:fileModel];
                [_fileDic removeObjectForKey:[self getIdentify:fileModel.fileName]];
            }
        }
    }
}


- (void)cancelDownloads:(NSArray *)arr
{
    for (DownloadFileModel *fileModel in arr) {
        [self cancelDownload:fileModel];
    }
}


- (unsigned long long)fileSizeForPath:(NSString *)path {
    
    signed long long fileSize = 0;
    
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSError *error = nil;
        
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        
        if (!error && fileDict) {
            
            fileSize = [fileDict fileSize];
            
        }
    }
    return fileSize;
}

- (NSString *)getFileNameForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    if (str == NULL)
    {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}

- (NSString *)getIdentify:(NSString *)str
{
    return [NSString stringWithFormat:@"com.promo.threeMan.%@",str];
}


@end
