//
//  AccountItem.h
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountItem : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *companyname;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSString *type;

- (BOOL)isPayout;


@end
