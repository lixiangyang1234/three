//
//  threeBlockModel.m
//  ThreeMan
//
//  Created by YY on 15-4-20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "threeBlockModel.h"

@implementation threeBlockModel
-(instancetype)initWithForArray:(NSDictionary *)dict{
    if ([super self]) {
        self.subcategory =dict[@"subcategory"];
        self.subject_list =dict[@"subject_list"];
        self.categoryid =[dict[@"id"]intValue];
        self.categoryTitle =dict[@"title"];
    }
    return self;
}

-(instancetype)initWithForCategory:(NSDictionary *)dict{
    if ([super self]) {
        self.cateid =[dict[@"id"]intValue];
        self.cateTitle =dict[@"title"];
    }
    return self;
}

-(instancetype)initWithForThreeList:(NSDictionary *)dict{
    if ([super self]) {
        self.threeId =[dict[@"id"]intValue];
        self.threeHits =[dict[@"hits"]intValue];
        self.threeType =[dict[@"type"]intValue];
        self.threeTitle =dict[@"title"];
        self.threeImgurl =dict[@"imgurl"];
        self.threeCompanyname =dict[@"companyname"];

    }
    return self;
}

@end
