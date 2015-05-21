//
//  MessageDetailController.m
//  ThreeMan
//
//  Created by tianj on 15/4/16.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "MessageDetailController.h"
#import "AdaptationSize.h"
#import "MessageDetailItem.h"

@interface MessageDetailController ()
{
    UIScrollView *_scrollView;
}
@end

@implementation MessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftTitle:@"详情"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [self.view addSubview:_scrollView];
    [self loadData];
}

- (void)loadData
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.uid,@"id", nil];
    [HttpTool postWithPath:@"getMessageList" params:param success:^(id JSON, int code, NSString *msg) {
        NSLog(@"%@",JSON);
        if (code == 100) {
            MessageDetailItem *item = [[MessageDetailItem alloc] init];
            [item setValuesForKeysWithDictionary:JSON[@"data"][@"message"]];
            [self buildUI:item];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [RemindView showViewWithTitle:offline location:MIDDLE];
    }];
}

- (void)buildUI:(MessageDetailItem *)item
{
    
    CGFloat topDes = 8;
    CGFloat leftDes = 8;
    CGFloat y = topDes;
    
    //图片背景
    UIView *imgBgView = [[UIView alloc] initWithFrame:CGRectMake(leftDes, y, kWidth-leftDes*2, 187)];
    imgBgView.backgroundColor = HexRGB(0xffffff);
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, imgBgView.frame.size.height,imgBgView.frame.size.width, 0.5)];
    line1.backgroundColor = HexRGB(0xcacaca);
    [imgBgView addSubview:line1];
    [_scrollView addSubview:imgBgView];
        
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,imgBgView.frame.size.width-5*2,imgBgView.frame.size.height-5*2)];
    [imgBgView addSubview:imageView];

    if (![item.image isKindOfClass:[NSNull class]]&&item.image&&item.image.length!=0) {
        imageView.image = [UIImage imageNamed:@""];
    }else{
        [imageView setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:placeHoderImage];
    }
    
    y = y+imgBgView.frame.size.height+8;
    //标题背景
    UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake(leftDes,y, kWidth-leftDes*2, 57)];
    titleBgView.backgroundColor = HexRGB(0xffffff);
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, titleBgView.frame.size.height,titleBgView.frame.size.width, 0.5)];
    line2.backgroundColor = HexRGB(0xcacaca);
    [titleBgView addSubview:line2];
    
    [_scrollView addSubview:titleBgView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, titleBgView.frame.size.width-12*2, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = item.title;
    titleLabel.textColor = HexRGB(0x323232);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [titleBgView addSubview:titleLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, titleBgView.frame.size.width-12*2,15)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.text = item.addtime;
    timeLabel.textColor = HexRGB(0x959595);
    timeLabel.font = [UIFont systemFontOfSize:13];
    [titleBgView addSubview:timeLabel];
    
    NSString *content = [NSString stringWithFormat:@"    %@",item.content];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = [AdaptationSize getSizeFromString:content Font:font withHight:CGFLOAT_MAX withWidth:(kWidth-20)];
    
    y = y+titleBgView.frame.size.height+8;
    //内容背景
    UIView *contenteBgView = [[UIView alloc] initWithFrame:CGRectMake(leftDes,y, kWidth-leftDes*2,size.height+24)];
    contenteBgView.backgroundColor = HexRGB(0xffffff);
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, contenteBgView.frame.size.height,contenteBgView.frame.size.width, 0.5)];
    line3.backgroundColor = HexRGB(0xcacaca);
    [contenteBgView addSubview:line3];
    [_scrollView addSubview:contenteBgView];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,12, contenteBgView.frame.size.width-12*2,size.height)];
    contentLabel.numberOfLines = 0;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = content;
    contentLabel.textColor = HexRGB(0x737373);
    contentLabel.font = font;
    [contenteBgView addSubview:contentLabel];
    
    [_scrollView setContentSize:CGSizeMake(kWidth, contenteBgView.frame.origin.y+contenteBgView.frame.size.height+20)];

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
