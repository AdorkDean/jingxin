//
//  YuEDetailViewViewController.h
//  YiRuanTong
//
//  Created by 联祥 on 15/7/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "YuEModel.h"
@interface YuEDetailViewViewController : BaseViewController<UIScrollViewDelegate>
@property(nonatomic,retain)YuEModel *model;
@end
