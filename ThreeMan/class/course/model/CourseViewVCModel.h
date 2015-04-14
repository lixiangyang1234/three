//
//  CourseViewVCModel.h
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseViewVCModel : NSObject
@property(nonatomic,strong)NSString *description;//三身行图片
@property(nonatomic,strong)NSString *imgurl;//三身行标题
@property(nonatomic,strong)NSString *title;//三身行内容
@property(nonatomic,strong)NSString *courseID;//三身行ID;

@property(nonatomic,strong)NSString *detailContent;
@property(nonatomic,strong)NSString *detailDescription;
@property(nonatomic,strong)NSString *detaileImgurl;
@property(nonatomic,strong)NSString *detailTitle;


- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(instancetype)initWithDictionaryForCourseDetail:(NSDictionary *)dict;

@end
