//
//  KeHuGuanLiCell.m
//  yiruantong
//
//  Created by lx on 15/1/21.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "KeHuGuanLiCell.h"
#import "UIViewExt.h"

@implementation KeHuGuanLiCell

- (void)awakeFromNib {
    
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)initView{
    
    _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView1.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_lineView1];
    _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_lineView2];
    


}

- (void)layoutSubviews{
    [super layoutSubviews];

    _nameLabel2.frame = CGRectMake(16, 5, 230, 20);
    _nameLabel2.text = [NSString stringWithFormat:@"%@、%@",_model.rownum,_model.name];
    // 业务员
    //_salerLabel.frame = CGRectMake(16, _nameLabel2.bottom + 2, 15, 20);
    NSInteger i = _model.saler.length;
    NSString *saler = _model.saler;
    if (i  != 0) {
        saler = _model.saler;
    }else if (i == 0){
        saler = @"业务员未知";
    }
    
    //状态
    NSInteger m = _model.tracelevel.length;
    NSString *status = _model.tracelevel;
    if (m != 0) {
        
        status = _model.tracelevel;
    }else{

        status = @"状态未知";
    }
    
    _salerLabel.text = [NSString stringWithFormat:@"%@ | %@",saler,status];
    
    
    //客户级别
    NSInteger n = _model.classname.length;
    NSString *class = _model.classname;
    if (n != 0) {
        class = _model.classname;
    }else if (n == 0){
        class = @"类型未知";
    }
    //客户地址
    NSInteger x = _model.receiveaddr.length;
    NSString *address = _model.receiveaddr;
    if (x != 0) {
        address = _model.receiveaddr;
    }else if(x == 0){
        address = @"地址未知";
    }
    
    _leiXingLabel2.text = [NSString stringWithFormat:@"%@ | %@",class,address];
    
    
}
@end
