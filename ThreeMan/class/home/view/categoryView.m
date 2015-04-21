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
        [self getButtons];
        
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

- (void)getButtons
{
    
    UIView *viewLine =[[UIView alloc]init];
    viewLine.frame=CGRectMake(0, 20, kHeight, kHeight);
    [self addSubview:viewLine];
    viewLine.backgroundColor = HexRGB(0xeaebec);
    viewLine.backgroundColor = [UIColor blackColor];
    viewLine.alpha =.6;
    
    
    for (int i=0; i<4; i++)
    {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.frame=CGRectMake(0, 54+i%4*(44)-43, kWidth, 44);
        
        [_titleBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [_titleBtn setTitleColor:HexRGB(0x178ac5) forState:UIControlStateSelected];
        _titleBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 50, 0, 0);
        
        [_titleBtn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [_titleBtn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_titleBtn];
        _titleBtn.tag =100+i;
        _titleBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        
        [_titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i==0)
        {
            UIImageView *jiaoLine =[[UIImageView alloc]initWithFrame:CGRectMake(-10, -8, kWidth+10, 20)];
            [_titleBtn addSubview:jiaoLine];
            jiaoLine.image =[UIImage imageNamed:@"jiaoLine"];
            jiaoLine.backgroundColor =[UIColor whiteColor];
            
            
        }
        if (i==1)
        {
            _titleBtn.frame=CGRectMake(0, 54+i%5*(44)-43, kWidth, 44);
            [_titleBtn setImage:[UIImage imageNamed:@"lower"] forState:UIControlStateNormal];
            [_titleBtn setImage:[UIImage imageNamed:@"lower_rep"] forState:UIControlStateSelected];
            _titleBtn.imageEdgeInsets =UIEdgeInsetsMake(0, 130, 0, 0);
            _titleBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 40, 0, 0);

        }
        
        
        
        UIView *viewLine =[[UIView alloc]init];
        viewLine.frame=CGRectMake(0, 43, kWidth, 1);
        [_titleBtn addSubview:viewLine];
        viewLine.backgroundColor =HexRGB(0xeaebec);
        //          viewLine.backgroundColor =[UIColor redColor];
        
        
        
    }
    
    
    NSArray *array = [[DBTool shareDBToolClass] getNewTitleButtonArray];
    
    
    for (int j=0; j < self.titleArray.count; j++)
    {
        if (array.count == 0)
        {
            _selectIndex = 100;
            
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.titleArray[j],@"t_title",[NSString stringWithFormat:@"%d",100+j],@"t_tag",@"",@"c_title",@"",@"c_tag", nil];
            
            
            [[DBTool shareDBToolClass] saveTitleButtonWithEntity:dict];
            
        }
        else
        {
            _titleBModle = [array objectAtIndex:0];
            _selectIndex = [_titleBModle.t_tag intValue];
        }
        
        
        
        if (j == _selectIndex-100)
        {
            _selectedButton = (UIButton *)[self viewWithTag:_selectIndex];
            _selectedButton.selected = YES;
            
            
            if (_selectIndex == 101)
            {
                _isSecondSelected = YES;
                [self categoryBtnClick:_selectedButton withCTag:_titleBModle.c_tag];
            }
        }
        
        
    }
    
    
    
    
    
    
    //    return _titleBtn;
}
- (void)categoryBtnClick:(UIButton *)btn withCTag:(NSString *)c_tag
{
    
    if (self.categoryTitleBtn)
    {
        
    }
    else
    {
        for (int i=0; i<7; i++)
        {
            
            self.categoryTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [self.categoryTitleBtn setTitleColor:HexRGB(0x178ac5) forState:UIControlStateSelected];
            [_categoryTitleBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
            
            [self.categoryTitleBtn addTarget:self action:@selector(categoryTitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.categoryTitleBtn.frame=CGRectMake(210, 55+i%7*(44)-43, 150, 44);
            if (i==4||i==5||i==6||i==7)
            {
                self.categoryTitleBtn.frame=CGRectMake(0, 54+i%8*(44)-43, kWidth, 44);
                self.categoryTitleBtn.titleEdgeInsets =UIEdgeInsetsMake(0, kWidth-110, 0, 20);
                
            }
            
            
            [self.categoryTitleBtn setTitle:[self.categoryArray objectAtIndex:i] forState:UIControlStateNormal];
            [self.categoryTitleBtn setBackgroundColor:[UIColor whiteColor]];
            
            self.categoryTitleBtn.tag =104+i;
            self.categoryTitleBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
            
            
            UIView *viewLine =[[UIView alloc]init];
            viewLine.frame=CGRectMake(0, 42, kWidth, 1);
            [self.categoryTitleBtn addSubview:viewLine];
            viewLine.backgroundColor =HexRGB(0xeaebec);
            //        viewLine.backgroundColor =[UIColor redColor];
            [self addSubview:self.categoryTitleBtn];
            self.frame =[self getViewFrameCategory];
            
            
            
            
        }
        
        
        
        NSArray *array = [[DBTool shareDBToolClass] getNewTitleButtonArray];
        
        
        for (int j=0; j<7; j++)
        {
            if (array.count != 0)
            {
                _titlseSelectIndex = [c_tag intValue];
            }
            else
            {
                _titlseSelectIndex = 10;
            }
            
            if (j == _titlseSelectIndex-10)
            {
                _titleBtnSelected = (UIButton *)[self viewWithTag:_titlseSelectIndex];
                _titleBtnSelected.selected = YES;
            }
            
            
        }
    }
    
}

- (void)titleBtnClick:(UIButton *)index
{
    _selectedButton.selected = !_selectedButton.selected;
    
    _selectedButton = index;
    _selectedButton.selected = YES;
    
    
    switch (index.tag)
    {
        case 100:
        {
            
        }
            break;
            
        case 101:
        {
            [self categoryBtnClick:_selectedButton withCTag:@"10"];
        }
            break;
            
        case 102:
        {
            
        }
            break;
            
        case 103:
        {
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    if (self.selectRowAtIndex)
    {
        self.selectRowAtIndex(index.tag);
    }
    
    if (index.tag != 101)
    {
        [[DBTool shareDBToolClass] updateSelectedStyleByTTag:[NSString stringWithFormat:@"%ld",(long)_selectedButton.tag] withCTag:@""];
        [self dismiss:YES];
    }
    else
    {
        [[DBTool shareDBToolClass] updateSelectedStyleByTTag:[NSString stringWithFormat:@"%ld",(long)_selectedButton.tag] withCTag:@"10"];
    }
    
    NSLog(@"%ld",(long)_selectedButton.tag);
    
    
    
    
    
}



- (void)categoryTitleBtnClick:(UIButton *)sender
{
    _titleBtnSelected.selected = !_titleBtnSelected.selected;
    
    _titleBtnSelected = sender;
    _titleBtnSelected.selected = YES;
    
    [[DBTool shareDBToolClass] updateSelectedStyleByTTag:[NSString stringWithFormat:@"%ld",(long)_selectedButton.tag] withCTag:[NSString stringWithFormat:@"%ld",(long)_titleBtnSelected.tag]];
    
    
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
