//
//  EditView.h
//  ThreeMan
//
//  Created by tianj on 15/4/3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditView;
@protocol EditViewDelegate <NSObject>

@optional

- (void)btnClicked:(UIButton *)btn view:(EditView *)view;

@end

@interface EditView : UIView
@property (nonatomic,assign) id <EditViewDelegate> delegate;


@end
