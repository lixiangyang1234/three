//
//  AliPayTool.h
//  Manicure
//
//  Created by tianj on 15/1/21.
//  Copyright (c) 2015年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartnerConfig.h"
#import "DataSigner.h"

@interface AliPayTool : NSObject

+(NSString*)doRsa:(NSString*)orderInfo;

//获取订单号
+ (NSString *)generateTradeNO;


@end
