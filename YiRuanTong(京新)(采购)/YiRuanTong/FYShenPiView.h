//
//  FYShenPiView.h
//  YiRuanTong
//
//  Created by 联祥 on 15/5/25.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "FYModel.h"
@interface FYShenPiView : BaseViewController<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)FYModel *model;
@end
