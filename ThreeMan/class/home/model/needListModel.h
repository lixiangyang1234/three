//
//  needListModel.h
//  ThreeMan
//
//  Created by YY on 15-4-15.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface needListModel : NSObject
@property(nonatomic,copy)NSString *companyname;
@property(nonatomic,copy)NSString * categoryHits;
@property(nonatomic,copy)NSString * categoryId;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString * categoryType;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
