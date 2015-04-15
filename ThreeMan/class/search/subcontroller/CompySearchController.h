//
//  CompySearchController.h
//  ThreeMan
//
//  Created by tianj on 15/3/31.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BaseViewController.h"

@interface CompySearchController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@property (nonatomic,copy) NSString *keywords;

@end
