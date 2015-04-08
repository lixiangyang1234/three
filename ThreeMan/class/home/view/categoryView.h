//
//  categoryView.h
//  ThreeMan
//
//  Created by YY on 15-4-1.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface categoryView : UIView
@property (nonatomic, strong) NSArray       *titleArray;
@property (nonatomic, strong) NSArray       *categoryArray;
@property (nonatomic) CGPoint               showPoint;

@property (nonatomic, strong) UIButton      *handerView;
@property (nonatomic, strong) UIButton      *titleBtn;
@property (nonatomic, strong) UIButton      *titleBtnSelected;
@property (nonatomic, strong) UIButton      *categoryTitleBtn;
@property (nonatomic, strong) UIButton      *categoryTitleBtnSelected;

@property (nonatomic, copy) UIColor         *borderColor;
@property(nonatomic,strong)UIButton *selectedIndex;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles categoryTitles:(NSArray *)category  ;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;
@end