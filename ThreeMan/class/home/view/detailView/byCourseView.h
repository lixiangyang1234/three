//
//  byCourseView.h
//  ThreeMan
//
//  Created by YY on 15-4-13.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class byCourseViewDelegate;
@protocol byCourseViewDelegate<NSObject>

-(void)chooseBtn:(UIButton *)choose chooseTag:(NSInteger)tag;

@end
@interface byCourseView : UIView
@property(nonatomic,unsafe_unretained)id<byCourseViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame byTitle:(NSString *)title contentLabel:(NSString *)content buttonTitle:(NSArray *)butTitle TagType:(int)type;
@end
