//
//  homeViewArrayModel.h
//  ThreeMan
//
//  Created by YY on 15-4-10.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeViewArrayModel : NSObject
@property(nonatomic,strong)NSArray *ads;//广告条
@property(nonatomic,strong)NSArray *course;//八大课程
@property(nonatomic,strong)NSArray *trade;//按行业
@property(nonatomic,strong)NSArray *category;//按需求

-(id)initWithForHomeArray:(NSDictionary *)dict;

@end
