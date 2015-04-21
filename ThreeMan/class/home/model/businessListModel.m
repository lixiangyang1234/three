//
//  businessListModel.m
//  ThreeMan
//
//  Created by YY on 15-4-20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "businessListModel.h"

@implementation businessListModel
-(instancetype)initWithDictonaryForBusinessList:(NSDictionary *)dict{
    if ([super self]) {
        self.businessCompanyname =dict[@"companyname"];
        self.businessId =[dict[@"id"]intValue];
        self.businessIntroduce =dict[@"introduce"];
        self.businessLogo =dict[@"logo"];
        self.businessScorenums =[dict[@"scorenums"]intValue];

    }
    return self;
}
@end
