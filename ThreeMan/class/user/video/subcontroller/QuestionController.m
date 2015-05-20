//
//  QuestionController.m
//  ThreeMan
//
//  Created by tianj on 15/4/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "QuestionController.h"
#import "RemindView.h"

@interface QuestionController ()

@end

@implementation QuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setLeftTitle:@"我要提问"];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,kWidth,kHeight-64)];
    _scrollView.backgroundColor = HexRGB(0xf3f3f3);
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];
    
    UIImage *image = [UIImage imageNamed:@"title"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.center = CGPointMake(kWidth/2,kHeight-64-image.size.height/2-30);
    [_scrollView addSubview:imageView];
    
    [self buildUI];
}

#pragma mark 键盘弹出
- (void)keyboardWillShow:(NSNotification *)notify
{
    NSDictionary *dic = [notify userInfo];
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardFrame.size.height,0)];
}


#pragma mark 键盘隐藏
- (void)keyboardWillHiden
{
    [UIView animateWithDuration:0.21 animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0,0,0)];
    }];
}



- (void)buildUI
{
    UIImage *image = [UIImage imageNamed:@"questionTitle"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,image.size.width, image.size.height)];
    imageView.image = image;
    imageView.center = CGPointMake(kWidth/2, 12+imageView.frame.size.height/2);
    [_scrollView addSubview:imageView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8,imageView.frame.size.height+imageView.frame.origin.y+10, kWidth-8*2, 150)];
    _textView.layer.cornerRadius = 2.0f;
    _textView.layer.masksToBounds = YES;
    _textView.text = @"请输入您的问题!";
    _textView.delegate = self;
    _textView.textColor = HexRGB(0x9a9a9a);
    _textView.layer.borderColor = HexRGB(0xcacaca).CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.backgroundColor = HexRGB(0xffffff);
    [_scrollView addSubview:_textView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y+_textView.frame.size.height+24,_textView.frame.size.width, 41);
    [btn setTitle:@"提交提问" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
}

//按钮点击
- (void)btnDown
{
    [self.view endEditing:YES];
    if (!fisrtEdit||_textView.text.length==0) {
        [RemindView showViewWithTitle:@"请输入您的问题" location:TOP];
    }else{
        //上传数据
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.sid,@"sid",_textView.text,@"title", nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HttpTool postWithPath:@"getQuestion" params:param success:^(id JSON, int code, NSString *msg) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:msg location:TOP];
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:offline location:TOP];
        }];
    }
}

#pragma mark textView_delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!fisrtEdit) {
        fisrtEdit = YES;
        _textView.text = @"";
        _textView.textColor = HexRGB(0x323232);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
