//
//  nineBlockModel.h
//  ThreeMan
//
//  Created by YY on 15-4-15.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface nineBlockModel : NSObject
@property(nonatomic,copy)NSString *nineTitle;
@property(nonatomic,assign)id nineTopid;
@property(nonatomic,assign)id nineID;
-(instancetype)initWithDictonaryForNineBlock:(NSDictionary *)dict;
@end
