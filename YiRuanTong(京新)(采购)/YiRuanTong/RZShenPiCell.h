//
//  RZShenPiCell.h
//  yiruantong
//
//  Created by lx on 15/1/23.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZshangbaoModel.h"
@interface RZShenPiCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *shangBaoLeiXing;
@property (strong, nonatomic) IBOutlet UILabel *shangBaoRen;
@property (strong, nonatomic) IBOutlet UILabel *zhuangTai;
@property(nonatomic,retain) RZshangbaoModel *model;
@end
