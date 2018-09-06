//
//  ZYKDeatilView.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "ZYKModel.h"
@interface ZYKDeatilView : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)ZYKModel *Model;
@end
