//
//  LiuLanBaiFangVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "KHbaifangModel.h"
@interface LiuLanBaiFangVC : BaseViewController<UITextFieldDelegate>
//浏览客户拜访历史ID

//@property (nonatomic,strong) NSString *visiteid;//拜访人ID
//@property (nonatomic,strong) NSString *custid;  //客户ID
//


- (IBAction)AddAction:(UIButton *)sender;   //添加图片

@property (nonatomic,strong) KHbaifangModel *model;

- (IBAction)piFuButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *piFuNeiRong;


@end
