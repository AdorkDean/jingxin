//
//  MainViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/2/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NotificationTabBarHidden @"tabbarhidden"
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

@interface MainViewController : UITabBarController<UIScrollViewDelegate>

@property(nonatomic,retain)NSArray *imageName;
@property(nonatomic,retain)NSArray *imageName1;
@property(nonatomic,retain)UIScrollView *scrollView; //左右滑动视图


@end
