//
//  ProStoreListCell.m
//  YiRuanTong
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProStoreListCell.h"

@implementation ProStoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ProStoreListModel*)model{
    _model = model;
    self.exportLabel.text = [NSString stringWithFormat:@"出库单号：%@",model.sono];
    self.matLabel.text = [NSString stringWithFormat:@"领料单号：%@",model.bomno];
    self.spLabel.text = [NSString stringWithFormat:@"审批状态：%@",model.spnodename];
    NSString* isout = [NSString stringWithFormat:@"%@",model.isstockout];
    if ([isout isEqualToString:@"0"]) {
        self.isoutLabel.text = @"是否出库：否";
    }else if ([isout isEqualToString:@"1"]){
        self.isoutLabel.text = @"是否出库：是";
    }
    self.plannoLabel.text = [NSString stringWithFormat:@"计划单号：%@",model.planno];
    self.pronameLabel.text = [NSString stringWithFormat:@"产品名称：%@",model.proname];
    self.creatorLabel.text = [NSString stringWithFormat:@"创建人：%@",model.creator];
    self.creattimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",model.createtime];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)isSureOutClick:(id)sender {
    if (_isOutBtnBlock) {
        self.isOutBtnBlock(sender);
    }
}
@end
