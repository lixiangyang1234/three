//
//  SettingController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "SettingController.h"
#import "SettingCell.h"
#import "AboutUsController.h"
#import "FeedBackController.h"
#import "ResetSecretView.h"
#import "OperationController.h"
#import "SystemConfig.h"
#import "LoginView.h"
#import "FindPsWordView.h"
#import "AuthencateTool.h"
#import "ValidateView.h"

@interface SettingController ()<ResetSecretViewDelegate,KeyboardDelegate,LoginViewDelegate,FindPsWordViewDelegate,ValidateViewDelegate>
{
    UIView *windownView;
    UIView *footView;
    NSString *download_link;
    NSString *uid;
    NSString *pwd;
    NSString *tel;
}
@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"设置"];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth, 80)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8, 16, kWidth-8*2, 35);
    [btn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [btn setTitle:@"注销登录" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];

    
    if ([SystemConfig sharedInstance].isUserLogin) {
        _tableView.tableFooterView = footView;
    }
    
    [[SystemConfig sharedInstance].uid addObserver:self forKeyPath:@"uid" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

    
    [self loadData];
    [_tableView reloadData];
    
    windownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    windownView.backgroundColor = [UIColor blackColor];
    windownView.alpha = 0.4;
}

//注销登录
- (void)btnDown
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    alertView.delegate  = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex==1) {
            [self quitLogin];
            [RemindView showViewWithTitle:@"注销成功" location:MIDDLE];
            _tableView.tableFooterView = nil;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 1001){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:download_link]];
        }
    }
}

- (void)quitLogin
{
    [SystemConfig sharedInstance].isUserLogin = NO;
    [SystemConfig sharedInstance].uid = nil;
    [SystemConfig sharedInstance].userInfo = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UserInfo *userInfo = [userDefaults objectForKey:@"userInfo"];
    if (userInfo) {
        [userDefaults removeObjectForKey:@"userInfo"];
    }
}


- (void)loadData
{
    NSArray *array = [NSArray arrayWithObjects:@"修改密码",@"意见反馈",@"关于我们",@"操作指南", nil];
    NSArray *array1 = [NSArray arrayWithObjects:@"允许非WIFI网络下载",@"检查更新", nil];
    [_dataArray addObject:array];
    [_dataArray addObject:array1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify  = @"identify";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil ) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,42-0.5, kWidth-8*2,0.5)];
    if (indexPath.row<[[_dataArray objectAtIndex:indexPath.section] count]-1) {
        line.backgroundColor = HexRGB(0xeaebec);
    }else{
        line.backgroundColor = HexRGB(0xcacaca);
    }
    if (indexPath.section==1&&indexPath.row==0) {
        cell.nextImage.hidden = YES;
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"off",@"on", nil]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *wifi = [userDefaults objectForKey:@"wifi"];
        if (wifi) {
            if ([wifi isEqualToString:@"0"]) {
                control.selectedSegmentIndex = 0;
            }else{
                control.selectedSegmentIndex = 1;
            }
        }else{
            control.selectedSegmentIndex = 0;
        }
        [control addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        control.center = CGPointMake(kWidth-8*2-15-control.frame.size.width/2,42/2);
        [cell.bgView addSubview:control];
    }else{
        cell.nextImage.hidden = NO;
    }
    if (indexPath.section==1&&indexPath.row==1) {
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.bgView.frame.size.width-100-30,0,100, 42)];
        versionLabel.backgroundColor = [UIColor clearColor];
        versionLabel.textAlignment = NSTextAlignmentRight;
        versionLabel.textColor = HexRGB(0x323232);
        NSDictionary *dict =[[NSBundle mainBundle] infoDictionary];
        NSString *version = [dict objectForKey:@"CFBundleShortVersionString"];
        versionLabel.text = [NSString stringWithFormat:@"v%@",version];
        [cell.bgView addSubview:versionLabel];
    }
    [cell.bgView addSubview:line];
    cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }else
        return 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            //修改密码
            case 0:
            {
                if (![SystemConfig sharedInstance].isUserLogin) {
                    [RemindView showViewWithTitle:@"抱歉，请先点击右上角注册或登录!" location:TOP];
                }else{
                    ResetSecretView *resetView = [[ResetSecretView alloc] init];
                    resetView.center = CGPointMake(kWidth/2, kHeight+resetView.frame.size.height/2);
                    resetView.delegate = self;
                    resetView.keyboardDelegate = self;
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window addSubview:windownView];
                    [window addSubview:resetView];
                    [UIView animateWithDuration:0.3 animations:^{
                        resetView.center = CGPointMake(kWidth/2, kHeight/2);
                    }];
                }
            }
                break;
            //意见反馈
            case 1:
            {
                if (![SystemConfig sharedInstance].isUserLogin) {
                    [RemindView showViewWithTitle:@"抱歉，请先点击右上角注册或登录!" location:TOP];
                }else{
                    FeedBackController *feed = [[FeedBackController alloc] init];
                    [self.navigationController pushViewController:feed animated:YES];
                }

            }
                break;
            //关于三身行
            case 2:
            {
                AboutUsController *about = [[AboutUsController alloc] init];
                [self.navigationController pushViewController:about animated:YES];
            }
                break;
            //操作指南
            case 3:
            {
                OperationController *op = [[OperationController alloc] init];
                [self.navigationController pushViewController:op animated:YES];
            }
                break;
   
            default:
                break;
        }
    }else{
        if (indexPath.row == 1) {
            [self checkVersion];
        }
    }
}

//检查更新
- (void)checkVersion
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTool postWithPath:@"getUpdate" params:nil success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (code == 100) {
            //当前版本
            NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
            float currentVersion_float = [currentVersion floatValue];
            //服务器存储版本
            NSString *version = JSON[@"data"][@"edition"];
            float version_float = [version floatValue];
            if (currentVersion_float<version_float) {
                download_link = JSON[@"data"][@"downloadurl"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"检测到新版本,是否前往更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往更新", nil];
                alertView.tag = 1001;
                [alertView show];
                
            }else{
                
                [RemindView showViewWithTitle:@"当前已是最新版本" location:MIDDLE];
                
            }

        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


- (void)valueChange:(UISegmentedControl *)control
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *wifi;
    if (control.selectedSegmentIndex == 0) {
        wifi = @"0";
    }else{
        wifi = @"1";
    }
    [userDefaults setObject:wifi forKey:@"wifi"];
    [userDefaults synchronize];
}

#pragma mark keyboard_delegate
- (void)keyboardShow:(UIView *)view frame:(CGRect)frame
{
    [UIView animateWithDuration:0.3 animations:^{
        view.center = CGPointMake(kWidth/2, view.frame.size.height/2+20);
    }];
}

- (void)keyboardHiden:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        view.center = CGPointMake(kWidth/2, kHeight/2);
    }];
}

#pragma mark resetView_delegate
- (void)resetViewBtnClick:(UIButton *)btn view:(ResetSecretView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (btn.tag) {
        case 1:
        {
            [windownView removeFromSuperview];
            [UIView animateWithDuration:0.3 animations:^{
                view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
            break;
        case 2:
        {
            if (view.telView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入原密码" location:TOP];
                return;
            }
            if (view.originView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入新密码" location:TOP];
                return;
            }
            if (view.freshView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请确认新密码" location:TOP];
                return;
            }
            if (![view.originView.textField.text isEqualToString:view.freshView.textField.text]) {
                [RemindView showViewWithTitle:@"两次密码输入不一致" location:TOP];
                return;
            }
            
            [view.telView.textField resignFirstResponder];
            [view.originView.textField resignFirstResponder];
            [view.freshView.textField resignFirstResponder];

            
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].userInfo.phone,@"phone",view.telView.textField.text,@"olduserpwd",view.freshView.textField.text,@"newuserpwd",nil];
            [HttpTool postWithPath:@"getChangePwd" params:param success:^(id JSON, int code, NSString *msg) {
                if (code == 100) {
                    
                    //修改密码成功  做退出处理
                    [self quitLogin];
                    _tableView.tableFooterView = nil;
                    
                    LoginView *loginView = [[LoginView alloc] init];
                    loginView.center = CGPointMake(kWidth/2, kHeight+loginView.frame.size.height/2);
                    loginView.delegate = self;
                    loginView.keyboardDelegate = self;
                    [window addSubview:loginView];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        view.center = CGPointMake(kWidth/2,-view.frame.size.height/2);
                        loginView.center = CGPointMake(kWidth/2, kHeight/2);
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
                    
                }
                
                [RemindView showViewWithTitle:msg location:TOP];
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark LoginView_delegate 登录代理
- (void)loginViewBtnClick:(UIButton *)btn view:(LoginView *)view
{
    switch (btn.tag) {
            //移除
        case 1:
        {
            [windownView removeFromSuperview];
            [UIView animateWithDuration:0.3 animations:^{
                view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
            break;
            //登录
        case 2:
        {
            if (view.telView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入账号" location:TOP];
                return;
            }
            if (![AuthencateTool isValidPhone:view.telView.textField.text]) {
                [RemindView showViewWithTitle:@"手机号不合法" location:TOP];
                return;
            }
            if (view.passwordView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入密码" location:TOP];
                return;
            }
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:view.telView.textField.text,@"phone",view.passwordView.textField.text,@"userpwd", nil];
            //登陆请求
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HttpTool postWithPath:@"getLogin" params:param success:^(id JSON, int code, NSString *msg) {
                NSLog(@"%@",JSON);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (code == 100) {
                    NSDictionary *result = JSON[@"data"][@"login"];
                    UserInfo *item = [[UserInfo alloc] init];
                    [item setValuesForKeysWithDictionary:result];
                    
                    [SystemConfig sharedInstance].isUserLogin = YES;
                    [SystemConfig sharedInstance].uid = item.uid;
                    [SystemConfig sharedInstance].userInfo = item;
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setValue:item.username forKey:@"username"];
                    [dict setValue:item.uid forKey:@"uid"];
                    [dict setValue:item.phone forKey:@"phone"];
                    [dict setValue:item.type forKey:@"type"];
                    if (item.img&&item.img.length!=0) {
                        [dict setValue:item.img forKey:@"img"];
                    }
                    [userDefaults setValue:dict forKey:@"userInfo"];
                    [userDefaults synchronize];
                    
                    //移除登陆视图
                    [windownView removeFromSuperview];
                    [UIView animateWithDuration:0.3 animations:^{
                        view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
                    
                    [RemindView showViewWithTitle:@"登录成功" location:TOP];
                    
                }else{
                    
                    [RemindView showViewWithTitle:msg location:TOP];
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [RemindView showViewWithTitle:offline location:TOP];
            }];
            
        }
            break;
            //忘记密码
        case 3:
        {
            FindPsWordView *findView = [[FindPsWordView alloc] init];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            findView.center = CGPointMake(kWidth/2, kHeight+findView.frame.size.height/2);
            findView.delegate = self;
            findView.keyboardDelegate = self;
            [window addSubview:findView];
            [UIView animateWithDuration:0.3 animations:^{
                view.center = CGPointMake(kWidth/2,-view.frame.size.height/2);
                findView.center = CGPointMake(kWidth/2, kHeight/2);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark findView_delegate  寻找密码代理
- (void)findViewBtnClick:(UIButton *)btn view:(FindPsWordView *)view
{
    switch (btn.tag) {
            //移除
        case 1:
        {
            [windownView removeFromSuperview];
            [UIView animateWithDuration:0.3 animations:^{
                view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
            break;
            //验证码验证
        case 2:
        {
            if (view.telView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入手机号码" location:TOP];
                return;
            }
            if (![AuthencateTool isValidPhone:view.telView.textField.text]) {
                [RemindView showViewWithTitle:@"手机号不合法" location:TOP];
                return;
            }
            if (view.passwordView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入重新设置的密码" location:TOP];
                return;
            }
            
            NSDictionary *param = @{@"phone":view.telView.textField.text,@"userpwd":view.passwordView.textField.text};
            [HttpTool postWithPath:@"getFindpwd" params:param success:^(id JSON, int code, NSString *msg) {
                if (code == 100) {
                    uid = JSON[@"data"];
                    ValidateView *validateView = [[ValidateView alloc] initWithTitle:view.telView.textField.text];
                    validateView.delegate = self;
                    validateView.keyboardDelegate = self;
                    validateView.tag = 1001;
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    validateView.center = CGPointMake(kWidth/2, kHeight+validateView.frame.size.height/2);
                    [window addSubview:validateView];
                    [UIView animateWithDuration:0.3 animations:^{
                        view.center = CGPointMake(kWidth/2,-view.frame.size.height/2);
                        validateView.center = CGPointMake(kWidth/2, kHeight/2);
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
                    
                }else{
                    [RemindView showViewWithTitle:msg location:TOP];
                }
            } failure:^(NSError *error) {
                [RemindView showViewWithTitle:offline location:TOP];
            }];
            
            
        }
            break;
        default:
            break;
    }
}

#pragma mark validateView_delegate 验证码代理
- (void)validateViewBtnClick:(UIButton *)btn view:(ValidateView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (btn.tag) {
        case 1:
        {
            [windownView removeFromSuperview];
            [UIView animateWithDuration:0.3 animations:^{
                view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
            break;
        case 2:
        {
            if (view.yzmView.textField.text.length == 0) {
                [RemindView showViewWithTitle:@"请输入验证码" location:TOP];
                return;
            }
            //注册
            if (view.tag == 1000) {
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",view.yzmView.textField.text,@"code", nil];
                [MBProgressHUD showHUDAddedTo:window animated:YES];
                [HttpTool postWithPath:@"getSaveUser" params:param success:^(id JSON, int code, NSString *msg) {
                    [MBProgressHUD hideAllHUDsForView:window animated:YES];
                    //注册成功
                    if (code == 100) {
                        //注册成功后调用登录接口登录
                        
                        [windownView removeFromSuperview];
                        [UIView animateWithDuration:0.3 animations:^{
                            view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
                        } completion:^(BOOL finished) {
                            [view removeFromSuperview];
                        }];
                        
                        [self login:tel pwd:pwd];
                        [RemindView showViewWithTitle:@"注册成功" location:TOP];
                    }else{
                        [RemindView showViewWithTitle:msg location:TOP];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:window animated:YES];
                    [RemindView showViewWithTitle:offline location:TOP];
                }];
                //找回密码
            }else{
                NSDictionary *param = @{@"code":view.yzmView.textField.text,@"uid":uid};
                [MBProgressHUD showHUDAddedTo:window animated:YES];
                [HttpTool postWithPath:@"getFindpwdCode" params:param success:^(id JSON, int code, NSString *msg) {
                    [MBProgressHUD hideAllHUDsForView:window animated:YES];
                    if (code == 100) {
                        
                        [windownView removeFromSuperview];
                        [UIView animateWithDuration:0.3 animations:^{
                            view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
                        } completion:^(BOOL finished) {
                            [view removeFromSuperview];
                        }];
                        [RemindView showViewWithTitle:msg location:TOP];
                    }else{
                        [RemindView showViewWithTitle:msg location:TOP];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:window animated:YES];
                    [RemindView showViewWithTitle:offline location:TOP];
                }];
            }
            
            
        }
            break;
        case 3:
        {
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
            [MBProgressHUD showHUDAddedTo:window animated:YES];
            [HttpTool postWithPath:@"getRestCode" params:param success:^(id JSON, int code, NSString *msg) {
                
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
                if (code != 100) {
                    [RemindView showViewWithTitle:msg location:TOP];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark 注册成功后调用直接登录
- (void)login:(NSString *)phone pwd:(NSString *)password
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",password,@"userpwd", nil];
    //登陆请求
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    [HttpTool postWithPath:@"getLogin" params:param success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:window animated:YES];
        if (code == 100) {
            NSLog(@"%@",JSON);
            NSDictionary *result = JSON[@"data"][@"login"];
            UserInfo *item = [[UserInfo alloc] init];
            [item setValuesForKeysWithDictionary:result];
            
            [SystemConfig sharedInstance].isUserLogin = YES;
            [SystemConfig sharedInstance].uid = item.uid;
            [SystemConfig sharedInstance].userInfo = item;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:item.username forKey:@"username"];
            [dict setValue:item.uid forKey:@"uid"];
            [dict setValue:item.phone forKey:@"phone"];
            [dict setValue:item.type forKey:@"type"];
            if (item.img&&item.img.length!=0) {
                [dict setValue:item.img forKey:@"img"];
            }
            [userDefaults setValue:dict forKey:@"userInfo"];
            [userDefaults synchronize];
            
        }else{
            [RemindView showViewWithTitle:msg location:TOP];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:window animated:YES];
        NSLog(@"%@",error);
    }];
    
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
