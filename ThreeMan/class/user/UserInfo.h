//
//  UserItem.h
//  ThreeMan
//
//  Created by tianj on 15/4/14.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *username;
//@property (nonatomic,assign) bool downloadType; //是否Wi-Fi下载

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
