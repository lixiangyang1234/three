//
//  DrawViewController.m
//  ThreeMan
//
//  Created by tianj on 15/4/3.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "DrawViewController.h"
#import "AdaptationSize.h"
#import "RemindView.h"

@interface DrawViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
    UILabel *_payLabel;
    UITextField *_zfbTextField;
    CGFloat _scale;
}


@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"提现"];
    
    [self loadData];
}

- (void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTool postWithPath:@"getReturn" params:nil success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",JSON);
        if (code == 100) {
            NSDictionary *dict = JSON[@"data"];
            [self buildUI:dict];
            _scale = [[dict objectForKey:@"scale"] doubleValue];
        }else{
            [RemindView showViewWithTitle:msg location:TOP];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:TOP];
    }];
}


- (void)buildUI:(NSDictionary *)dict
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, kWidth-8*2, 31+50*3)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i = 0 ; i< 4; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [bgView addSubview:line];
        CGRect frame = CGRectMake(0, 0, bgView.frame.size.width, 0.5);
        if (i==0) {
            frame.origin.y = 50-0.5;
            line.backgroundColor = HexRGB(0xe0e0e0);
        }else if (i==1){
            frame.origin.y = 50+31-0.5;
            line.backgroundColor = HexRGB(0xe0e0e0);
        }else{
            frame.origin.y = 31+50*i-0.5;
            line.backgroundColor = HexRGB(0xcacaca);
        }
        line.frame = frame;
        [bgView addSubview:line];
    }
    
    UserInfo *userinfo = [SystemConfig sharedInstance].userInfo;
    NSString *scale = [dict objectForKey:@"scale"];
    NSString *num = [[dict objectForKey:@"user"] objectForKey:@"num"];
    //账号
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,0,140,50)];
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.text = userinfo.phone;
    telLabel.textColor = HexRGB(0x323232);
    telLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:telLabel];
    
    //昵称
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-12-150,0,150,50)];
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.text = userinfo.username;
    nickLabel.textAlignment = NSTextAlignmentRight;
    nickLabel.textColor = HexRGB(0x323232);
    nickLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:nickLabel];
    
    //剩余蜕变豆
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,telLabel.frame.origin.y+telLabel.frame.size.height,140,31)];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.text = [NSString stringWithFormat:@"剩余蜕变豆:%@",num];
    amountLabel.textColor = HexRGB(0x959595);
    amountLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:amountLabel];
    
    
    _zfbTextField = [[UITextField alloc] initWithFrame:CGRectMake(12,amountLabel.frame.origin.y+amountLabel.frame.size.height, bgView.frame.size.width-12,50)];
    _zfbTextField.placeholder = @"请输入支付宝账号";
    _zfbTextField.keyboardType = UIKeyboardTypeNumberPad;
    _zfbTextField.backgroundColor = [UIColor clearColor];
    _zfbTextField.delegate = self;
    [bgView addSubview:_zfbTextField];

    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(12,_zfbTextField.frame.origin.y+_zfbTextField.frame.size.height, bgView.frame.size.width-12,50)];
    _textField.placeholder = [NSString stringWithFormat:@"请输入蜕变豆数量(%@蜕变豆＝1元)",scale];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.delegate = self;
    _textField.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:_textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:_textField];
    
    NSString *str = @"提现金额:";
    CGSize size = [AdaptationSize getSizeFromString:str Font:[UIFont systemFontOfSize:17] withHight:20 withWidth:CGFLOAT_MAX];
    UILabel *payTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,bgView.frame.origin.y+bgView.frame.size.height+20,size.width,20)];
    payTitle.backgroundColor = [UIColor clearColor];
    payTitle.text = str;
    payTitle.textColor = HexRGB(0x323232);
    payTitle.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:payTitle];
    
    
    _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(payTitle.frame.origin.x+payTitle.frame.size.width+5, payTitle.frame.origin.y,160, 20)];
    _payLabel.backgroundColor = [UIColor clearColor];
    _payLabel.text = @"0.00元";
    _payLabel.textColor = HexRGB(0x1c8cc6);
    _payLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_payLabel];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(bgView.frame.origin.x, _payLabel.frame.origin.y+_payLabel.frame.size.height+20, bgView.frame.size.width, 40);
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIImage *image = [UIImage imageNamed:@"draw"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.center = CGPointMake(kWidth/2,btn.frame.origin.y+btn.frame.size.height+40+image.size.height/2);
    [self.view addSubview:imageView];

}

- (void)btnDown
{
    if (_zfbTextField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入支付宝账号" location:TOP];
        return ;
    }
    if (_textField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入提现金额" location:TOP];
        return ;
    }
    //提现请求
    [HttpTool postWithPath:@"" params:nil success:^(id JSON, int code, NSString *msg) {
        if (code == 100) {
            
        }
    } failure:^(NSError *error) {
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}

- (void)textFieldChange
{
    _payLabel.text = [NSString stringWithFormat:@"%.2f元",[_textField.text floatValue]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    if (!basic) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
