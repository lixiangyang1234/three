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

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    
    [self loadData];
    
}


- (void)loadData
{
    [HttpTool postWithPath:@"getAboutUs" params:nil success:^(id JSON, int code, NSString *msg) {
        if (code == 100) {
            NSLog(@"%@",JSON);
            NSDictionary *dict = JSON[@"data"][@"aboutus"];
            if (dict) {
                
            }
            [self buildUI:dict];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self buildUI:nil];
    }];
}

- (void)buildUI:(NSDictionary *)dict
{
    CGFloat y = 54;
    //图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    iconImageView.image = [UIImage imageNamed:@"smallLogo"];
    iconImageView.center = CGPointMake(kWidth/2, y+iconImageView.frame.size.height/2);
    [self.view addSubview:iconImageView];
    
    y+=iconImageView.frame.size.height+10;
    //名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,y, kWidth,25)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = HexRGB(0x323232);
    nameLabel.text = @"南京三身行";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    y+=nameLabel.frame.size.height+20;
    
    if (!dict) {
        return;
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
    
    NSArray *array = [NSArray arrayWithObjects:email,fax,content, nil];
    
    CGSize size = [AdaptationSize getSizeFromString:content Font:[UIFont systemFontOfSize:14] withHight:CGFLOAT_MAX withWidth:kWidth-8*2-10-5];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, y,kWidth-8*2,([array count]-1)*39+size.height+20)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i =0 ; i<array.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i<array.count-1) {
            label.frame = CGRectMake(10, 39*i, bgView.frame.size.width-10, 39);
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,38+39*i,bgView.frame.size.width,1)];
            line.backgroundColor = HexRGB(0xe0e0e0);
            [bgView addSubview:line];
        }else{
            label.frame = CGRectMake(10, 39*i+10, bgView.frame.size.width-10-5,size.height);
            label.numberOfLines = 0;
        }
        
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = HexRGB(0x323232);
        label.text = [array objectAtIndex:i];
        [bgView addSubview:label];
        
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
