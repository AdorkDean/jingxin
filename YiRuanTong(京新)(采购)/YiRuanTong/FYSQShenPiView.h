//
//  FYSQShenPiView.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
@class  FYSQModel;
@interface FYSQShenPiView : BaseViewController<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)FYSQModel *model;

@end
