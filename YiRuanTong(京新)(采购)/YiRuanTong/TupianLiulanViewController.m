//
//  TupianLiulanViewController.m
//  YiRuanTong
//
//  Created by lx on 15/5/26.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "TupianLiulanViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"

@interface TupianLiulanViewController ()<UIScrollViewDelegate>
{
    NSMutableArray *_imgArray;
    UIPageControl *_pageControl;
    UIScrollView *_scrollerView;
}

@end

@implementation TupianLiulanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品图片";
    self.view.backgroundColor = [UIColor whiteColor];
    _imgArray = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self pageload];
    [self imageRequest];

}

- (void)pageload
{
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    _scrollerView.contentSize = CGSizeMake(KscreenWidth * 4, 0);
    _scrollerView.delegate = self;
    _scrollerView.directionalLockEnabled = YES;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.pagingEnabled = YES;
    _scrollerView.bounces = NO;
    
    [self.view addSubview:_scrollerView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/KscreenWidth;
}

- (void)imageRequest
{
    NSString *dataStr = _dataDic[@"pathlist"];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *imagearr  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *dic in imagearr) {
        NSString *str = [dic objectForKey:@"imgpath"];
        [_imgArray addObject:str];
    }
    NSLog(@"图片地址%@",_imgArray);
        for (int i = 0; i < _imgArray.count; i++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KscreenWidth * i, 0, KscreenWidth, KscreenHeight - 64)];
            
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            NSString *imgAdd = [NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,_imgArray[i]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgAdd] placeholderImage:[UIImage imageNamed:@"zwtp.png"]];
            imageView.contentMode =  UIViewContentModeScaleAspectFit;
            NSLog(@"图片地址:%@",imgAdd);
            [_scrollerView addSubview:imageView];
        }
        //控制四个大图
        if (_imgArray.count > 1) {
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(KscreenWidth/2-70, KscreenHeight - 104, 140,30)];
            _pageControl.currentPage = 0;
            _pageControl.numberOfPages = _imgArray.count;
            _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
            _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            //    [_pageControl addTarget:self action:@selector(changeIma:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:_pageControl];
        }
        
    
}


@end
