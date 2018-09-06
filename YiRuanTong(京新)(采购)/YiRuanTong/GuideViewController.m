//
//  GuideViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //显示导航页面隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    NSArray *guideImage = @[@"引导页.jpg",
                            @"引导页2.jpg",
                            @"引导页3.jpg",
                            @"引导页4.jpg"];
    //创建滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    //设置显示内容尺寸
    scrollView.contentSize = CGSizeMake(KscreenWidth*guideImage.count, KscreenHeight);
    //设置分页
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    for (int i = 0; i < guideImage.count; i ++) {
        NSString *image = guideImage[i];
        UIImageView *guideImage = [[UIImageView alloc] initWithFrame:CGRectMake(i*KscreenWidth, KscreenHeight, KscreenWidth, KscreenHeight)];
        guideImage.image = [UIImage imageNamed:image];
        [scrollView addSubview:guideImage];
        }
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    //    scrollView.contentOffset.x    x方向的偏移量
    //    scrollView.contentSize.width  显示内容的宽度
    //    scrollView.width              一页的宽度
//    NSLog(@"scrollView.width：%f",scrollView.width);
//    NSLog(@"scrollView.contentSize.width: %f",scrollView.contentSize.width);
//    
    //滑动到最后的时候
    //    scrollView.contentOffset.x - (scrollView.contentSize.width-scrollView.width) = 0;
    
    CGFloat sub = scrollView.contentOffset.x - (scrollView.contentSize.width-KscreenWidth);
    
    if (sub > 30) {
        
        //显示状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //取得当前的主window
        //        [UIApplication sharedApplication].keyWindow
        /*
         如果视图view直接或者间接的显示window上，则可以通过self.view.window取得window对象
         */
//        self.view.window.rootViewController = mainCtrl;
//        
//        mainCtrl.view.transform = CGAffineTransformMakeScale(.5, .5);
        
        //放大动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5];
        
//        mainCtrl.view.transform = CGAffineTransformIdentity;
        //关闭动画
        [UIView commitAnimations];
        
    }
    
}




@end
