//
//  KeHuManagerCell.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/26.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "KeHuManagerCell.h"

@implementation KeHuManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)moreBtnClicked:(id)sender {
    if (_moreBtnBlock) {
        self.moreBtnBlock();
    }
}
-(void)setModel:(KHmanageModel *)model{
    _model = model;
    self.kehuName.text = [NSString stringWithFormat:@"%@",model.name];
    self.xiadanCount.text = [NSString stringWithFormat:@"%@",model.ordercount];
    
    NSInteger i = _model.saler.length;
    NSString *saler = _model.saler;
    if (i  != 0) {
        saler = _model.saler;
    }else if (i == 0){
        saler = @"业务员未知";
    }
    self.fuzeren.text = [NSString stringWithFormat:@"%@",saler];
    //状态
    NSInteger m = _model.tracelevel.length;
    NSString *status = _model.tracelevel;
    if (m != 0) {
        
        status = _model.tracelevel;
    }else{
        
        status = @"状态未知";
    }

    self.kehuStatus.text = [NSString stringWithFormat:@"%@",status];
    
    //客户级别
    NSInteger n = _model.classname.length;
    NSString *class = _model.classname;
    if (n != 0) {
        class = _model.classname;
    }else if (n == 0){
        class = @"类型未知";
    }
    self.kehuStyle.text = [NSString stringWithFormat:@"%@",class];
    //客户地址
    NSInteger x = _model.receiveaddr.length;
    NSString *address = _model.receiveaddr;
    if (x != 0) {
        address = _model.receiveaddr;
    }else if(x == 0){
        address = @"地址未知";
    }
    
    self.kehuAddress.text = [NSString stringWithFormat:@"%@",address];
    
    
    
    
    

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
