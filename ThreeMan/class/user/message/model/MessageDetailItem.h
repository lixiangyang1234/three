//
//  DetailItem.h
//  ThreeMan
//
//  Created by tianj on 15/4/16.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDetailItem : NSObject

@property (nonatomic,strong) NSString *addtime;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *title;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
