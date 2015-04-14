//
//  EnterpriseItem.h
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterpriseItem : NSObject

@property (nonatomic,strong) NSString *logo;
@property (nonatomic,strong) NSString *companyname;
@property (nonatomic,strong) NSString *scorenums;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSString *uid;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
