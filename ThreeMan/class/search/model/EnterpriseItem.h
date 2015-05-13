//
//  EnterpriseItem.h
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterpriseItem : NSObject

@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *companyname;
@property (nonatomic,copy) NSString *scorenums;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *cid;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
