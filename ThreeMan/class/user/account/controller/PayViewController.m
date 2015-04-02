//
//  PayViewController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"充值"];
    
    [self buildUI];
}

- (void)buildUI
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, kWidth-8*2, 131)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i = 0 ; i< 3; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        line.backgroundColor = HexRGB(0xe0e0e0);
        [bgView addSubview:line];
        CGRect frame = CGRectMake(0, 0, bgView.frame.size.width, 1);
        if (i==0) {
            frame.origin.y = 49;
        }else if (i==1){
            frame.origin.y = 50+30;
        }else{
            frame.origin.y = bgView.frame.size.height-1;
        }
        line.frame = frame;
        [bgView addSubview:line];
    }
    
    
    //账号
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,0,140,50)];
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.text = @"15012545412";
    telLabel.textColor = HexRGB(0x323232);
    telLabel.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:telLabel];
    
    //昵称
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-12-150,0,150,50)];
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.text = @"张玉泉";
    nickLabel.textAlignment = NSTextAlignmentRight;
    nickLabel.textColor = HexRGB(0x323232);
    nickLabel.font = [UIFont systemFontOfSize:18];
    [bgView addSubview:nickLabel];

    //剩余蜕变豆
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,50,140,31)];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.text = @"剩余蜕变豆:28";
    amountLabel.textColor = HexRGB(0x959595);
    amountLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:amountLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 50+31, bgView.frame.size.width-12,50)];
    textField.placeholder = @"请输入充值数量(1元=1蜕变豆)";
    textField.backgroundColor = [UIColor clearColor];
    [bgView addSubview:textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
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
