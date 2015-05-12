//
//  RootViewController.h
//  多线程下载
//
//  Created by tianj on 15/4/10.
//  Copyright (c) 2015年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}


@end
