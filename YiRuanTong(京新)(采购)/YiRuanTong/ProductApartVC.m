//
//  ProductApartVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/23.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProductApartVC.h"
#import "UIViewExt.h"
#import "ProgressingCell.h"
#import "DataPost.h"
#import "ProFinishModel.h"
#import "KHnameModel.h"
#import "piciModel.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface ProductApartVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tbView;
@property (nonatomic,strong)UITableView * cangkutableView;
@property (nonatomic,strong)UITableView * picitableView;
@property (nonatomic,strong)NSMutableArray * resultData;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * piciArr;
@property (nonatomic,strong)UITextField * custField;

@end

@implementation ProductApartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
