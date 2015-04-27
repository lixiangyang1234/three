//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088811275152442"
//收款支付宝账号
#define SellerID  @"wjdzsw188@163.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL8QSJ0C25QLHm1bahAcHO7MgfHldVb7NzUtkIG3fI6FncilbmXWz+oL+MYePs9AoyScsOtwR09nZ/rz5mHOp/hf4ZaLmihASaRgUR/xyHix3WoeJybhA1NSpP/pcUalbpgNsYjOhahqDdBeuCYSuWApBEI88ajs1gCcISt2fk2dAgMBAAECgYEAivvUZmqiwdFIw/IAeFGK9mbLi+QHdEtvwH4xpTqNH7uwqDk20lvtiGpHAA8WT3rMciCNTeax6N/mspVjG/jRE8aVBOr7ZPeKee/wjwMBY8fuP8Rb37p2t/KgTLcbkeFW3+ebc2iSHi5vXoYPQXIVrnfZ7KCdoV0rOfzRDgUN8b0CQQD6yyQH50UJu0c42td89+rS3vm6NLaUsamVipxcr6HiSmOEATniSbxqycNvcr+O04+v/8j9maiEjYd8Y2iDKCr3AkEAwwe0R6EUyHyPXxH6h8ovxbZROxxZsx+mmy4UGYhYvwjl3FGt9v4YD0gE5MILUkzsrDOPUfyZsVOvR4QYSeTzCwJAU+DjQR1xcqrHTFWtIqfMSxC2VzfQJPUyscg1Oa6oJwYYOIssb+mXcePfUIQBW2SYtxWGhIMC4KpxOQIKb2tcywJAJ7sfD+SR3lH5xy1bc2ROHSIKJFefMm2FPGHDuHvdUHWYliyRmxqifiJ21L9vHQIMyPvr+5DRIp3gvFn9tLgOhwJAAJvDAMtsk2ArKWQe+P302mbm4JVgyaXqKC4T5f7ipgTHqS4Ikqc4zWZMv1Y8NVYlyL8LBty86qi/RGm2hf3b0A=="


//支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
