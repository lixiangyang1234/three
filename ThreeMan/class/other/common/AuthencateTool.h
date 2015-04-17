//
//  AuthencateTool.h
//  XinNet
//
//  Created by tianj on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthencateTool : NSObject


//邮箱验证
+(BOOL)isValidateEmail:(NSString *)email;


//手机号码验证
+ (BOOL)isValidPhone:(NSString *)phoneNum;

@end
