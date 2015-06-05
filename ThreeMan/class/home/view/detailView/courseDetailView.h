//
//  courseDetailView.h
//  ThreeMan
//
//  Created by YY on 15/6/4.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "courseDetailModel.h"
@protocol courseDetailViewDelegate <NSObject>

-(void)companyHome;

@end
@interface courseDetailView : UIScrollView <UIWebViewDelegate>
@property(nonatomic,unsafe_unretained)id <courseDetailViewDelegate> scroll;
-(id)initWithFrame:(CGRect)frame statusLoad:(courseDetailModel *)courseModel;

@end
