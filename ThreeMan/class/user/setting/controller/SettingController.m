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
#import "AuthencateTool.h"

@interface SettingController ()<ResetSecretViewDelegate,KeyboardDelegate>
{
    UIView *footView;
    NSString *download_link;
}
@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"设置"];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self initView];
    
    [self loadData];
    
    [_tableView reloadData];
    
    [[SystemConfig sharedInstance] addObserver:self forKeyPath:@"isUserLogin" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:NULL];
}

//初始化tableview 和 footview
- (void)initView
{
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
}

//键值观察 用来控制footview的显示
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"isUserLogin"])
    {
        if ([SystemConfig sharedInstance].isUserLogin) {
            _tableView.tableFooterView = footView;
        }else{
            _tableView.tableFooterView = nil;
        }
    }
}



#pragma mark 注销登录
- (void)btnDown
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    alertView.delegate  = self;
    [alertView show];
}


#pragma mark AlertView_delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex==1) {
            [self clearLoginData];
            [RemindView showViewWithTitle:@"注销成功" location:MIDDLE];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 1001){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:download_link]];
        }
    }
}

#pragma mark 推出登陆后移除相关数据
- (void)clearLoginData
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

#pragma mark tableview_datasource
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
    if (indexPath.row<[[_dataArray objectAtIndex:indexPath.section] count]-1) {
        cell.line.backgroundColor = HexRGB(0xeaebec);
    }else{
        cell.line.backgroundColor = HexRGB(0xcacaca);
    }
    if (indexPath.section==1&&indexPath.row==0) {
        cell.nextImage.hidden = YES;
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"off",@"on", nil]];
        control.frame = CGRectMake(0, 0,70, 30);
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
    cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark tableview_delegate
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
                    [window addSubview:windowBgView];
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

#pragma mark 检查更新
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

#pragma mark wifi按钮点击
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
    switch (btn.tag) {
        case 1:
        {
            [windowBgView removeFromSuperview];
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
            
            [view resignFirstResponder];
            
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].userInfo.phone,@"phone",view.telView.textField.text,@"olduserpwd",view.freshView.textField.text,@"newuserpwd",nil];
            [HttpTool postWithPath:@"getChangePwd" params:param success:^(id JSON, int code, NSString *msg) {
                if (code == 100) {
                    
                    //修改密码成功  做退出处理
                    [windowBgView removeFromSuperview];
                    
                    [view removeFromSuperview];
                    
                    
                    [self clearLoginData];
                    
                    [RemindView showViewWithTitle:@"修改成功,请重新登录" location:TOP];
                    
                    [self showLoginView];
                    
                }else{
                    
                    [RemindView showViewWithTitle:msg location:TOP];

                }
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)dealloc
{
    [[SystemConfig sharedInstance] removeObserver:self forKeyPath:@"isUserLogin"];
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
