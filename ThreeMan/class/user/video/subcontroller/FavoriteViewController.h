//
//  FavoriteViewController.h
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RootViewController.h"
#import "NoDataView.h"

@interface FavoriteViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    ErrorView *networkError;
    NoDataView *noDataView;
}


- (void)edit:(BOOL)editting;


@end
