//
//  ChanPinXiaoShouSearchVC.h
//  YiRuanTong
//
//  Created by LONG on 2018/4/28.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface ChanPinXiaoShouSearchVC : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy)void(^block)(NSString *proname,NSString *areaname,NSString *areaid,NSString *start,NSString *end);

@end
