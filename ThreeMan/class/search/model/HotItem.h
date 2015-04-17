//
//  HotItem.h
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotItem : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *keywords;
@property (nonatomic,copy) NSString *sort;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
