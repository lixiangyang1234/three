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

@interface SettingController ()<ResetSecretViewDelegate,KeyboardDelegate>
{
    UIView *windownView;
    UIView *footView;
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"uid"]) {
       BOOL ret = [SystemConfig sharedInstance].isUserLogin;
        if (ret) {
            _tableView.tableFooterView = footView;
        }
    }
}

//注销登录
- (void)btnDown
{
    [SystemConfig sharedInstance].isUserLogin = NO;
    [SystemConfig sharedInstance].uid = nil;
    [SystemConfig sharedInstance].userInfo = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UserInfo *userInfo = [userDefaults objectForKey:@"userInfo"];
    if (userInfo) {
        [userDefaults removeObjectForKey:@"userInfo"];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(hideFootView) withObject:self afterDelay:0.5];
}

- (void)hideFootView
{
    [RemindView showViewWithTitle:@"注销成功" location:MIDDLE];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    _tableView.tableFooterView = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,41, kWidth-8*2,1)];
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
                break;
            //意见反馈
            case 1:
            {
                FeedBackController *feed = [[FeedBackController alloc] init];
                [self.navigationController pushViewController:feed animated:YES];
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
                
            }
                break;
   
            default:
                break;
        }
    }else{
        //检查更新
        if (indexPath.row == 1) {
            
        }
    }
}

- (void)resetPassword
{

}

- (void)checkVersion
{
    
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
                [RemindView showViewWithTitle:@"请输入手机号" location:TOP];
                return;
            }
            if (view.originView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入原密码" location:TOP];
                return;
            }
            if (view.freshView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入新密码" location:TOP];
                return;
            }
            
            [view.telView.textField resignFirstResponder];
            [view.originView.textField resignFirstResponder];
            [view.freshView.textField resignFirstResponder];

            
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:view.telView.textField.text,@"phone",view.originView.textField.text,@"olduserpwd",view.freshView.textField.text,@"newuserpwd",nil];
            [HttpTool postWithPath:@"getChangePwd" params:param success:^(id JSON, int code, NSString *msg) {
                if (code == 100) {
                    [windownView removeFromSuperview];
                    [UIView animateWithDuration:0.3 animations:^{
                        view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
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
