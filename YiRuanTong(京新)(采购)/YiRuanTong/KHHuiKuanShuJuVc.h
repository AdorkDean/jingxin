//
//  KHHuiKuanShuJuVc.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface KHHuiKuanShuJuVc : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    UILabel *_label1;
    UILabel *_label2;

}

@property (strong, nonatomic) UITableView *KeHuShuJuTableView;

@property (strong, nonatomic) NSString *dangQianRiQi;
@property (strong, nonatomic) NSString *guoQuRiQi;
//
@property(nonatomic,retain)NSMutableArray *DataArray;
@property(nonatomic,retain)NSMutableArray *nameArray;
@property(nonatomic,retain)NSMutableArray *monenyData;
@property(nonatomic,retain)NSMutableArray *countData;

@end
