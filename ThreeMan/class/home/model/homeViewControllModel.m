//
//  homeViewControllModel.m
//  ThreeMan
//
//  Created by YY on 15-4-10.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "homeViewControllModel.h"

@implementation homeViewControllModel
@synthesize imgurl,courseImgurl,courseName,tradeImgurl,tradeName,categoryImgurl,categoryName,tradeSubTitle,categorySubTitle;
- (instancetype)initWithDictionaryForHomeAds:(NSDictionary *)dict{
    if ([super self]) {
        self.imgurl =dict[@"imgurl"];
    }
    return self;
}
-(instancetype)initWithDictionaryForHomeCourse:(NSDictionary *)dict{
    if ([super self]) {
        self.courseImgurl =dict[@"icon"];
        self.courseName =dict[@"name"];
        self.courseId =[dict[@"id"]intValue];
    
//        NSLog(@"sssss%@",self.courseImgurl);
    }
    
    return self;
}
-(instancetype)initWithDictionaryForHomeCategory:(NSDictionary *)dict{
    if ([super self]) {
        self.categoryImgurl =dict[@"imgurl"];
        self.categoryName =dict[@"title"];
        self.categorySubTitle =dict[@"mark"];
        self.categoryId =[dict[@"id"]intValue];

    }
    return self;
}
-(instancetype)initWithDictionaryForHomeTrade:(NSDictionary *)dict{
    if ([super self]) {
        self.tradeImgurl =dict[@"imgurl"];
        self.tradeName =dict[@"title"];
        self.tradeSubTitle =dict[@"mark"];
        self.tradeId =[dict[@"id"]intValue];


        //        NSLog(@"sssss%@",self.courseImgurl);
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeObject:self.imgurl forKey:@"imgurl1"];

    [coder encodeObject:self.courseImgurl forKey:@"icon"];
    [coder encodeObject:self.courseName forKey:@"name2"];
    
    [coder encodeObject:self.categoryImgurl forKey:@"imgurl3"];
    [coder encodeObject:self.categoryName forKey:@"title3"];
    [coder encodeObject:self.categorySubTitle forKey:@"mark3"];
    
    [coder encodeObject:self.tradeImgurl forKey:@"imgurl4"];
    [coder encodeObject:self.tradeName forKey:@"title4"];
    [coder encodeObject:self.tradeSubTitle forKey:@"mark4"];
}
-(instancetype)initWithCoder:(NSCoder *)decoder{
    self =[super init];
    if (self) {
        self.imgurl =[decoder decodeObjectForKey:@"imgurl1"];
        
        self.courseImgurl =[decoder decodeObjectForKey:@"icon"];
        self.courseName=[decoder decodeObjectForKey:@"name2"];
        
        self.categoryImgurl =[decoder decodeObjectForKey:@"imgurl3"];
        self.categoryName =[decoder decodeObjectForKey:@"title3"];
        self.categorySubTitle =[decoder decodeObjectForKey:@"mark3"];
//
        self.tradeImgurl =[decoder decodeObjectForKey:@"imgurl4"];
        self.tradeName =[decoder decodeObjectForKey:@"title4"];
        self.tradeSubTitle =[decoder decodeObjectForKey:@"mark4"];
    }
    return self;
}
@end
