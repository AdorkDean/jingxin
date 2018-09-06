//
//  ProFinishCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProFinishModel.h"

@interface ProFinishCell : UITableViewCell
@property(nonatomic,strong)void(^delBtnBlock)();
@property (strong, nonatomic) IBOutlet UIButton *wuliaoname;
@property (strong, nonatomic) IBOutlet UILabel *wuliaoSpe;
@property (strong, nonatomic) IBOutlet UITextField *wuliaodanwei;
@property (strong, nonatomic) IBOutlet UITextField *standcount;
@property (strong, nonatomic) IBOutlet UIButton *cangku;
@property (strong, nonatomic) IBOutlet UIButton *pici;
@property (strong, nonatomic) IBOutlet UITextField *stockCount;
@property (strong, nonatomic) IBOutlet UITextField *needCount;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,strong) ProFinishModel *model;
@property (strong, nonatomic) IBOutlet UITextField *keyongCount;

@property (nonatomic,strong) NSString *count;
@end
