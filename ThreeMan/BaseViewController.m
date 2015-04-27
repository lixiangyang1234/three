//
//  BaseViewController.m
//  ThreeMan
//
//  Created by tianj on 15/3/31.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchViewController.h"
#import "TYPopoverView.h"
#import "VideoCenterController.h"
#import "SettingController.h"
#import "AccountController.h"
#import "MessageController.h"
#import "LoginView.h"
#import "FindPsWordView.h"
#import "ValidateView.h"
#import "KeyboardDelegate.h"
#import "RegistView.h"
#import "SystemConfig.h"
#import "AuthencateTool.h"
#import "BaseViewController.h"

@interface BaseViewController ()<TYPopoverViewDelegate,LoginViewDelegate,FindPsWordViewDelegate,KeyboardDelegate,ValidateViewDelegate,RegistViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *windowView;
    NSString *uid;
    NSString *pwd;
    NSString *tel;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    [self loadNavItems];
    
    windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth,kHeight)];
    windowView.backgroundColor = [UIColor blackColor];
    windowView.alpha = 0.4;
    
    
}


- (void)loadNavItems
{
    UIButton * searchItem =[UIButton buttonWithType:UIButtonTypeCustom];
    searchItem.frame =CGRectMake(kWidth-150, 0, 30, 30);
    [searchItem setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [searchItem addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1= [[UIBarButtonItem alloc] initWithCustomView:searchItem];
    
    UIButton * menuItem =[UIButton buttonWithType:UIButtonTypeCustom];
    menuItem.frame =CGRectMake(searchItem.frame.origin.x+searchItem.frame.size.width-4, 0, 30, 30);
    [menuItem setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:menuItem];
    [menuItem addTarget:self action:@selector(navItemRight:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:item2,item1, nil];
}

- (void)search
{
    NSArray *arr = self.navigationController.viewControllers;
    for (UIViewController *subView in arr) {
        if ([subView isKindOfClass:[SearchViewController class]]) {
            [self.navigationController popToViewController:subView animated:NO];
            return;
        }
    }
    
    SearchViewController *search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


- (void)navItemRight:(UIButton *)btn
{
    CGPoint point = CGPointMake(kWidth-60, btn.frame.origin.y + btn.frame.size.height+15);
    
    NSArray * titles = @[@"我的成长", @"账户", @"消息",@"设置"];
    NSArray *  images = @[@"video", @"account", @"message", @"setting"];
    
    TYPopoverView *popView = [[TYPopoverView alloc] initWithPoint:point titles:titles images:images];
    popView.delegate = self;
    popView.selectRowAtIndex = ^(NSInteger index)
    {
        NSLog(@"select index:%ld", (long)index);
    };
    
    [popView show];
}

#pragma mark TYPopoverView_delegate
- (void)TYPopoverViewTouch:(UIButton *)btn view:(TYPopoverView *)view
{
    NSArray *array = self.navigationController.viewControllers;
    switch (btn.tag) {
        case -1:
        {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:windowView];
            LoginView *loginView = [[LoginView alloc] init];
            loginView.center = CGPointMake(kWidth/2, kHeight+loginView.frame.size.height/2);
            loginView.delegate = self;
            loginView.keyboardDelegate = self;
            [window addSubview:loginView];
            
            [UIView animateWithDuration:0.3 animations:^{
                loginView.center = CGPointMake(kWidth/2, kHeight/2);
            }];
        }
            break;
        case -2:
        {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:windowView];
            RegistView *loginView = [[RegistView alloc] init];
            loginView.center = CGPointMake(kWidth/2, kHeight+loginView.frame.size.height/2);
            loginView.delegate = self;
            loginView.keyboardDelegate = self;
            [window addSubview:loginView];
            
            [UIView animateWithDuration:0.3 animations:^{
                loginView.center = CGPointMake(kWidth/2, kHeight/2);
            }];
            
        }
            break;
        case 0:
        {
            if ([SystemConfig sharedInstance].isUserLogin) {
                VideoCenterController *center = [[VideoCenterController alloc] init];
                [self.navigationController pushViewController:center animated:YES];
            }else{
                [RemindView showViewWithTitle:@"请先登录!" location:TOP];

            }
        }
            break;
        case 1:
        {
            if ([SystemConfig sharedInstance].isUserLogin) {
                for (UIViewController *subVC in array) {
                    if ([subVC isKindOfClass:[AccountController class]]) {
                        [self.navigationController popToViewController:subVC animated:NO];
                        return;
                    }
                }
                AccountController *account = [[AccountController alloc] init];
                [self.navigationController pushViewController:account animated:YES];
            }else{
                [RemindView showViewWithTitle:@"请先登录!" location:TOP];
            }
        }
            break;
        case 2:
        {
            for (UIViewController *subVC in array) {
                if ([subVC isKindOfClass:[MessageController class]]) {
                    [self.navigationController popToViewController:subVC animated:NO];
                    return;
                }
            }
            MessageController *message = [[MessageController alloc] init];
            [self.navigationController pushViewController:message animated:YES];
        }
            break;
        case 3:
        {
            for (UIViewController *subVC in array) {
                if ([subVC isKindOfClass:[SettingController class]]) {
                    [self.navigationController popToViewController:subVC animated:NO];
                    return;
                }
            }
            SettingController *set = [[SettingController alloc] init];
            [self.navigationController pushViewController:set animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)imageViewClick:(TYPopoverView *)view
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark LoginView_delegate
- (void)loginViewBtnClick:(UIButton *)btn view:(LoginView *)view
{
    switch (btn.tag) {
            //移除
        case 1:
        {
            [windowView removeFromSuperview];
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
            [HttpTool postWithPath:@"getLogin" params:param success:^(id JSON, int code, NSString *msg) {
                
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
                    if (item.img&&item.img.length!=0) {
                        [dict setValue:item.img forKey:@"img"];
                    }
                    [userDefaults setValue:dict forKey:@"userInfo"];
                    [userDefaults synchronize];
                    
                    //移除登陆视图
                    [windowView removeFromSuperview];
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
                NSLog(@"%@",error);
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


#pragma mark findView_delegate
- (void)findViewBtnClick:(UIButton *)btn view:(FindPsWordView *)view
{
    switch (btn.tag) {
            //移除
        case 1:
        {
            [windowView removeFromSuperview];
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
            ValidateView *validateView = [[ValidateView alloc] initWithTitle:@"1545454554"];
            validateView.delegate = self;
            validateView.keyboardDelegate = self;
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            validateView.center = CGPointMake(kWidth/2, kHeight+validateView.frame.size.height/2);
            [window addSubview:validateView];
            [UIView animateWithDuration:0.3 animations:^{
                view.center = CGPointMake(kWidth/2,-view.frame.size.height/2);
                validateView.center = CGPointMake(kWidth/2, kHeight/2);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark validateView_delegate
- (void)validateViewBtnClick:(UIButton *)btn view:(ValidateView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (btn.tag) {
        case 1:
        {
            [windowView removeFromSuperview];
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
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",view.yzmView.textField.text,@"code", nil];
            [MBProgressHUD showHUDAddedTo:window animated:YES];
            [HttpTool postWithPath:@"getSaveUser" params:param success:^(id JSON, int code, NSString *msg) {
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
                //注册成功
                if (code == 100) {
                    //注册成功后调用登录接口登录
                    
                    [windowView removeFromSuperview];
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

#pragma mark registView_delegate
- (void)registViewBtnClick:(UIButton *)btn view:(RegistView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (btn.tag) {
        case 1:
        {
            [windowView removeFromSuperview];
            [UIView animateWithDuration:0.3 animations:^{
                view.center = CGPointMake(kWidth/2, kHeight+view.frame.size.height/2);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
            break;
        //获取验证码
        case 2:
        {
            if (view.telView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入手机号" location:TOP];
                return;
            }
            if (![AuthencateTool isValidPhone:view.telView.textField.text]) {
                [RemindView showViewWithTitle:@"手机号不合法" location:TOP];
                return;
            }

            if (view.nameView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入用户名" location:TOP];
                return;
            }
            if (view.passwordView.textField.text.length==0) {
                [RemindView showViewWithTitle:@"请输入密码" location:TOP];
                return;
            }
            
            tel = view.telView.textField.text;
            pwd = view.passwordView.textField.text;
            
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:view.telView.textField.text,@"phone",view.nameView.textField.text,@"username",view.passwordView.textField.text,@"userpwd", nil];
            [MBProgressHUD showHUDAddedTo:window animated:YES];
            [HttpTool postWithPath:@"getRegister" params:param success:^(id JSON, int code, NSString *msg) {
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
                if (code == 100) {
                    uid = JSON[@"data"];
                    ValidateView *validateView = [[ValidateView alloc] initWithTitle:view.telView.textField.text];
                    validateView.delegate = self;
                    validateView.keyboardDelegate = self;
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
                [MBProgressHUD hideAllHUDsForView:window animated:YES];
                [RemindView showViewWithTitle:offline location:TOP];
            }];
            
        }
            break;
            //用户协议
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}

//注册成功才调用该方法
- (void)login:(NSString *)phone pwd:(NSString *)password
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",password,@"userpwd", nil];
    //登陆请求
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    [HttpTool postWithPath:@"getLogin" params:param success:^(id JSON, int code, NSString *msg) {
        [MBProgressHUD hideAllHUDsForView:window animated:YES];
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

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //上传图片
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
