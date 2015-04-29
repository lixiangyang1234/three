//
//  DemandFavController.h
//  ThreeMan
//
//  Created by tianj on 15/4/24.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RootViewController.h"
#import "EditView.h"
#import "NoDataView.h"

@interface DemandFavController : RootViewController<UITableViewDataSource,UITableViewDelegate,EditViewDelegate,NoDataViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    EditView *editView;
    ErrorView *networkError;
    ErrorView *noDataView;
    BOOL isEditting;
}

- (void)edit:(BOOL)editting;



@end
