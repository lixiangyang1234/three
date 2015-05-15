//
//  RemindView.m
//  PEM
//
//  Created by tianj on 14-9-18.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "RemindView.h"
#import "AdaptationSize.h"

#define titleFont [UIFont systemFontOfSize:13]

@implementation RemindView

+ (void)showViewWithTitle:(NSString *)title location:(LocationType)location
{
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    CGSize size = [AdaptationSize getSizeFromString:title Font:titleFont withHight:25 withWidth:CGFLOAT_MAX];
    remindLabel.frame = CGRectMake(0, 0, size.width+15,30);
    
    if (size.width+15>kWidth-40) {
        size = [AdaptationSize getSizeFromString:title Font:titleFont withHight:CGFLOAT_MAX withWidth:kWidth-40];
        remindLabel.frame = CGRectMake(0, 0, size.width+15,size.height+10);
        remindLabel.numberOfLines = 0;
    }
    
    remindLabel.text = title;
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.font = titleFont;
    remindLabel.backgroundColor = [UIColor blackColor];
    remindLabel.textColor = [UIColor whiteColor];
    
    CGPoint center = CGPointMake(kWidth/2, kHeight-remindLabel.frame.size.height/2-50);
    if (location == TOP) {
        center = CGPointMake(kWidth/2,69+remindLabel.frame.size.height/2);
    }
    if (location == MIDDLE) {
        center = CGPointMake(kWidth/2, kHeight/2);
    }
    remindLabel.center = center;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:remindLabel];
    
    [UIView animateWithDuration:3 animations:^{
        remindLabel.alpha = 0;
    }];
}



@end
