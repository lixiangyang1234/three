//
//  companyListModel.m
//  ThreeMan
//
//  Created by YY on 15-4-20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "companyListModel.h"

@implementation companyListModel
-(instancetype)initWithDictonaryForCompany_info:(NSDictionary *)dict{
    if ([super self]) {
        self.companyCompanyname =dict[@"companyname"];
        self.companyIntroduce =dict[@"introduce"];
        self.companyLogo=dict[@"logo"];
        self.iscollect=[dict[@"iscollect"]intValue];
    }
    return self;
}

-(instancetype)initWithDictonaryForCompanyList:(NSDictionary *)dict{
    if ([super self]) {
        self.companyId =[dict[@"id"]intValue];
        self.companyDownloadnum =[dict[@"downloadnum"]intValue];

        self.companyPrice =[dict[@"price"]intValue];
        self.companyType =[dict[@"type"]intValue];
        self.companyTitle=dict[@"title"];
        self.companyImgurl =dict[@"imgurl"];
    }
    return self;
}
@end
