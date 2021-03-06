//
//  SystemConfig.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface SystemConfig : NSObject

@property (nonatomic,copy) NSString *uuidStr;        //设备uuid
@property (nonatomic,assign) BOOL isUserLogin;       //是否登录
@property (nonatomic,copy) NSString *uid;    //登录后的公司ID
@property (nonatomic,strong) UserInfo *userInfo;  //用户信息

+ (SystemConfig *)sharedInstance;

@end
