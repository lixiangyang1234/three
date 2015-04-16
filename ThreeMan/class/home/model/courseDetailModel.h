//
//  courseDetailModel.h
//  ThreeMan
//
//  Created by YY on 15-4-16.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface courseDetailModel : NSObject
@property(nonatomic,copy)NSString *courseCompanyname;
@property(nonatomic,copy)NSString *courseContent;
@property(nonatomic,assign)int courseDownloadnum;
@property(nonatomic,assign)int courseId;
@property(nonatomic,copy)NSString *courseImgurl;
@property(nonatomic,assign)int courseNum;
@property(nonatomic,copy)NSString *courseTitle;
-(instancetype)initWithDictnoaryForCourseDetail:(NSDictionary *)dict;
@end
