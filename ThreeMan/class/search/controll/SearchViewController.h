//
//  SearchViewController.h
//  ThreeMan
//
//  Created by Tianj on 15/3/28.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UITableView *_resultTableView;
}
@end
