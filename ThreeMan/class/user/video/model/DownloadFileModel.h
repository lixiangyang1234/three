//
//  DownloadFileModel.h
//  DownloadManager
//
//  Created by tianj on 15/4/30.
//  Copyright (c) 2015年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFileModel : NSObject

@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,copy) NSString *fileReceivedSize;
@property (nonatomic,copy) NSString *totalSize;
@property (nonatomic,strong) NSData *resumeData;
@property (nonatomic,copy) NSString *urlLink;
@property (nonatomic,copy) NSString *targetPath;
@property (nonatomic,copy) NSString *tempPath;
@property (nonatomic,copy) NSString *tempfilePath;
@property (nonatomic,assign) BOOL isDownloading;
@property (nonatomic,assign) BOOL willDownloading;

@property (nonatomic,strong) NSDictionary *fileInfo;

@end
