//
//  FileItem.h
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileItem : NSObject

@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *uid;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
