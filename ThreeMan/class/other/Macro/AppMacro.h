
#ifndef MoneyMaker_AppMacro_h
#define MoneyMaker_AppMacro_h

//首次启动
#define First_Launched @"firstLaunch"

//系统版本
#define IsIos7 [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO
#define isRetina [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO

#define iPhone5 [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO

#define _iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define _iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define _iPhone6 ([UIScreen mainScreen].bounds.size.height == 667)

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif
//占位图片
#define placeHoderImage [UIImage imageNamed:@"index_banner_fail"]
#define placeHoderImage1 [UIImage imageNamed:@"index_icon_fail"]
#define placeHoderImage2 [UIImage imageNamed:@"index_require_small_fail"]
#define placeHoderImage3 [UIImage imageNamed:@"list_fail"]
#define placeHoderImage4 [UIImage imageNamed:@"index_require_big_fail"]

//加载图片
//#define LOADIMAGE(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
//#define LOADPNGIMAGE(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:@"png"]]
#define LOADPNGIMAGE(file) [UIImage imageNamed:file]
#define Rect(x,y,width,height) CGRectMake(x, y, width, height)
//可拉伸的图片

#define ResizableImage(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define ResizableImageWithMode(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]

//App
#define kApp ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kNav ((AppDelegate *)[UIApplication sharedApplication].delegate.navigationController)

//color
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]//十六进制转换



#define PxFont(px) (0.75*px)//字体大小转换

//设备屏幕尺寸
#define kHeight   [UIScreen mainScreen].bounds.size.height
#define kWidth    [UIScreen mainScreen].bounds.size.width

//拨打电话
#define canTel                 [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:"]
#define tel(phoneNumber)      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]]
#define telprompt(phoneNumber) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]]]

//打开URL
#define canOpenURL(appScheme) [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]]
#define openURL(appScheme) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]]
#endif

#define offline @"网络异常"
#define serviceWrong @"服务器故障，请稍后再试"

//判断字典dic中键key对应的值是否为空
#define isNull(dic,key) [[dic objectForKey:key] isKindOfClass:[NSNull class]]?YES:NO

#define kBaseURL @"http://192.168.1.122/sanshenxing/index.php?s=/Home/Api/"


//通知名称
#define addNewDownload @"newDownload"  //添加了一个新的下载
#define playMessage @"playMessage"   //播放或打开文件时 发送的通知

// 2.日志输出宏定义
#ifdef DEBUG
// 调试状态
#define NSLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define NSLog(...)
#endif

// ---------------------公司首页页面
