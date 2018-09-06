//
//  XiaoshouFahuoSearchVC.h
//  YiRuanTong
//
//  Created by LONG on 2018/5/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface XiaoshouFahuoSearchVC : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy)void(^block)(NSString *proid,NSString *saleid,NSString *start,NSString *end,NSString *guige,NSString*prono);
@end
