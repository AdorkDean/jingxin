//
//  CgInforProductCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CgInformationDetailModel.h"
@interface CgInforProductCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UILabel *btn2;
@property (strong, nonatomic) IBOutlet UITextField *btn3;
@property (strong, nonatomic) IBOutlet UILabel *btn4;
@property (strong, nonatomic) IBOutlet UILabel *btn5;
@property (strong, nonatomic) IBOutlet UILabel *btn6;
@property (strong, nonatomic) IBOutlet UILabel *btn7;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) IBOutlet UILabel *label6;
@property (strong, nonatomic) IBOutlet UILabel *label7;

@property (strong,nonatomic) CgInformationDetailModel* model;
@property (strong,nonatomic) NSString* count;
@end
