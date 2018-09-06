//
//  ShouHouFuWuViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ShouHouFuWuViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    //搜索页面
   
    UIView *_backView;
    UIView *_timeView;
    
    UIButton *_custButton;
    UIButton *_date1;
    UIButton *_date2;
    UIRefreshControl *_refreshControl5;
    UIRefreshControl *_refreshControl6;
    NSInteger _page5;
    NSInteger _page6;
    NSMutableArray *_salerArray;
    NSMutableArray *_custArray;



}
@property(nonatomic,retain)UIView *searchView;
@property(nonatomic,retain)UIButton *salerButton;
@end
