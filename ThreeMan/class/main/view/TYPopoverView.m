//
//  TYPopoverView.m
//  ZSEL
//
//  Created by apple on 14-11-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TYPopoverView.h"
#import "SystemConfig.h"

#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define SPACE 2.f
#define ROW_HEIGHT 40.0f
#define TITLE_FONT [UIFont systemFontOfSize:14]
#define ROW_WIDTH 198.0f
#define HEAD_HEITHT 65.0f

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
        self.backgroundColor = HexRGB(0xffffff);
        self.layer.borderColor = HexRGB(0xf3f3f3).CGColor;
        self.layer.borderWidth = 0.5;
//        self.layer.shadowColor = HexRGB(0xf3f3f3).CGColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.showPoint = point;
        self.titleArray = titles;
        self.imageArray = images;
        
        self.frame = [self getViewFrame];
        [self addSubview:self.titleBtn];
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 40, 40)];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.image = [UIImage imageNamed:@"index_icon_fail"];
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width/2;
    self.iconView.userInteractionEnabled = YES;
    [self addSubview:self.iconView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
    [self.iconView addGestureRecognizer:tap];
    
    CGFloat x = self.iconView.frame.origin.x+40;
    CGFloat width = (self.frame.size.width-x)/2;
    //如果登陆  显示头像和用户名 否则显示登录 注册按钮
    if ([SystemConfig sharedInstance].isUserLogin) {
        UserInfo *item = [SystemConfig sharedInstance].userInfo;
        if (item.img&&![item.img isKindOfClass:[NSNull class]]&&item.img.length!=0) {
            [self.iconView setImageWithURL:[NSURL URLWithString:[SystemConfig sharedInstance].userInfo.img] placeholderImage:[UIImage imageNamed:@"index_icon_fail"]];
        }
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+11,12, width*2-16, 40)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = item.username;
        nameLabel.numberOfLines = 0;
        nameLabel.textColor = HexRGB(0x323232);
        nameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:nameLabel];
        
    }else{
        NSArray *array = [NSArray arrayWithObjects:@"登录",@"注册", nil];
        for (int i = 0 ; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(x+width*i, 12, width, 40);
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:HexRGB(0x959595) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            if (i == 0) {
                self.loginBtn = btn;
                self.loginBtn.tag = -1;
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(width, (40-15)/2, 1, 15)];
                line.backgroundColor = HexRGB(0xcecece);
                [self.loginBtn addSubview:line];
                [self addSubview:self.loginBtn];
                [self.loginBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                self.registBtn = btn;
                self.registBtn.tag = -2;
                [self.registBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.registBtn];
            }
        }
    }
    
    for (int i = 0 ; i<self.titleArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
        imgView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:i]];
        imgView.center = CGPointMake(20+23/2, HEAD_HEITHT+ROW_HEIGHT/2+40*i);
        [self addSubview:imgView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60,HEAD_HEITHT+ROW_HEIGHT*i,ROW_WIDTH-60,ROW_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [self.titleArray objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = HexRGB(0x323232);
        [self addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_HEITHT+ROW_HEIGHT*i-0.5, ROW_WIDTH, 0.5)];
        line.backgroundColor = HexRGB(0xeaebec);
        [self addSubview:line];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, HEAD_HEITHT+ROW_HEIGHT*i, self.frame.size.width,ROW_HEIGHT);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self addSubview:btn];
    }
}

- (void)tapDown
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(imageViewClick:)]) {
        [self.delegate imageViewClick:self];
    }
}

- (void)btnDown:(UIButton *)btn
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(TYPopoverViewTouch:view:)]) {
        [self.delegate TYPopoverViewTouch:btn view:self];
    }

}

-(CGRect)getViewFrame
{
    CGFloat height = [self.titleArray count] * ROW_HEIGHT + HEAD_HEITHT;
    CGRect frame = CGRectMake(kWidth-10-ROW_WIDTH,64, ROW_WIDTH, height);

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


//#pragma mark -UIButton
//
//-(UIButton *)titleBtn
//{
//    if (_titleBtn != nil)
//    {
//        return _titleBtn;
//    }
//    
//    CGRect rect = self.frame;
//    rect.origin.x = SPACE;
//    rect.origin.y = kArrowHeight + SPACE;
//    rect.size.width -= SPACE * 2;
//    rect.size.height -= (SPACE - kArrowHeight);
////
//    for (int i=0; i<5; i++) {
//        
//        self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        self.titleBtn.frame=CGRectMake(1, 10+i%5*(44)-43, self.frame.size.width-2, 44);
//       
//        [self.titleBtn setImage:[UIImage imageNamed:self.imageArray [i]] forState:UIControlStateNormal];
//        [self.titleBtn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
//        [self.titleBtn setBackgroundColor:[UIColor lightGrayColor]];
//        [self.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self addSubview:self.titleBtn];
//        self.titleBtn.tag =10+i;
//        self.titleBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
//        if (i==0) {
//            self.titleBtn.frame=CGRectMake(1, 11+i%5*(44), self.frame.size.width-52, 44);
//            
//
//        }else if (i==1) {
//            self.titleBtn.frame=CGRectMake(self.frame.size.width-51, 10+i%5*(44)-43, 50, 44);
//            [self.titleBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//
//        }
//        [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateHighlighted];
//        
//        UIView *viewLine =[[UIView alloc]init];
//        viewLine.frame=CGRectMake(1, 53+i/2*(44), self.frame.size.width-2, 1);
//        [self addSubview:viewLine];
//        viewLine.backgroundColor =[UIColor whiteColor];
//
//    }
//
//    
//    return _titleBtn;
//}
//-(void)titleBtnClick:(UIButton *)index{
//    
//    if (self.selectRowAtIndex)
//    {
//        self.selectRowAtIndex(index.tag);
//    }
//    [self dismiss:YES];}
#pragma mark - UITableView DataSource


////#pragma mark - UITableView Delegate
////
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (self.selectRowAtIndex)
//    {
//        self.selectRowAtIndex(indexPath.row);
//    }
//    [self dismiss:YES];
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return ROW_HEIGHT;
//}
//

//- (void)drawRect:(CGRect)rect
//{
//    [self.borderColor set];                                     //设置线条颜色
//    
//    CGRect frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
//    
//    float xMin = CGRectGetMinX(frame);
//    float yMin = CGRectGetMinY(frame);
//    
//    float xMax = CGRectGetMaxX(frame);
//    float yMax = CGRectGetMaxY(frame);
//    
//    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
//    
//    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
////    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];          //左上角
//    
//    /********************向上的箭头**********************/
////    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowCurvature, yMin)];//left side
////    
////    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x, arrowPoint.y)];
////    
////    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + kArrowCurvature, yMin)];
//    
//    
//    /********************向上的箭头**********************/
//    
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];       //右上角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];       //右下角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];       //左下角
//    
//    //填充颜色
//    [[UIColor lightGrayColor] setFill];
//    
//    [popoverPath fill];
//    
//    [popoverPath closePath];
//    [popoverPath stroke];
//}

@end
