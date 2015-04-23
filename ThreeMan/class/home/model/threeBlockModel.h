//
//  threeBlockModel.h
//  ThreeMan
//
//  Created by YY on 15-4-20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface threeBlockModel : NSObject
@property(nonatomic,strong)NSArray *subcategory;//分类
@property(nonatomic,strong)NSArray *subject_list;//列表数据

@property(nonatomic,copy)NSString *cateTitle;
@property(nonatomic,assign)int cateid;

@property(nonatomic,copy)NSString *categoryTitle;
@property(nonatomic,assign)int categoryid;
@property(nonatomic,copy)NSString *threeCompanyname;
@property(nonatomic,copy)NSString *threeTitle;
@property(nonatomic,assign)int threeHits;
@property(nonatomic,copy)NSString *threeImgurl;
@property(nonatomic,assign)int threeId;
@property(nonatomic,assign)int threeType;

-(instancetype)initWithForArray:(NSDictionary *)dict;
-(instancetype)initWithForCategory:(NSDictionary *)dict;

-(instancetype)initWithForThreeList:(NSDictionary *)dict;

@end
