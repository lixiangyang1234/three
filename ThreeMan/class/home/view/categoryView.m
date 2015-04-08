//
//  TYPopoverView.m
//  ZSEL
//
//  Created by apple on 14-11-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "categoryView.h"

#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define SPACE 2.f
#define ROW_HEIGHT 44
#define TITLE_FONT [UIFont systemFontOfSize:14]


@implementation categoryView

{
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.borderColor =HexRGB(0xeaebec);
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles categoryTitles:(NSArray *)category
{
    self = [super init];
    if (self)
    {
        self.showPoint = point;
        self.titleArray = titles;
        self.categoryArray = category;
        
        self.frame = [self getViewFrame];
        [self addSubview:self.titleBtn];
        
    }
    return self;
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    
   
    frame.size.height = [self.titleArray count] * ROW_HEIGHT + SPACE + kArrowHeight;

    
    
    for (NSString *title in self.titleArray)
    {
        CGFloat width =  kWidth-140;
        
        
        
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([self.titleArray count] != [self.categoryArray count])
    {
        frame.size.width = 10 + 25 + 10 + frame.size.width + 90;
    }
    else
    {
        frame.size.width = 10 + frame.size.width + 90;
    }
    
    frame.origin.x = self.showPoint.x - frame.size.width/2;
    frame.origin.y = self.showPoint.y;
    
    //左间隔最小5x
    if (frame.origin.x < 5)
    {
        frame.origin.x = 5;
    }
    //右间隔最小5x
    if ((frame.origin.x + frame.size.width) > kWidth-5)
    {
        frame.origin.x = kWidth-5 - frame.size.width;
    }
    
    return frame;
}


-(void)show
{
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self getViewFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismiss
{
    [self dismiss:YES];
    
}

-(void)dismiss:(BOOL)animate
{
    if (!animate)
    {
        [_handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
    
}


#pragma mark -UIButton

-(UIButton *)titleBtn
{
    if (_titleBtn != nil)
    {
        return _titleBtn;
    }
    
    UIView *viewLine =[[UIView alloc]init];
    viewLine.frame=CGRectMake(0, 20, kHeight, kHeight);
    [self addSubview:viewLine];
    viewLine.backgroundColor =HexRGB(0xeaebec);
    viewLine.backgroundColor =[UIColor blackColor];
    viewLine.alpha =.6;
    
    for (int i=0; i<4; i++) {
        
        self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleBtn.frame=CGRectMake(0, 54+i%4*(44)-43, kWidth, 44);
        
        [self.titleBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        self.selectedIndex =self.titleBtn;

//        self.titleBtn.selected =YES;
        [self.titleBtn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [self.titleBtn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.titleBtn];
        self.titleBtn.tag =100+i;
        self.titleBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        if (i==0) {
            UIImageView *jiaoLine =[[UIImageView alloc]initWithFrame:CGRectMake(-10, -8, kWidth+10, 20)];
            [self.titleBtn addSubview:jiaoLine];
            jiaoLine.image =[UIImage imageNamed:@"jiaoLine"];
            jiaoLine.backgroundColor =[UIColor whiteColor];
            [self.titleBtn setTitleColor:HexRGB(0x178ac5) forState:UIControlStateNormal];

            self.titleBtnSelected =self.titleBtn;
        }
        if (i==1) {
            self.titleBtn.frame=CGRectMake(0, 54+i%5*(44)-43, kWidth, 44);
            [self.titleBtn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.titleBtn setImage:[UIImage imageNamed:@"lower"] forState:UIControlStateNormal];
            [self.titleBtn setImage:[UIImage imageNamed:@"lower_rep"] forState:UIControlStateSelected];
            self.titleBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 150, 0, 10);
        }else {
            [self.titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        UIView *viewLine =[[UIView alloc]init];
        viewLine.frame=CGRectMake(0, 43, kWidth, 1);
        [self.titleBtn addSubview:viewLine];
        viewLine.backgroundColor =HexRGB(0xeaebec);
//          viewLine.backgroundColor =[UIColor redColor];
        
    }
       return _titleBtn;
}
-(void)categoryBtnClick:(UIButton *)btn{
    [btn setTitleColor:HexRGB(0x178ac5) forState:UIControlStateNormal];
    btn.selected=YES;
    for (int i=0; i<7; i++) {
        
        self.categoryTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.categoryTitleBtn setTitleColor:HexRGB(0x178ac5) forState:UIControlStateSelected];

        [self.categoryTitleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.categoryTitleBtn.frame=CGRectMake(210, 55+i%7*(44)-43, 150, 44);
        if (i==4||i==5||i==6||i==7) {
            self.categoryTitleBtn.frame=CGRectMake(0, 54+i%8*(44)-43, kWidth, 44);
            self.categoryTitleBtn.titleEdgeInsets =UIEdgeInsetsMake(0, kWidth-110, 0, 20);

        }


        [self.categoryTitleBtn setTitle:[self.categoryArray objectAtIndex:i] forState:UIControlStateNormal];
        [self.categoryTitleBtn setBackgroundColor:[UIColor whiteColor]];
        [self.categoryTitleBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        
        self.categoryTitleBtn.tag =10+i;
        self.categoryTitleBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        
        
        UIView *viewLine =[[UIView alloc]init];
        viewLine.frame=CGRectMake(0, 42, kWidth, 1);
        [self.categoryTitleBtn addSubview:viewLine];
        viewLine.backgroundColor =HexRGB(0xeaebec);
//        viewLine.backgroundColor =[UIColor redColor];
        [self addSubview:self.categoryTitleBtn];
        self.frame =[self getViewFrameCategory];

    }

}
-(void)titleBtnClick:(UIButton *)index{
    
    index.selected = YES;
//    NSLog(@"%d----%d",self.titleBtnSelected.tag,self.titleBtn.tag);
//    self.selectedIndex =index;
//    if (self.titleBtnSelected.tag!=index.tag) {
//        
//        [self.titleBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
//        [index setTitleColor:HexRGB(0x178ac5) forState:UIControlStateNormal];
//        self.titleBtnSelected.tag =index.tag;
//        
//    }
    
    if (self.selectRowAtIndex)
    {
        
        
        self.selectRowAtIndex(index.tag);
    }
    [self dismiss:YES];
    
}
#pragma mark - UITableView DataSource



- (void)drawRect:(CGRect)rect
{
    [self.borderColor set];                                     //设置线条颜色
    
    
    //填充颜色
    [[UIColor whiteColor] setFill];
    
}
-(CGRect)getViewFrameCategory
{
    CGRect frame = CGRectZero;
    
    
    frame.size.height = [self.categoryArray count] * ROW_HEIGHT + SPACE + kArrowHeight;
    
    
    
    for (NSString *title in self.titleArray)
    {
        CGFloat width =  kWidth-140;
        
        
        
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([self.titleArray count] == [self.titleArray count])
    {
        frame.size.width = 10 + 25 + 10 + frame.size.width + 90;
    }
    else
    {
        frame.size.width = 10 + frame.size.width + 90;
    }
    
    frame.origin.x = self.showPoint.x - frame.size.width/2;
    frame.origin.y = self.showPoint.y;
    
    //左间隔最小5x
    if (frame.origin.x < 5)
    {
        frame.origin.x = 5;
    }
    //右间隔最小5x
    if ((frame.origin.x + frame.size.width) > kWidth-5)
    {
        frame.origin.x = kWidth-5 - frame.size.width;
    }
    
    return frame;
}

@end
