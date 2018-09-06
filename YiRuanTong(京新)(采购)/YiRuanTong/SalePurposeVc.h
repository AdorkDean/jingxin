//
//  SalePurposeVc.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface SalePurposeVc : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    UILabel *_label1;
    UILabel *_label2;
}

@property (strong, nonatomic) UITableView *SalePurposeTableView;


//
@property(nonatomic,retain) NSMutableArray *DataArray; //
@property(nonatomic,retain)NSMutableArray *nameArray;
@property(nonatomic,retain)NSMutableArray *countArray;
@property(nonatomic,retain)NSMutableArray *moneyArray;

@end
