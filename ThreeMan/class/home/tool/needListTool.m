//
//  needListTool.m
//  ThreeMan
//
//  Created by YY on 15-4-15.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "needListTool.h"
#import "needListModel.h"
@implementation needListTool
//需求列表
+(void)StatusWithNeedListId:(NSString *)needid needType:(NSString *)type Success:(StatusSuccessBlock)success failure:(StatusFailBlock)failure{
    //    self.categoryId =[NSString stringWithFormat:@"%d",7];
    NSDictionary *parmDic =[NSDictionary dictionaryWithObjectsAndKeys:needid,@"id",type,@"type" ,nil];
    [HttpTool postWithPath:@"getNeed1List" params:parmDic success:^(id JSON, int code, NSString *msg) {
        NSMutableArray *status =[[NSMutableArray alloc]init];
        NSDictionary *dict =JSON[@"data"][@"subject_list"];
        NSLog(@"%@---%@",JSON,dict);

        if (![dict isKindOfClass:[NSNull class]]) {
            needListModel *needModel =[[needListModel alloc]initWithDictonaryForCategory:dict];
            [status addObject:needModel];
            success(status);
        }else{
            success(nil);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
