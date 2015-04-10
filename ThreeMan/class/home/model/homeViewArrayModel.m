//
//  homeViewArrayModel.m
//  ThreeMan
//
//  Created by YY on 15-4-10.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "homeViewArrayModel.h"

@implementation homeViewArrayModel
@synthesize ads,course,trade,category;
-(id)initWithForHomeArray:(NSDictionary *)dict
{
    if (self =[super init]) {
        ads =dict[@"ads"];
        course =dict[@"course"];
         trade=dict[@"trade"];
        category =dict[@"category"];

    }
    return self;
}
@end
