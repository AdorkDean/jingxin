//
//  TuiHuoShenQingVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
@class KHnameModel;
@interface TuiHuoShenQingVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>



@property (strong, nonatomic) UIView * m_keHuPopView;

@property (strong, nonatomic) UITableView * tableView;


@property(strong,nonatomic) UILabel *m_yeWuYuan;
@property(strong,nonatomic) UITextField *tuiHuoYuanYin1;

@property(strong,nonatomic) NSString *keHuID;

@property(strong,nonatomic) NSString *m_faHuoDanHao;
@property(strong,nonatomic) NSString *m_chanPinGuiGe;
@property(strong,nonatomic) NSString *m_chanPinDanWei;
@property(strong,nonatomic) NSString *m_danJia;
@property(strong,nonatomic) NSString *m_zheHouDanJia;
@property(strong,nonatomic) NSString *m_chanPinPiHao;
@property(strong,nonatomic) NSString *m_faHuoShuLiang;
@property(strong,nonatomic) NSString *m_tuiHuoShuLiang;
@property(strong,nonatomic) NSString *m_tuiHuoJinE;
/* NSDictionary *params = @{@"action":@"proComboGrid",@"table":@"fhxx",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\"}",proName]};*/
@end
