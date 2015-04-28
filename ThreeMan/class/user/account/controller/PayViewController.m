//
//  PayViewController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "PayViewController.h"
#import "AdaptationSize.h"
#import "RemindView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayTool.h"
#import "Order.h"

@interface PayViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
    UILabel *_payLabel;
}
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"充值"];
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, kWidth-8*2, 50+31+50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i = 0 ; i< 3; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [bgView addSubview:line];
        CGRect frame = CGRectMake(0, 0, bgView.frame.size.width,0.5);
        if (i==0) {
            frame.origin.y = 50-0.5;
            line.backgroundColor = HexRGB(0xe0e0e0);
        }else if (i==1){
            frame.origin.y = 50+31-0.5;
            line.backgroundColor = HexRGB(0xe0e0e0);
        }else{
            frame.origin.y = bgView.frame.size.height-0.5;
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
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,50,140,31)];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.text = [NSString stringWithFormat:@"剩余蜕变豆:%@",num];
    amountLabel.textColor = HexRGB(0x959595);
    amountLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:amountLabel];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 50+31, bgView.frame.size.width-12,50)];
    _textField.placeholder = [NSString stringWithFormat:@"请输入充值数量(1元=%@蜕变豆)",scale];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.font = [UIFont systemFontOfSize:17];
    _textField.delegate = self;
    [bgView addSubview:_textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:_textField];
    
    NSString *str = @"支付宝付款:";
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
    [btn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIImage *image = [UIImage imageNamed:@"title"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.center = CGPointMake(kWidth/2,kHeight-64-image.size.height/2-30);
    [self.view addSubview:imageView];

}

- (void)btnDown
{
    if (_textField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入购买数量" location:TOP];
        return ;
    }
    //获取支付金额
    NSDictionary *param = @{@"num":_textField.text};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTool postWithPath:@"getRecharge" params:param success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (code == 100) {
            NSString *money = JSON[@"data"][@"money"];
            [self doAlipay:money];
        }else{
            [RemindView showViewWithTitle:msg location:TOP];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:offline location:TOP];
    }];
    
    //支付操作
}

- (void)textFieldChange
{
    _payLabel.text = [NSString stringWithFormat:@"%.2f元",[_textField.text doubleValue]];
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
#pragma mark 支付宝支付
- (void)doAlipay:(NSString *)num;
{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = PartnerID;
    NSString *seller = SellerID;
    NSString *privateKey = PartnerPrivKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"1"; //订单ID（由商家自行制定）
    order.productName = @"蜕变豆"; //商品标题
    order.productDescription = @"蜕变豆"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[num doubleValue]]; //商品价格
    order.notifyURL =  @"http://pnail.ywswl.com/Home/Alipay/notify_url.html"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"ThreeManDemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            int resultStatus = [[resultDic objectForKey:@"resultStatus"] intValue];
            if (resultStatus == 9000) {
                [RemindView showViewWithTitle:@"支付成功" location:BELLOW];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderView" object:nil];
            }else if (resultStatus == 8000){
                [RemindView showViewWithTitle:@"正在处理中" location:BELLOW];
            }else{
                [RemindView showViewWithTitle:@"支付失败" location:BELLOW];
            }
        }];
    }
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
