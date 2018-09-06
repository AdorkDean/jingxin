//
//  ShenPiBaiFangVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "KHbaifangModel.h"
@interface ShenPiBaiFangVC : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

//审批客户拜访历史
//@property (nonatomic,strong) NSString *visiteid; //拜访人ID
//@property (nonatomic,strong) NSString *custid;   //客户ID
//
@property (nonatomic,strong) KHbaifangModel *model;

@property (strong, nonatomic) IBOutlet UILabel *keHuName;
- (IBAction)AddAction:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UILabel *yeWuYuan;

@property (strong, nonatomic) IBOutlet UILabel *baiFangTime;

@property (strong, nonatomic) IBOutlet UILabel *yuJiMoney;

@property (strong, nonatomic) IBOutlet UILabel *baiFangMuDi;

@property (strong, nonatomic) IBOutlet UILabel *baiFangMuDi2;
@property (strong, nonatomic) IBOutlet UITextField *piFuNeiRong;
- (IBAction)piFuButton:(id)sender;

@end
