//
//  PatternItem.h
//  ThreeMan
//
//  Created by tianj on 15/3/31.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatternItem : NSObject

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *imgurl;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *number;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
