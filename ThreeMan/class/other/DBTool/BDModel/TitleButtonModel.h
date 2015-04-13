//
//  TitleButtonModel.h
//  ThreeMan
//
//  Created by apple on 15/4/12.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TitleButtonModel : NSManagedObject

@property (nonatomic, retain) NSString * t_tag;
@property (nonatomic, retain) NSString * t_title;
@property (nonatomic, retain) NSString * c_tag;
@property (nonatomic, retain) NSString * c_title;
@property (nonatomic, retain) NSNumber * t_isselected;

@end
