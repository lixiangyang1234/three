//
//  CourseEightCell.m
//  ThreeMan
//
//  Created by YY on 15-3-24.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "CourseEightCell.h"
#define YYBorderX 10
#define YYBorderY 10
@implementation CourseEightCell

@synthesize courseImage,courseReding,courseTitle;

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        courseImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBorderX, YYBorderY, 80, 60)];
        [self addSubview:courseImage];
        courseImage.backgroundColor =[UIColor redColor];
        
        courseTitle =[[UILabel alloc]initWithFrame:CGRectMake(YYBorderX*2+80, YYBorderY, kWidth-YYBorderX*2-80, 30)];
        courseTitle.backgroundColor =[UIColor clearColor];
        courseTitle.text =@"O(∩_∩)O哈哈哈~";
        [self addSubview:courseTitle];
        courseTitle.numberOfLines =2;
        courseTitle.font =[UIFont systemFontOfSize:20];
        
        courseReding =[[UILabel alloc]initWithFrame:CGRectMake(YYBorderX*2+80, YYBorderY*2+30, kWidth-YYBorderX*2-80, 30)];
        courseReding.backgroundColor =[UIColor clearColor];
        courseReding.text =@"浏览量：100";
        [self addSubview:courseReding];
        courseReding.font =[UIFont systemFontOfSize:12];
        
        
        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
