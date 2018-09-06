//
//  LianXiRenCell.h
//  yiruantong
//
//  Created by 邱 德政 on 15/1/24.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LianXiRenCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *lianXiRen;
@property (strong, nonatomic) IBOutlet UITextField *zhiWu;
@property (strong, nonatomic) IBOutlet UITextField *shouJi;
@property (strong, nonatomic) IBOutlet UITextField *zuoJi;
@property (strong, nonatomic) IBOutlet UITextField *chuanZhen;
@property (strong, nonatomic) IBOutlet UITextField *weiXin;
@property (strong, nonatomic) IBOutlet UITextField *qqHao;

@property (strong, nonatomic) IBOutlet UITextField *youXiang;
@property (strong, nonatomic) IBOutlet UITextField *jiGuan;
@property (strong, nonatomic) IBOutlet UITextField *aiHao;
@property (strong,nonatomic) IBOutlet UITextField *ismain;
- (IBAction)shengRiButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *shengRiButton;

@property(strong,nonatomic) UIDatePicker * datePicker;



@end
