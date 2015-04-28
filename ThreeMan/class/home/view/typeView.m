//
//  typeView.m
//  ThreeMan
//
//  Created by YY on 15-4-20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "typeView.h"

@implementation typeView

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)typeID:(int)type
{
    if (type ==1) {
    self.image =[UIImage imageNamed:@"type_video"];
    }
    if (type ==2) {
        self.image =[UIImage imageNamed:@"type_doc"];
    }if (type ==3) {
        self.image =[UIImage imageNamed:@"type_excel"];
    }if (type ==4) {
        self.image =[UIImage imageNamed:@"type_txt"];
    }if (type ==5) {
        self.image =[UIImage imageNamed:@"type_pdf"];
    }if (type ==6) {
        self.image =[UIImage imageNamed:@"type_ppt"];
    }if (type ==7) {
        self.image =[UIImage imageNamed:@"type_rar"];
    }if (type ==8) {
        self.image =[UIImage imageNamed:@"type_zip"];
    }
}
@end
