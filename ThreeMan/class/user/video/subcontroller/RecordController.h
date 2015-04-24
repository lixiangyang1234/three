//
//  RecordController.h
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RootViewController.h"

@interface RecordController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *headViewArray;
    UITableView *_tableView;
}
- (void)edit:(BOOL)editting;


@end
