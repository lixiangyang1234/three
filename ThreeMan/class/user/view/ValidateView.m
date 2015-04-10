//
//  ValidateView.m
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "ValidateView.h"
#import "AdaptationSize.h"

#define textFont [UIFont systemFontOfSize:14]
#define MAX_SECOND 10


@interface ValidateView ()
{
    int second;
    UIButton *sendBtn;
}
@end

@implementation ValidateView


- (id)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        
        self.title = title;
        second = MAX_SECOND;
        self.backgroundColor = HexRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        self.frame = CGRectMake(0, 0, kWidth-20,280);
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
    [self.yzmView.textField resignFirstResponder];
}


- (void)buildUI
{
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 30, 92, 32)];
    logoView.image = [UIImage imageNamed:@"bigLogo"];
    [self addSubview:logoView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(logoView.frame.origin.x+logoView.frame.size.width+33, 30, 92, 32)];
    rightView.image = [UIImage imageNamed:@"title"];
    [self addSubview:rightView];
    
    NSString *str1 = @"您的手机";
    CGSize size = [AdaptationSize getSizeFromString:str1 Font:textFont withHight:20 withWidth:CGFLOAT_MAX];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30,logoView.frame.origin.y+logoView.frame.size.height+36,size.width,20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = textFont;
    label1.text = str1;
    label1.textColor = HexRGB(0x9a9a9a);
    [self addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x+label1.frame.size.width+2,label1.frame.origin.y,120,20)];
    label2.font = textFont;
    label2.text = self.title;
    label2.textColor = HexRGB(0x323232);
    [self addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x,label1.frame.origin.y+label1.frame.size.height+10,self.frame.size.width-label1.frame.origin.x,20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = textFont;
    label3.text = @"将会收到一条验证码短信,请注意查收";
    label3.textColor = HexRGB(0x9a9a9a);
    [self addSubview:label3];
    
    self.yzmView = [[ImageFieldView alloc] initWithFrame:CGRectMake(30,label3.frame.origin.y+label3.frame.size.height+15,self.frame.size.width-30*2-80,30)];
    self.yzmView.imgView.image = [UIImage imageNamed:@"bell"];
    self.yzmView.textField.placeholder = @"验证码";
    self.yzmView.textField.delegate = self;
    [self addSubview:self.yzmView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10,self.yzmView.frame.origin.y+self.yzmView.frame.size.height,self.frame.size.width-10*2, 0.5)];
    line1.backgroundColor = HexRGB(0xd1d1d1);
    [self addSubview:line1];

    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, self.yzmView.frame.origin.y+self.yzmView.frame.size.height+30, self.frame.size.width-20, 35);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
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
    
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.frame.size.width-30-80,self.yzmView.frame.origin.y,80, 30);
    [sendBtn setTitleColor:HexRGB(0x323232) forState:UIControlStateNormal];
    sendBtn.tag = 2;
    [sendBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)",second] forState:UIControlStateNormal];

    sendBtn.userInteractionEnabled = NO;
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];

    [self changeUI];
}

#pragma mark 更改获取验证码UI
- (void)changeUI
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeUI) object:nil];
    second--;
    if (second ==0) {
        second = MAX_SECOND;
        sendBtn.userInteractionEnabled = YES;
        [sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }else{
        [sendBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)",second] forState:UIControlStateNormal];
        [self performSelector:_cmd withObject:nil afterDelay:1];
    }
}

//发送验证码
- (void)send
{
    sendBtn.userInteractionEnabled = NO;
    [self changeUI];
}


- (void)btnDown:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(validateViewBtnClick:view:)]) {
        [self.delegate validateViewBtnClick:btn view:self];
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

- (void)keyboardWillHiden
{
    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardHiden:)]) {
        [self.keyboardDelegate keyboardHiden:self];
    }
}

#pragma mark textField_delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
