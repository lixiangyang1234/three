//
//  NewfeatureController.m
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "NewfeatureController.h"
#import "UIImage+MJ.h"
#import "MainControllerViewController.h"
#import "WBNavigationController.h"
#import "AppMacro.h"

#define kCount 3
@interface NewfeatureController ()<UIScrollViewDelegate,UINavigationControllerDelegate>
{
    UIScrollView *_scroll;

}
@end

@implementation NewfeatureController

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"Default.png"];
    imageView.frame = [UIScreen mainScreen].bounds;
    // 跟用户进行交互（这样才可以接收触摸事件）
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self addScrollView];
    [self addScrollImages];
}

#pragma mark 添加滚动视图
- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO; // 隐藏水平滚动条
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, kHeight-20); // 内容尺寸
    scroll.pagingEnabled = YES; // 分页
    scroll.delegate = self;
    scroll.bounces = NO;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

#pragma mark 添加滚动显示的图片
- (void)addScrollImages
{
    CGSize size = _scroll.frame.size;
    
    for (int i = 0; i<kCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 1.显示图片
       
        
        NSLog(@"%f",kWidth);
        NSString *name = [NSString stringWithFormat:@"new_text%d.png", i];
        
        if (kHeight<568) {
            name = [NSString stringWithFormat:@"new_text%d.png", i ];
        }
        imageView.image = [UIImage imageNamed:name];
        // 2.设置frame
        imageView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
        [_scroll addSubview:imageView];
        
        if (i == kCount - 1) { // 最后一页，添加2个按钮
            // 3.立即体验（开始）
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            start.frame =CGRectMake((kWidth-155)/2, size.height*0.72, 155, 40);
            start.titleLabel.font =[UIFont systemFontOfSize:PxFont(30)];
            start.backgroundColor =[UIColor clearColor];
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:start];
    
            imageView.userInteractionEnabled = YES;
            
           }
    }
}
//立即进入
-(void)start
{
    [UIApplication sharedApplication].statusBarHidden =NO;
    self.view.window.rootViewController =[[MainControllerViewController alloc]init];
    
}






@end
