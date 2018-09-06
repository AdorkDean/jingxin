//
//  ScanReportSearchVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/8.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanReportSearchVC : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy)void(^block)(NSString *proname,NSString *areaname,NSString *areaid,NSString *start,NSString *end);
@property (nonatomic,assign)NSInteger index;
@end
