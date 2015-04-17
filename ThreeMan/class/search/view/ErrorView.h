//
//  ErrorView.h
//  ThreeMan
//
//  Created by tianj on 15/4/17.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *errorLabel;

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title;

@end
