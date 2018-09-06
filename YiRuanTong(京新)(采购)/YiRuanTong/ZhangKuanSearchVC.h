//
//  ZhangKuanSearchVC.h
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ZhangKuanSearchVC : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy)void(^block)(NSString *custid,NSString *saleid,NSString *start,NSString *end);
@property(nonatomic,strong)NSString * flag;

@end
