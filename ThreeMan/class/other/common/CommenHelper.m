//
//  CommenHelper.m
//  ThreeMan
//
//  Created by tianj on 15/4/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CommenHelper.h"
#import <sys/mount.h>

@implementation CommenHelper

//获取设备可用存储空间大小
+ (double)avaibleMemory
{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_ffree;
    }
    return freespace/1024.0/1024.0/1024.0 ;
}

//获取设备总存储空间大小
+ (double)totalMemory
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace/1024.0/1024.0/1024.0 ;

}


@end
