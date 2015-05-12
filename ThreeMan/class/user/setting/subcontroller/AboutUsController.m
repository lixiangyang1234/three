//
//  AboutUsController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "AboutUsController.h"
#import "AdaptationSize.h"

@interface AboutUsController ()
{
    UIScrollView *_scrollView;
}
@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_scrollView];
    
    
    [self setLeftTitle:@"关于我们"];
    
    [self loadData];
    
}


- (void)loadData
{
    [HttpTool postWithPath:@"getAboutUs" params:nil success:^(id JSON, int code, NSString *msg) {
        if (code == 100) {
            NSLog(@"%@",JSON);
            NSMutableDictionary *dict = JSON[@"data"][@"aboutus"];
            if (dict) {
                [self buildUI:dict];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self buildUI:nil];
    }];
}

- (void)buildUI:(NSMutableDictionary *)dict
{
    CGFloat y = 54;
    //图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    iconImageView.image = [UIImage imageNamed:@"smallLogo"];
    iconImageView.center = CGPointMake(kWidth/2, y+iconImageView.frame.size.height/2);
    [_scrollView addSubview:iconImageView];
    
    y+=iconImageView.frame.size.height+10;
    //名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,y, kWidth,25)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = HexRGB(0x323232);
    nameLabel.text = @"南京三身行";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:nameLabel];
    
    
    y+=nameLabel.frame.size.height+20;
    
    if (!dict||[dict isKindOfClass:[NSNull class]]) {
        dict = [NSMutableDictionary dictionary];
        [dict setObject:@"" forKey:@"email"];
        [dict setObject:@"" forKey:@"fax"];

    }
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 150,20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = HexRGB(0x9a9a9a);
    titleLabel.text = @"联系我们:";
    [self.view addSubview:titleLabel];
    
    y += titleLabel.frame.size.height+10;
    
    NSString *email = [NSString stringWithFormat:@"邮箱: %@",[dict objectForKey:@"email"]];
    
    NSString *fax=  [NSString stringWithFormat:@"传真: %@",[dict objectForKey:@"fax"]];
    NSString *content = [dict objectForKey:@"content"];
    
    
    
    CGFloat height = 39*2;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, y,kWidth-8*2,0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0, bgView.frame.size.width-10,39)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = email;
    emailLabel.textColor = HexRGB(0x323232);
    emailLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:emailLabel];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, bgView.frame.size.width,1)];
    line1.backgroundColor = HexRGB(0xe0e0e0);
    [bgView addSubview:line1];
    
    UILabel *faxLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,39, bgView.frame.size.width-10,39)];
    faxLabel.backgroundColor = [UIColor clearColor];
    faxLabel.text = fax;
    faxLabel.textColor = HexRGB(0x323232);
    faxLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:faxLabel];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39*2, bgView.frame.size.width,1)];
    line2.backgroundColor = HexRGB(0xe0e0e0);
    [bgView addSubview:line2];
    
    if (content&&content.length!=0) {
        CGSize size = [AdaptationSize getSizeFromString:content Font:[UIFont systemFontOfSize:14] withHight:CGFLOAT_MAX withWidth:bgView.frame.size.width-10-5];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,39*2+10, bgView.frame.size.width-10-5,size.height)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.text = content;
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = HexRGB(0x323232);
        contentLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:contentLabel];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39*2+size.height+20, bgView.frame.size.width,1)];
        line1.backgroundColor = HexRGB(0xe0e0e0);
        [bgView addSubview:line1];
        height+=size.height+20;
    }
    bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, height);
    
    [_scrollView setContentSize:CGSizeMake(kWidth, bgView.frame.origin.y+bgView.frame.size.height+20)];
    
    
    if (_scrollView.contentSize.height<=kHeight-64) {
        UIImage *image = [UIImage imageNamed:@"title"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.center = CGPointMake(kWidth/2,kHeight-64-image.size.height/2-30);
        [_scrollView addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
