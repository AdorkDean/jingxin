//
//  WXGLDetailView.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/5.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "WXGLModel.h"
@interface WXGLDetailView : BaseViewController<UIScrollViewDelegate>
@property(nonatomic,retain)WXGLModel *model;
@end
