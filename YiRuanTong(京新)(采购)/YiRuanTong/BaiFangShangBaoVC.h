//
//  BaiFangShangBaoVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "KHmanageModel.h"
#import "KHbaifangModel.h"
@interface BaiFangShangBaoVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)KHmanageModel *model;
@property (nonatomic,strong)KHbaifangModel *setModel;



@property (strong, nonatomic) UIScrollView *bf_ScrollView;

@property (strong, nonatomic) UIButton * m_keHuNameButton;
@property (strong, nonatomic) UIButton * m_genZongJiBieButton;

@property(strong,nonatomic) UIDatePicker * datePicker;

@property(strong,nonatomic)UIButton *m_baiFangTimeButton;
@property(strong,nonatomic)UIButton *m_xiaCiBaiFangTimeButton;

@property (strong, nonatomic) UIView * m_keHuPopView;

@property (strong, nonatomic) UITableView * tableView;


@property(strong,nonatomic)UITextField *m_yuqiMoney;
@property(strong,nonatomic)UITextField *m_baiFangMuDi;
@property(strong,nonatomic)UITextField *m_qiaTanShuoMing;
@property(strong,nonatomic)UITextField *m_xiaCiBaiFangMuDi;
@property(strong,nonatomic)UITextField *m_beiZhu;


@property(strong,nonatomic)NSString *m_lianXiRen;
@property(strong,nonatomic)NSString *m_lianXiShouJi;
@property(strong,nonatomic)NSString *m_lianXiDianHua;
@property(strong,nonatomic)NSString *m_lianXiYouXiang;
@property(strong,nonatomic)NSString *m_keHuDiZhi;
@property(strong,nonatomic)NSString *m_quYuSheng;
@property(strong,nonatomic)NSString *m_quYuShi;
@property(strong,nonatomic)NSString *m_quYuXian;


@property(nonatomic) NSInteger count;

@property(strong,nonatomic) NSString * name;


@end
