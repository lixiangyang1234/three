//
//  NeedCollectionViewCell.h
//  ThreeMan
//
//  Created by YY on 15-3-23.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet UIImageView *needImage;
@property (weak, nonatomic) IBOutlet UILabel *needTitle;

@end
