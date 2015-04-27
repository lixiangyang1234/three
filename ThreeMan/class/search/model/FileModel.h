//
//  FileModel.h
//  ThreeMan
//
//  Created by tianj on 15/4/27.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *title;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
