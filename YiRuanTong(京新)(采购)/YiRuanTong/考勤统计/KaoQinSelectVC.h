//
//  KaoQinSelectVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/14.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KaoQinSelectVC : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy)void(^block)(NSString *proid,NSString *proname,NSString *start,NSString *end);
@end
