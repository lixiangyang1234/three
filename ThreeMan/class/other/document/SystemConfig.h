//
//  SystemConfig.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CompanyInfoItem.h"
//#import "MySupplyItem.h"
//#import "MyPurchaseItem.h"
//#import "VipInfoItem.h"

@interface SystemConfig : NSObject

@property (nonatomic,copy) NSString *uuidStr;        //设备uuid
@property (nonatomic,assign) BOOL isUserLogin;       //是否登录
@property (nonatomic,copy) NSString *viptype;       //会员类型
@property (nonatomic,copy) NSString *company_id;    //登录后的公司ID
//@property (nonatomic,strong) CompanyInfoItem *companyInfo;    //登录用户公司基本信息
//@property (nonatomic,strong) VipInfoItem *vipInfo;   //vip用户相关信息
//@property (nonatomic,assign) long maxTagNum;        //用户可订阅的最大标签数

+ (SystemConfig *)sharedInstance;

@end
