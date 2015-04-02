//
//  FeedBackController.h
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedBackController : BaseViewController<UITextViewDelegate>
{
    UITextView *_textView;
    UIScrollView *_scrollView;
    BOOL fisrtEdit;  //第一次编辑
}
@end
