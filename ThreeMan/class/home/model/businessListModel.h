//
//  businessListModel.h
//  ThreeMan
//
//  Created by YY on 15-4-20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface businessListModel : NSObject
@property(nonatomic,copy)NSString *businessCompanyname;
@property(nonatomic,copy)NSString *businessIntroduce;
@property(nonatomic,assign)int businessId;
@property(nonatomic,assign)int businessScorenums;
@property(nonatomic,copy)NSString *businessLogo;
-(instancetype)initWithDictonaryForBusinessList:(NSDictionary *)dict;
@end
