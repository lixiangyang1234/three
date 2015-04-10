//
//  RecordItem.h
//  ThreeMan
//
//  Created by tianj on 15/4/9.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordItem : NSObject

@property (nonatomic,assign) int uid;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *date;

@end
