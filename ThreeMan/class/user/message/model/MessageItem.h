//
//  MessageItem.h
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageItem : NSObject

@property (nonatomic,strong) NSString *logo;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *addtime;
@property (nonatomic,strong) NSString *uid;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
