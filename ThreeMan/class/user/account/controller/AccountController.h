//
//  AccountController.h
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "LeftTitleController.h"
#import "ErrorView.h"

@interface AccountController : LeftTitleController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    ErrorView *nodataView;
}
@end
