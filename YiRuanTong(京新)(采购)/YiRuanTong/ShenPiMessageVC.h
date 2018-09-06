//
//  ShenPiMessageVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "RZshangbaoModel.h"
@interface ShenPiMessageVC : BaseViewController<UITextFieldDelegate>

@property (strong,nonatomic) NSString *idEQ;
@property (nonatomic,strong) RZshangbaoModel *model;
@property (strong, nonatomic) UILabel *leiXing;

@property (strong, nonatomic) UILabel *shangBaoRen;

@property (strong, nonatomic) UILabel *shangBaoTime;

@property (strong, nonatomic) UILabel *shangBaoAddress;
@property (strong, nonatomic)  UIImageView *shangBaoPhoto;

@property (strong, nonatomic) UITextField *piFuNeiRong;

@end
