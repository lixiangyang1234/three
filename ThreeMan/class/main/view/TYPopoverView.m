//
//  TYPopoverView.m
//  ZSEL
//
//  Created by apple on 14-11-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TYPopoverView.h"

#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define SPACE 2.f
#define ROW_HEIGHT 35.f
#define TITLE_FONT [UIFont systemFontOfSize:14]


@implementation TYPopoverView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.borderColor = [UIColor greenColor];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images
{
    self = [super init];
    if (self)
    {
        self.showPoint = point;
        self.titleArray = titles;
        self.imageArray = images;
        
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
        CGFloat width =  [title sizeWithFont:TITLE_FONT constrainedToSize:CGSizeMake(kWidth-20, 100) lineBreakMode:NSLineBreakByCharWrapping].width;
       

        
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([self.titleArray count] == [self.imageArray count])
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
    
    CGRect rect = self.frame;
    rect.origin.x = SPACE;
    rect.origin.y = kArrowHeight + SPACE;
    rect.size.width -= SPACE * 2;
    rect.size.height -= (SPACE - kArrowHeight);
//
    for (int i=0; i<5; i++) {
        
        self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.titleBtn.frame=CGRectMake(1, 10+i%5*(44)-43, self.frame.size.width-2, 44);
       
        [self.titleBtn setImage:[UIImage imageNamed:self.imageArray [i]] forState:UIControlStateNormal];
        [self.titleBtn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [self.titleBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.titleBtn];
        self.titleBtn.tag =10+i;
        self.titleBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        if (i==0) {
            self.titleBtn.frame=CGRectMake(1, 11+i%5*(44), self.frame.size.width-52, 44);
            

        }else if (i==1) {
            self.titleBtn.frame=CGRectMake(self.frame.size.width-51, 10+i%5*(44)-43, 50, 44);
            [self.titleBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

        }
        [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateHighlighted];
        
        UIView *viewLine =[[UIView alloc]init];
        viewLine.frame=CGRectMake(1, 53+i/2*(44), self.frame.size.width-2, 1);
        [self addSubview:viewLine];
        viewLine.backgroundColor =[UIColor whiteColor];

    }

    
    return _titleBtn;
}
-(void)titleBtnClick:(UIButton *)index{
    if (self.selectRowAtIndex)
    {
        self.selectRowAtIndex(index.tag);
    }
    [self dismiss:YES];}
#pragma mark - UITableView DataSource


//#pragma mark - UITableView Delegate
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectRowAtIndex)
    {
        self.selectRowAtIndex(indexPath.row);
    }
    [self dismiss:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}


- (void)drawRect:(CGRect)rect
{
    [self.borderColor set];                                     //设置线条颜色
    
    CGRect frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
//    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];          //左上角
    
    /********************向上的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowCurvature, yMin)];//left side
//    
//    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x, arrowPoint.y)];
//    
//    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + kArrowCurvature, yMin)];
    
    
    /********************向上的箭头**********************/
    
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];       //右上角
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];       //右下角
    
    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];       //左下角
    
    //填充颜色
    [[UIColor lightGrayColor] setFill];
    
    [popoverPath fill];
    
    [popoverPath closePath];
    [popoverPath stroke];
}

@end
