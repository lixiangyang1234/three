//
//  MemorySizeView.m
//  ThreeMan
//
//  Created by tianj on 15/4/8.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "MemorySizeView.h"
#import "AdaptationSize.h"

#define totalWidth (kWidth-90-10)

@interface MemorySizeView ()
{
    UILabel *freeLabel;
    UILabel *usedLabel;
    UIView *progressView;
}
@end

@implementation MemorySizeView

- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = HexRGB(0xffffff);
        
        self.frame = CGRectMake(0, 0, kWidth,40);
        
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    NSString *str = @"可用空间";
    CGSize size = [AdaptationSize getSizeFromString:str Font:[UIFont systemFontOfSize:12] withHight:15 withWidth:CGFLOAT_MAX];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5,size.width,15)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = HexRGB(0x323232);
    titleLabel.text = str;
    [self addSubview:titleLabel];
    
    freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20,size.width,15)];
    freeLabel.backgroundColor = [UIColor clearColor];
    freeLabel.textAlignment = NSTextAlignmentCenter;
    freeLabel.font = [UIFont systemFontOfSize:12];
    freeLabel.textColor = HexRGB(0x323232);
    freeLabel.text = [NSString stringWithFormat:@"%.1fG",[CommenHelper avaibleMemory]];
    [self addSubview:freeLabel];
    
    
    
    UIView *pgBgView = [[UIView alloc] initWithFrame:CGRectMake(90,10,totalWidth,2)];
    pgBgView.backgroundColor = HexRGB(0x959595);
    [self addSubview:pgBgView];
    
    CGFloat width = totalWidth*(([CommenHelper totalMemory]-[CommenHelper avaibleMemory])/[CommenHelper totalMemory]);
    
    progressView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,2)];
    progressView.backgroundColor = HexRGB(0x1c8cc6);
    [pgBgView addSubview:progressView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(pgBgView.frame.origin.x,20, 9, 9)];
    imageView.image = [UIImage imageNamed:@"space"];
    [self addSubview:imageView];
    
    usedLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+5,imageView.frame.origin.y,150,10)];
    usedLabel.backgroundColor = [UIColor clearColor];
    usedLabel.font = [UIFont systemFontOfSize:11];
    usedLabel.textColor = HexRGB(0x323232);
    usedLabel.text = [NSString stringWithFormat:@"已占用%.1fG",[CommenHelper totalMemory]-[CommenHelper avaibleMemory]];
    [self addSubview:usedLabel];
}

- (void)reloadView
{
    freeLabel.text = [NSString stringWithFormat:@"%.1fG",[CommenHelper avaibleMemory]];
    usedLabel.text = [NSString stringWithFormat:@"已占用%.1fG",[CommenHelper totalMemory]-[CommenHelper avaibleMemory]];
    CGFloat width = totalWidth*(([CommenHelper totalMemory]-[CommenHelper avaibleMemory])/[CommenHelper totalMemory]);
    progressView.frame = CGRectMake(progressView.frame.origin.x,progressView.frame.origin.y, width,progressView.frame.size.height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
