//
//  SearchViewController.h
//  ThreeMan
//
//  Created by Tianj on 15/3/28.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultHeaderView.h"


@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ResultHeaderViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UITableView *_resultTableView;
    NSMutableArray *_results;
    UITextField *_textField;
    CGRect frame;
    
    NSMutableArray *_videoArray;
    NSMutableArray *_companyArray;
    NSMutableArray *_subjectArray;
}
@end
