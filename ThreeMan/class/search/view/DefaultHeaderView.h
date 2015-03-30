//
//  DefaultHeaderView.h
//  ThreeMan
//
//  Created by tianj on 15/3/30.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultHeaderView : UIView

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;

- (void)setImgView:(UIImage *)image title:(NSString *)title;


@end
