//
//  EditInfoController.m
//  ThreeMan
//
//  Created by tianj on 15/5/19.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "EditInfoController.h"
#import "DisplayEditView.h"
#import "ModifyEditView.h"

#define btnTitleFont [UIFont systemFontOfSize:16]

@interface EditInfoController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *iconImageView;
    UILabel *nickLabel;
    DisplayEditView *telView;
    ModifyEditView *nickView;
}
@end

@implementation EditInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe8e8e8);
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI
{
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth,388/2)];
    topImageView.image = [UIImage imageNamed:@"banner_bg"];
    topImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    //返回按钮
    CGFloat y = 0;
    if (IsIos7) {
        y=20;
    }
    UIImage *image = [UIImage imageNamed:@"nav_return.png"];
    NSString *str = @"修改资料";
    UIButton *backItem = [UIButton buttonWithType:UIButtonTypeCustom];
    backItem.titleLabel.font = btnTitleFont;
    CGSize size = [AdaptationSize getSizeFromString:str Font:btnTitleFont withHight:44 withWidth:CGFLOAT_MAX];
    backItem.frame = CGRectMake(10,y, size.width+image.size.width,44);
    // 设置普通背景图片
    [backItem setImage:image forState:UIControlStateNormal];
    [backItem setTitle:str forState:UIControlStateNormal];
    [backItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:backItem];
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    iconImageView.layer.cornerRadius = iconImageView.frame.size.width/2;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.userInteractionEnabled = YES;
    iconImageView.center = CGPointMake(topImageView.frame.size.width/2, topImageView.frame.size.height/2+10);
    [iconImageView setImageWithURL:[NSURL URLWithString:[SystemConfig sharedInstance].userInfo.img] placeholderImage:placeHoderImage1];
    [topImageView addSubview:iconImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [iconImageView addGestureRecognizer:tap];

    nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,iconImageView.frame.origin.y+iconImageView.frame.size.height+20,topImageView.frame.size.width,25)];
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.textColor = HexRGB(0xffffff);
    nickLabel.textAlignment = NSTextAlignmentCenter;
    nickLabel.text = [SystemConfig sharedInstance].userInfo.username;
    [topImageView addSubview:nickLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, topImageView.frame.origin.y+topImageView.frame.size.height+19,kWidth-10*2, 41*2)];
    bgView.backgroundColor = HexRGB(0xffffff);
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderColor = HexRGB(0xcacaca).CGColor;
    bgView.layer.borderWidth = 0.5;
    [self.view addSubview:bgView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height/2,bgView.frame.size.width,0.5)];
    line.backgroundColor = HexRGB(0xcacaca);
    [bgView addSubview:line];
    
    nickView = [[ModifyEditView alloc] initWithFrame:CGRectMake(0, 0,bgView.frame.size.width,bgView.frame.size.height/2)];
    nickView.titleLabel.text = @"昵称";
    nickView.textField.text = [SystemConfig sharedInstance].userInfo.username;
    [bgView addSubview:nickView];
    
    telView = [[DisplayEditView alloc] initWithFrame:CGRectMake(0,bgView.frame.size.height/2,bgView.frame.size.width,bgView.frame.size.height/2)];
    telView.titleLabel.text = @"手机号码";
    telView.contentLabel.text = [SystemConfig sharedInstance].userInfo.phone;
    [bgView addSubview:telView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, bgView.frame.origin.y+bgView.frame.size.height+15,kWidth-10*2, 40);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)btnDown
{
    if (nickView.textField.text.length == 0) {
        [RemindView showViewWithTitle:@"昵称不能为空" location:MIDDLE];
        return;
    }else{
        
    }
}

- (void)tap
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (BOOL)shouldAutorotate

{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
    
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
