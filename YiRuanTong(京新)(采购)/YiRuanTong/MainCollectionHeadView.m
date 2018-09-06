//
//  MainCollectionHeadView.m
//  YiRuanTong
//
//  Created by apple on 17/7/21.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "MainCollectionHeadView.h"

@implementation MainCollectionHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *headview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, self.frame.size.height)];
    headview.image = [UIImage imageNamed:@"slideshow01"];
    [self addSubview:headview];
}
@end
