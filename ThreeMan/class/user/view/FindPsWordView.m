//
//  FindPsWordView.m
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "FindPsWordView.h"

@implementation FindPsWordView


- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = HexRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        self.frame = CGRectMake(0, 0, kWidth-20,250);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [self addGestureRecognizer:tap];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];

        [self buildUI];
    }
    return self;
}


- (void)tapDown
{
    [self.telView.textField resignFirstResponder];
    [self.passwordView.textField resignFirstResponder];
}


- (void)resignResponder
{
    [self.telView.textField resignFirstResponder];
    [self.passwordView.textField resignFirstResponder];
}

- (void)buildUI
{
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 30, 92, 32)];
    logoView.image = [UIImage imageNamed:@"bigLogo"];
    [self addSubview:logoView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(logoView.frame.origin.x+logoView.frame.size.width+33, 30, 92, 32)];
    rightView.image = [UIImage imageNamed:@"title"];
    [self addSubview:rightView];
    
    self.telView = [[ImageFieldView alloc] initWithFrame:CGRectMake(30,logoView.frame.origin.y+logoView.frame.size.height+30,self.frame.size.width-30*2,30)];
    self.telView.imgView.image = [UIImage imageNamed:@"tel"];
    self.telView.textField.tag = 1000;
    self.telView.textField.placeholder = @"手机号码";
    self.telView.textField.delegate = self;
    self.telView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.telView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10,self.telView.frame.origin.y+self.telView.frame.size.height,self.frame.size.width-10*2, 0.5)];
    line1.backgroundColor = HexRGB(0xd1d1d1);
    [self addSubview:line1];
    
    
    self.passwordView = [[ImageFieldView alloc] initWithFrame:CGRectMake(30,self.telView.frame.origin.y+self.telView.frame.size.height+15,self.telView.frame.size.width,30)];
    self.passwordView.textField.tag = 1001;
    self.passwordView.imgView.image = [UIImage imageNamed:@"lock2"];
    self.passwordView.textField.placeholder = @"密码";
    self.passwordView.textField.secureTextEntry = YES;
    self.passwordView.textField.delegate = self;
    [self addSubview:self.passwordView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10,self.passwordView.frame.origin.y+self.passwordView.frame.size.height,self.frame.size.width-10*2, 0.5)];
    line2.backgroundColor = HexRGB(0xd1d1d1);
    [self addSubview:line2];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, self.passwordView.frame.origin.y+self.passwordView.frame.size.height+30, self.frame.size.width-20, 35);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"验证码验证" forState:UIControlStateNormal];
    loginBtn.tag = 2;
    [loginBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(self.frame.size.width-10-23,10,23, 23);
    deleteBtn.tag = 1;
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    
}

- (void)btnDown:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(findViewBtnClick:view:)]) {
        [self.delegate findViewBtnClick:btn view:self];
    }
}

- (void)keyboardWillShow:(NSNotification *)notify
{
    NSDictionary *dic = [notify userInfo];
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardShow:frame:)]) {
        [self.keyboardDelegate keyboardShow:self frame:keyboardFrame];
    }
}

#pragma mark textField_delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==1001) {
        return YES;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    if (!basic) {
        return NO;
    }
    return YES;
}


- (void)keyboardWillHiden
{
    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardHiden:)]) {
        [self.keyboardDelegate keyboardHiden:self];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
