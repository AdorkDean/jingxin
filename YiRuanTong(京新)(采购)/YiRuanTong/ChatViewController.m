//
//  ChatViewController.m
//  YiRuanTong
//
//  Created by lx on 15/4/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationTabBarHidden object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)leftBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NotificationTabBarHidden object:@"no" userInfo:nil];
}

@end
