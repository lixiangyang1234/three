//
//  NetFailView.h
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetFailView : UIView
-(id)initWithFrame:(CGRect)frame backImage:(UIImage *)img promptTitle:(NSString *)title;
-(id)initWithFrameForDetail:(CGRect)frame backImage:(UIImage *)img promptTitle:(NSString *)title;

@end
