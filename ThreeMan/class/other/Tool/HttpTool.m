
#import "HttpTool.h"
#import "AFHTTPRequestOperationManager.h"
#import <objc/message.h>
#import "AFHTTPRequestOperation.h"

@implementation HttpTool

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    NSString *pathStr = [NSString stringWithFormat:@"http://ebingoo.bingoso.com/index.php?s=/Home/Api/%@",path];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    //拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    NSString *time =[DateManeger getCurrentTimeStamps];
    NSString *uuid = [SystemConfig sharedInstance].uuidStr;
    NSString *md5 = [NSString stringWithFormat:@"%@%@%@",uuid,time,@"ju34s4&6d567nuwe678l89kjdf56o34iw!e"];
    md5 = [md5 md5Encrypt];
    NSString *ios =@"ios";
    NSString *key = @"CFBundleShortVersionString";
    // 1.从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    [allParams setObject:ios forKey:@"os"];
    [allParams setObject:time forKey:@"time"];
    [allParams setObject:uuid forKey:@"uuid"];
    [allParams setObject:md5 forKey:@"secret"];
    [allParams setObject:version forKey:@"version"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:pathStr parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    
}
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView
{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority | SDWebImageRetryFailed];
}
@end
