//
//  FYBaoXiaoDetailCell.h
//  YiRuanTong
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBXDetailModel.h"

@interface FYBaoXiaoDetailCell : UITableViewCell
@property(nonatomic,strong)void(^delBtnBlock)();
@property(nonatomic,strong)void(^typeBtnBlock)();
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
@property (strong, nonatomic) IBOutlet UIButton *typeBtn;
@property (strong, nonatomic) IBOutlet UITextField *countField;
@property (strong, nonatomic) IBOutlet UITextField *priceField;
@property (strong, nonatomic) IBOutlet UITextField *noteField;
- (IBAction)delBtnClick:(id)sender;
- (IBAction)typeBtnClick:(id)sender;
@property (nonatomic,strong) FYBXDetailModel* model;
@property (nonatomic,strong) NSString* count;

@end
