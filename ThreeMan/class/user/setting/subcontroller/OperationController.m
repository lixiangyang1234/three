//
//  OperationController.m
//  ThreeMan
//
//  Created by tianj on 15/4/20.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "OperationController.h"

@interface OperationController ()

@end

@implementation OperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"操作指南"];
    
    [self loadData];
    
}


- (void)loadData
{
    [HttpTool postWithPath:@"getOperation" params:nil success:^(id JSON, int code, NSString *msg) {
        if (code == 100) {
            NSLog(@"%@",JSON);
        }
    } failure:^(NSError *error) {
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
