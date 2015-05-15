//
//  AppDelegate.m
//  ThreeMan
//
//  Created by YY on 15-3-4.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "AppDelegate.h"
#import "NewfeatureController.h"
#import "WBNavigationController.h"
#import "MainControllerViewController.h"
#import "SystemConfig.h"
#import "SSKeychain.h"
#import "AFNetworkReachabilityManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[DBTool shareDBToolClass] openDB];

    
    
    //获取用户uuid
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.promo.threeMan" account:@"uuid"];
    //第一次下载程序的时候存储
    if (retrieveuuid == nil || [retrieveuuid isEqualToString:@""]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid!=NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        retrieveuuid = [NSString stringWithFormat:@"%@",uuidStr];
        [SSKeychain setPassword:retrieveuuid forService:@"com.promo.threeMan" account:@"uuid"];
    }
    [SystemConfig sharedInstance].uuidStr = retrieveuuid;
    
    
    NSString *key = @"CFBundleShortVersionString";
    
    // 1.从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([version isEqualToString:saveVersion]) { // 不是第一次使用这个版本
        // 显示状态栏
        application.statusBarHidden = NO;
        
        MainControllerViewController *main = [[MainControllerViewController alloc] init];
        
        WBNavigationController *nav =[[WBNavigationController alloc]initWithRootViewController:main];
        self.window.rootViewController =nav;
        } else { // 版本号不一样：第一次使用新版本
        // 将新版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 显示版本新特性界面
        self.window.rootViewController = [[NewfeatureController alloc] init];
    }
    
    [self autoLogin];
    
    
    //检查网络
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    BOOL reachable = reachability.reachable;
    if (!reachable) {
        [RemindView showViewWithTitle:@"网络未连接" location:MIDDLE];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}




- (void)autoLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userInfo = [userDefaults objectForKey:@"userInfo"];
    if (userInfo) {
        NSString *uid = [userInfo objectForKey:@"uid"];
        NSString *username = [userInfo objectForKey:@"username"];
        NSString *phone = [userInfo objectForKey:@"phone"];
        NSString *type = [userInfo objectForKey:@"type"];
        NSString *img = [userInfo objectForKey:@"img"];
        
        if (uid&&username&&phone&&type) {
            [SystemConfig sharedInstance].isUserLogin = YES;
            [SystemConfig sharedInstance].uid = uid;
            UserInfo *userItem = [[UserInfo alloc] init];
            userItem.uid = uid;
            userItem.username = username;
            userItem.phone = phone;
            userItem.type = type;
            if (img&&img.length!=0) {
                userItem.img = img;
            }
            
            [SystemConfig sharedInstance].userInfo = userItem;
        }
    }
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    self.backgroundSessionCompletionHandler = completionHandler;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
