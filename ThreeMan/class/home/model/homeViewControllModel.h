//
//  homeViewControllModel.h
//  ThreeMan
//
//  Created by YY on 15-4-10.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeViewControllModel : NSObject
@property(nonatomic,strong)NSString *imgurl;//广告条图片

@property(nonatomic,strong)NSString *courseImgurl;//课程图片
@property(nonatomic,strong)NSString *courseName;//课程图片

@property(nonatomic,strong)NSString *tradeImgurl;//行业图片
@property(nonatomic,strong)NSString *tradeName;//行业标题
@property(nonatomic,strong)NSString *tradeSubTitle;//行业小标题



@property(nonatomic,strong)NSString *categoryImgurl;//需求图片
@property(nonatomic,strong)NSString *categoryName;//需求图片
@property(nonatomic,strong)NSString *categorySubTitle;//需求小标题


//广告
- (instancetype)initWithDictionaryForHomeAds:(NSDictionary *)dict;//
//课程
-(instancetype)initWithDictionaryForHomeCourse:(NSDictionary *)dict;
//需求
-(instancetype)initWithDictionaryForHomeCategory:(NSDictionary *)dict;

//行业
-(instancetype)initWithDictionaryForHomeTrade:(NSDictionary *)dict;

@end
