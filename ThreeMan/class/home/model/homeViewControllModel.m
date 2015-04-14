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
        self.courseImgurl =dict[@"imgurl"];
        self.courseName =dict[@"name"];
//        NSLog(@"sssss%@",self.courseImgurl);
    }
    return self;
}
-(instancetype)initWithDictionaryForHomeCategory:(NSDictionary *)dict{
    if ([super self]) {
        self.categoryImgurl =dict[@"imgurl"];
        self.categoryName =dict[@"title"];
        self.categorySubTitle =dict[@"mark"];
                NSLog(@"sssss%@",self.categorySubTitle);
    }
    return self;
}
-(instancetype)initWithDictionaryForHomeTrade:(NSDictionary *)dict{
    if ([super self]) {
        self.tradeImgurl =dict[@"imgurl"];
        self.tradeName =dict[@"title"];
        self.tradeSubTitle =dict[@"mark"];

        //        NSLog(@"sssss%@",self.courseImgurl);
    }
    return self;
}
@end
