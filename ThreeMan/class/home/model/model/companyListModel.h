//
//  companyListModel.h
//  ThreeMan
//
//  Created by YY on 15-4-20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface companyListModel : NSObject
@property(nonatomic,copy)NSString *companyCompanyname;
@property(nonatomic,copy)NSString *companyLogo;
@property(nonatomic,copy)NSString *companyIntroduce;
@property(nonatomic,assign)int iscollect;

@property(nonatomic,copy)NSString *companyImgurl;
@property(nonatomic,copy)NSString *companyTitle;
@property(nonatomic,assign)int companyId;
@property(nonatomic,assign)int companyPrice;
@property(nonatomic,assign)int companyDownloadnum;
@property(nonatomic,assign)int companyType;


-(instancetype)initWithDictonaryForCompany_info:(NSDictionary *)dict;

-(instancetype)initWithDictonaryForCompanyList:(NSDictionary *)dict;
@end
