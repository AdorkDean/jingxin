//
//  ProStoreListCell.h
//  YiRuanTong
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProStoreListModel.h"
@interface ProStoreListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *exportLabel;
@property (weak, nonatomic) IBOutlet UILabel *spLabel;
@property (weak, nonatomic) IBOutlet UILabel *isoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *matLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronameLabel;
@property (weak, nonatomic) IBOutlet UILabel *plannoLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *creattimeLabel;
- (IBAction)isSureOutClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *isoutBtn;

@property (nonatomic,weak)ProStoreListModel* model;
@property(nonatomic,strong)void(^isOutBtnBlock)(UIButton* sender);
@end
