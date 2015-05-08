//
//  AuthencateTool.m
//  XinNet
//
//  Created by tianj on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "AuthencateTool.h"

@implementation AuthencateTool


//判断邮箱格式是否正确
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}


//号码验证
+ (BOOL)isValidPhone:(NSString *)phoneNum{
    NSString *phoneRegex  =  @"^((13[0-9])|(14[0,0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
}



@end
