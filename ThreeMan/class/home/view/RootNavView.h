//
//  RootNavView.h
//  ThreeMan
//
//  Created by YY on 15-3-27.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootNavViewDelegate;
@protocol RootNavViewDelegate <NSObject>

-(void)rootNavItemClick:(UIButton *)item withItemTag:(NSInteger)itemTag;

@end
@interface RootNavView : UIView
{
    
}
@property(nonatomic,assign)NSInteger itemType;
@property(nonatomic,unsafe_unretained)id<RootNavViewDelegate> Rootdelegate;

-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withType:(NSInteger)type  ;
@end
