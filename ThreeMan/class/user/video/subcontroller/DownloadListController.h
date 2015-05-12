//
//  DownloadListController.h
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RootViewController.h"

@interface DownloadListController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_headViewArray;
    NSMutableArray *_finishedArray;
    NSMutableArray *_unFinishedArray;
    UITableView *_tableView;
    
}

- (void)edit:(BOOL)editting;

@end
