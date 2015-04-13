//
//  CourseViewVCModel.h
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseViewVCModel : NSObject
@property(nonatomic,strong)NSString *courseHeaderImage;//三身行图片
@property(nonatomic,strong)NSString *courseTitle;//三身行标题
@property(nonatomic,strong)NSString *courseContent;//三身行内容
@property(nonatomic,assign)int *courseID;//三身行ID;

-(instancetype)initWithDictionaryForCourse:(NSDictionary *)dict;
@end
