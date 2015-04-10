//
//  RegistView.m
//  ThreeMan
//
//  Created by tianj on 15/4/7.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "RegistView.h"
#import "AdaptationSize.h"

#define protocalFont [UIFont systemFontOfSize:13]

@implementation RegistView

- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = HexRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        self.frame = CGRectMake(0, 0, kWidth-20,320);
        
        [self buildUI];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [self addGestureRecognizer:tap];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)tapDown
{
    [self.telView.textField resignFirstResponder];
    [self.passwordView.textField resignFirstResponder];
    [self.nameView.textField resignFirstResponder];
}

- (void)buildUI
{
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 30, 92, 32)];
    logoView.image = [UIImage imageNamed:@"bigLogo"];
    [self addSubview:logoView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(logoView.frame.origin.x+logoView.frame.size.width+33, 30, 92, 32)];
    rightView.image = [UIImage imageNamed:@"title"];
    [self addSubview:rightView];
    
    //手机号码
    self.telView = [[ImageFieldView alloc] initWithFrame:CGRectMake(30,logoView.frame.origin.y+logoView.frame.size.height+30,self.frame.size.width-30*2,30)];
    self.telView.imgView.image = [UIImage imageNamed:@"tel"];
    self.telView.textField.placeholder = @"手机号码";
    self.telView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.telView.textField.tag = 1000;
    [self addSubview:self.telView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10,self.telView.frame.origin.y+self.telView.frame.size.height+3,self.frame.size.width-10*2, 0.5)];
    line1.backgroundColor = HexRGB(0xd1d1d1);
    [self addSubview:line1];
    
    //用户名
    self.nameView = [[ImageFieldView alloc] initWithFrame:CGRectMake(30,self.telView.frame.origin.y+self.telView.frame.size.height+15,self.telView.frame.size.width,30)];
    self.nameView.imgView.image = [UIImage imageNamed:@"user"];
    self.nameView.textField.placeholder = @"用户名";
    self.nameView.textField.tag = 1001;
    [self addSubview:self.nameView];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10,self.nameView.frame.origin.y+self.nameView.frame.size.height+3,self.frame.size.width-10*2, 0.5)];
    line2.backgroundColor = HexRGB(0xd1d1d1);
    [self addSubview:line2];

    //密码
    self.passwordView = [[ImageFieldView alloc] initWithFrame:CGRectMake(30,self.nameView.frame.origin.y+self.nameView.frame.size.height+15,self.telView.frame.size.width,30)];
    self.passwordView.imgView.image = [UIImage imageNamed:@"lock2"];
    self.passwordView.textField.placeholder = @"密码";
    self.passwordView.textField.tag = 1002;
    [self addSubview:self.passwordView];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(10,self.passwordView.frame.origin.y+self.passwordView.frame.size.height+3,self.frame.size.width-10*2, 0.5)];
    line3.backgroundColor = HexRGB(0xd1d1d1);
    [self addSubview:line3];
    
    NSString *str = @"注册代表您同意";
    CGSize size = [AdaptationSize getSizeFromString:str Font:protocalFont withHight:CGFLOAT_MAX withWidth:CGFLOAT_MAX];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, self.passwordView.frame.origin.y+self.passwordView.frame.size.height+20, size.width,size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = str;
    label.textColor = HexRGB(0x323232);
    label.font = protocalFont;
    [self addSubview:label];
    
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *s = [dic objectForKey:@"CFBundleDisplayName"];
    
    NSString *str1 = [NSString stringWithFormat:@"《%@用户协议》",s];
    CGSize size1 = [AdaptationSize getSizeFromString:str1 Font:protocalFont withHight:CGFLOAT_MAX withWidth:CGFLOAT_MAX];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(label.frame.origin.x+label.frame.size.width,label.frame.origin.y,size1.width,size.height);
    [btn setTitle:str1 forState:UIControlStateNormal];
    btn.titleLabel.font = protocalFont;
    btn.tag = 3;
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:HexRGB(0x1582ba) forState:UIControlStateNormal];
    [self addSubview:btn];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0,btn.frame.size.height-1,btn.frame.size.width,1)];
    line4.backgroundColor = HexRGB(0x1582ba);
    [btn addSubview:line4];
    
    //获取验证码按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10,label.frame.origin.y+label.frame.size.height+20, self.frame.size.width-20, 35);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    loginBtn.tag = 2;
    [loginBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    
    //右上角删除
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(self.frame.size.width-10-23,10,23, 23);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.tag = 1;
    [self addSubview:deleteBtn];

}

- (void)btnDown:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(registViewBtnClick:view:)]) {
        [self.delegate registViewBtnClick:btn view:self];
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
    if (textField.tag==1001||textField.tag==1002) {
        return YES;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"123456789\n"] invertedSet];
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
