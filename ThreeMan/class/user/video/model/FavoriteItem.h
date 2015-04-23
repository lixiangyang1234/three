//
//  FavoriteItem.h
//  ThreeMan
//
//  Created by tianj on 15/4/3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteItem : NSObject

@property (nonatomic,strong) NSString* uid;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *companyname;
@property (nonatomic,strong) NSString *sid;
@property (nonatomic,strong) NSString *mid;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
