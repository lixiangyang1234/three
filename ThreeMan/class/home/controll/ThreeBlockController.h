//
//  ThreeBlockController.h
//  ThreeMan
//
//  Created by YY on 15-4-1.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeBlockController : LeftTitleController
@property(nonatomic,strong)NSString *navTitle;
@property(nonatomic,strong)NSString *threeId;
@property(nonatomic,strong)NSMutableArray *threeArray;
@property(nonatomic,strong)NSMutableArray *threeListArray;

@property(nonatomic,strong)NSMutableArray *categoryArray;

@property(nonatomic,strong)UIButton *selectedIntem;
@end
