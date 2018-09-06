//
//  DDLiuLanCell.h
//  yiruantong
//
//  Created by lx on 15/1/24.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDguanliModel.h"
@interface DDLiuLanCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dingDanBianHao;
@property (strong, nonatomic) IBOutlet UILabel *dingDanKeHu;
@property (strong, nonatomic) IBOutlet UILabel *shenPiZhuangTai;
@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;

@property (strong, nonatomic) IBOutlet UIButton *wuliuBtn;
- (IBAction)wuliuBtnClick:(id)sender;

@property (nonatomic,strong)void(^transVaule)(BOOL isClick);



@property(nonatomic,retain)DDguanliModel *model;
@end
