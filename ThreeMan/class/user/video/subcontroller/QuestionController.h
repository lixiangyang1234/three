//
//  QuestionController.h
//  ThreeMan
//
//  Created by tianj on 15/4/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "LeftTitleController.h"

@interface QuestionController : LeftTitleController<UITextViewDelegate>
{
    UITextView *_textView;
    UIScrollView *_scrollView;
    BOOL fisrtEdit;  //第一次编辑
}


@end
