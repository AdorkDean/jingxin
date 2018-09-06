//
//  FaBiaoZhuTiVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface FaBiaoZhuTiVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(strong,nonatomic)UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UITextField *biaoTi;
@property (strong, nonatomic) IBOutlet UITextView *neiRong;
@property (strong, nonatomic) IBOutlet UIButton *leiBieButton;

@property (strong, nonatomic) UIView * m_leiBiePopView;
@property(strong,nonatomic) NSMutableArray *m_leiBieDataArray;
@property (strong, nonatomic) UITableView * tableView;

- (IBAction)leiBieButtonClickMethod:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *tiShi;

@end
