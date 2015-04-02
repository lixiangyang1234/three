//
//  RootNavView.m
//  ThreeMan
//
//  Created by YY on 15-3-27.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RootNavView.h"
#define NAVHEIGHT 7
#define ITEMTAG   200
@implementation RootNavView
-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withType:(NSInteger)type{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        self.itemType =type;
//        NSLog(@"%d-3333--->%d",self.itemType,type);
        if (self.itemType==1) {
            //    添加左边
            UIButton * titleItem =[UIButton buttonWithType:UIButtonTypeCustom];
            titleItem.frame =CGRectMake(-5, NAVHEIGHT, 150, 30);
            titleItem. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
            [titleItem setTitle:title forState:UIControlStateNormal];
            [titleItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleItem.titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
            titleItem.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            titleItem.backgroundColor =[UIColor clearColor];
            [self addSubview:titleItem];
//            NSLog(@"%d---1111->%d",self.itemType,type);

            //    添加右边
            
            UIButton * searchItem =[UIButton buttonWithType:UIButtonTypeCustom];
            searchItem.frame =CGRectMake(kWidth-150, NAVHEIGHT, 30, 30);
            [searchItem setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
            [searchItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
            searchItem.backgroundColor =[UIColor clearColor];
            searchItem.tag =ITEMTAG+1;

            [self addSubview:searchItem];
            
            UIButton * menuItem =[UIButton buttonWithType:UIButtonTypeCustom];
            menuItem.frame =CGRectMake(searchItem.frame.origin.x+10+searchItem.frame.size.width, NAVHEIGHT, 30, 30);
            [menuItem setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
            [self addSubview:menuItem];
            [menuItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
            menuItem.backgroundColor =[UIColor clearColor];
            menuItem.tag =ITEMTAG +2;


        }else{
//            NSLog(@"%d---22222->%d",self.itemType,type);

            //    添加左边
            UIButton * titleItem =[UIButton buttonWithType:UIButtonTypeCustom];
            titleItem.frame =CGRectMake(-15, NAVHEIGHT, 150, 30);
            titleItem. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
            [titleItem setTitle:title forState:UIControlStateNormal];
            [titleItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleItem.titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
            titleItem.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            titleItem.backgroundColor =[UIColor clearColor];
            [self addSubview:titleItem];
            
            
            //    添加右边
            UIButton * collectItem =[UIButton buttonWithType:UIButtonTypeCustom];
            collectItem.frame =CGRectMake(kWidth-190, NAVHEIGHT, 30, 30);
            [collectItem setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
            [collectItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
            collectItem.backgroundColor =[UIColor clearColor];
            collectItem.tag =ITEMTAG+0;
            [self addSubview:collectItem];

            
            UIButton * searchItem =[UIButton buttonWithType:UIButtonTypeCustom];
            searchItem.frame =CGRectMake(kWidth-150, NAVHEIGHT, 30, 30);
            [searchItem setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
            [searchItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
            searchItem.backgroundColor =[UIColor clearColor];
            searchItem.tag =ITEMTAG+1;
            [self addSubview:searchItem];
            
            UIButton * menuItem =[UIButton buttonWithType:UIButtonTypeCustom];
            menuItem.frame =CGRectMake(searchItem.frame.origin.x+10+searchItem.frame.size.width, NAVHEIGHT, 30, 30);
            [menuItem setImage:[UIImage imageNamed:@"img.png"] forState:UIControlStateNormal];
            [self addSubview:menuItem];
            [menuItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
            menuItem.backgroundColor =[UIColor clearColor];
            menuItem.tag =ITEMTAG +2;

        }
       
        

    }
    return self;
}
-(void)navItemRight:(UIButton *)item{
    NSLog(@"-----111111aaaaa%d",item.tag);
    if ( [self.Rootdelegate respondsToSelector:@selector(rootNavItemClick:withItemTag:)]) {
        [self.Rootdelegate rootNavItemClick:item withItemTag:item.tag];
        
    }
   
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
