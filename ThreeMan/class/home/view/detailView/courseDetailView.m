//
//  courseDetailView.m
//  ThreeMan
//
//  Created by YY on 15/6/4.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "courseDetailView.h"
#define YYBORDERWH   8
#define borderw  5
@implementation courseDetailView
{
    CGFloat webh;
    UIWebView *_courseWeb;
}
-(id)initWithFrame:(CGRect)frame statusLoad:(courseDetailModel *)courseModel{
    self =[super initWithFrame:frame ];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.scrollEnabled =NO;
        self.bounces =NO;
    
    CGFloat detailWH =9;
    //添加标题
    UILabel *detailTitle =[[UILabel alloc]initWithFrame:CGRectMake(detailWH, detailWH, kWidth-detailWH*2-YYBORDERWH*2, 20)];
    [self addSubview:detailTitle];
    detailTitle.text =courseModel.courseTitle;
    detailTitle.font =[UIFont systemFontOfSize:PxFont(18)];
    detailTitle.textColor=HexRGB(0x323232);
    detailTitle.backgroundColor =[UIColor clearColor];
    CGFloat titleDetailH =detailTitle.frame.size.height+detailTitle.frame.origin.y+5;
    //添加蜕变豆
    
    CGFloat douW =[[NSString stringWithFormat:@"%d", courseModel.coursePrice] sizeWithFont:[UIFont systemFontOfSize:PxFont(24)]constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width;
    UIButton *detailDou =[UIButton buttonWithType:UIButtonTypeCustom];
    detailDou.frame =CGRectMake(detailWH, titleDetailH, douW+30, 30);
    [detailDou setImage:[UIImage imageNamed:@"browser_number_icon"] forState:UIControlStateNormal];
    [detailDou setTitle:[NSString stringWithFormat:@"%d", courseModel.coursePrice] forState:UIControlStateNormal];
    [self addSubview:detailDou];
    detailDou.titleEdgeInsets =UIEdgeInsetsMake(0, 5, 0, 0);
    detailDou.backgroundColor =[UIColor clearColor];
    [detailDou setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [detailDou.titleLabel setFont:[UIFont systemFontOfSize:PxFont(24)]];
    detailDou.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    CGFloat douDetailW =detailDou.frame.size.width+detailDou.frame.origin.x;
    UILabel *detailDouLabel =[[UILabel alloc]initWithFrame:CGRectMake(douDetailW, titleDetailH+3, 45, 30)];
    [self addSubview:detailDouLabel];
    detailDouLabel.text =@"蜕变豆";
    detailDouLabel.font =[UIFont systemFontOfSize:PxFont(14)];
    detailDouLabel.textColor=HexRGB(0x323232);
    detailDouLabel.backgroundColor =[UIColor clearColor];
    
    CGFloat companyHomeW =douDetailW+detailDouLabel.frame.size.width;
    //企业首页
    CGFloat homeNameW =[courseModel.courseCompanyname sizeWithFont:[UIFont systemFontOfSize:PxFont(14)]constrainedToSize:CGSizeMake(MAXFLOAT, 19)].width;
    
    UIButton *companyHomeDetail =[UIButton buttonWithType:UIButtonTypeCustom];
    companyHomeDetail.frame =CGRectMake(companyHomeW, titleDetailH+6, homeNameW+10, 19);
    [self addSubview:companyHomeDetail];
    [companyHomeDetail setTitle:courseModel.courseCompanyname forState:UIControlStateNormal];
    companyHomeDetail.titleEdgeInsets =UIEdgeInsetsMake(0, 20, 0, 5);
    [companyHomeDetail setTitleColor:HexRGB(0x1c8cc6) forState:UIControlStateNormal];
    [companyHomeDetail.titleLabel setFont:[UIFont systemFontOfSize:PxFont(12)]];
    companyHomeDetail.backgroundColor =[UIColor clearColor];
    companyHomeDetail.layer.masksToBounds =YES;
    companyHomeDetail.layer.borderColor =HexRGB(0x178ac5).CGColor;
    companyHomeDetail.layer.borderWidth=0.8f;
    companyHomeDetail.layer.cornerRadius =10;
    //banner图片
    UIImageView *companyHomeImg =[[UIImageView alloc]initWithFrame:CGRectMake(-1, 0,19 , 19)];
    [companyHomeDetail addSubview:companyHomeImg];
    companyHomeImg.userInteractionEnabled=YES;
    companyHomeImg.image =[UIImage imageNamed:@"company_name"];
    [companyHomeDetail addTarget:self action:@selector(companyhomeDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat eightH =detailDou.frame.size.height+detailDou.frame.origin.y+borderw;
    //添加8像素高度灰条
    UIView *eightView =[[UIView alloc]initWithFrame:CGRectMake(0, eightH, kWidth-YYBORDERWH*2, 8)];
    [self addSubview:eightView];
    eightView.backgroundColor =HexRGB(0xeeeee9);
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-YYBORDERWH*2, 1)];
    [eightView addSubview:line];
    line.backgroundColor =HexRGB(0xcacaca);
    webh =eightH+borderw+8;
    
    //添加WebView
    _courseWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, webh, kWidth-YYBORDERWH*2, kHeight-webh-64)];
    
    [_courseWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    _courseWeb.userInteractionEnabled = NO;
    _courseWeb.delegate =self;
    [self addSubview:_courseWeb];
    }
    return self;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGFloat webheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    
    _courseWeb.frame = CGRectMake(0, webh, kWidth-YYBORDERWH*2, webheight);
    
    self.contentSize = CGSizeMake(kWidth-YYBORDERWH*2,webheight+webh);
    
}

-(void)companyhomeDetailBtnClick:(UIButton *)companyHome{
    if ([self.scroll respondsToSelector:@selector(companyHome)]) {
        [self.scroll companyHome];
    }
}

@end
