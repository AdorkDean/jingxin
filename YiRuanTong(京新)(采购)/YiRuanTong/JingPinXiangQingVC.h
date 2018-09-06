//
//  JingPinXiangQingVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "JPmanageModel.h"

@interface JingPinXiangQingVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIScrollView *jingPinScrollView;
@property (nonatomic,retain) JPmanageModel *model;
// 省市县按钮
@property(nonatomic,retain)UIButton *shengButton;
@property(nonatomic,retain)UIButton *shiButton;
@property(nonatomic,retain)UIButton *xianButton;
@property (strong, nonatomic) UIView *keHuPopView;
@property (strong, nonatomic) UITableView * tableView;

//时间选择
@property(strong,nonatomic) UIDatePicker * datePicker;
@property(strong,nonatomic) UIButton *shengChanRiQi1Button;
@property(strong,nonatomic) UIButton *shengChanRiQi2Button;
//本公司
@property(strong,nonatomic) UIButton *chanPinMingChen1Button;//
@property(strong,nonatomic) UILabel *chanPinBianMa1;
@property(strong,nonatomic) UITextField *gongYingShang1;//
@property(strong,nonatomic) UITextField *shengChanChangJia1;
@property(strong,nonatomic) UITextField *shengChanFanWei1;
@property(strong,nonatomic) UILabel *guiGe1;
@property(strong,nonatomic) UILabel *danJia1;
@property(strong,nonatomic) UITextField *baoZhiQi1;
@property(strong,nonatomic) UITextField *youDian1;
@property(strong,nonatomic) UITextField *queDian1;
@property(strong,nonatomic) UITextView *beiZhu1;
//同行业
@property(strong,nonatomic) UITextField *chanPinMingChen2;
@property(strong,nonatomic) UITextField *chanPinBianMa2;
@property(strong,nonatomic) UITextField *gongYingShang2;
@property(strong,nonatomic) UITextField *shengChanChangJia2;
@property(strong,nonatomic) UITextField *shengChanFanWei2;
@property(strong,nonatomic) UITextField *guiGe2;
@property(strong,nonatomic) UITextField *danJia2;
@property(strong,nonatomic) UITextField *baoZhiQi2;
@property(strong,nonatomic) UITextField *youDian2;
@property(strong,nonatomic) UITextField *queDian2;
@property(strong,nonatomic) UITextField *beiZhu2;

@property(strong,nonatomic) NSArray * arr;
@property(nonatomic) NSInteger count;
@property(strong,nonatomic)NSString * shengId;

@property(strong,nonatomic) NSArray *m_arr;

@property(strong,nonatomic) NSString *shiId;

@property (nonatomic,strong) NSArray *mm_arr;
@property(strong,nonatomic) NSString *xianId;



@end
