//
//  KeHufahuoDuiBiSearchVC.h
//  YiRuanTong
//
//  Created by 钱龙 on 2018/5/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KeHufahuoDuiBiSearchVC : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy)void(^block)(NSString *custid,NSString * time);

@end
