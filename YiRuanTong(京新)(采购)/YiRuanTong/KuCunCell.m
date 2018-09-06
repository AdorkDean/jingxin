//
//  KuCunCell.m
//  yiruantong
//
//  Created by lx on 15/1/19.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "KuCunCell.h"
#import "UIViewExt.h"
@implementation KuCunCell

- (void)awakeFromNib {
    
    [self initView];
   
}
- (void)initView{
    
//    // 创建label
//    _pronameLabl = [[UILabel alloc] initWithFrame:CGRectZero];
//    [self.contentView addSubview:_pronameLabl];
//    _storagenameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    [self.contentView addSubview:_storagenameLabel];
//    _probatchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    [self.contentView addSubview:_probatchLabel];
//    _specificationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    [self.contentView addSubview:_specificationLabel];
    
    //
//    _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
//    _lineView1.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:_lineView1];
//    _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
//    _lineView2.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:_lineView2];



}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
        _pronameLabl.frame = CGRectMake(16, 10, KscreenWidth - 26, 20);
        _pronameLabl.text =  _model.proname;
    
        //详情
    _detailLabel.frame = CGRectMake(16, _pronameLabl.bottom + 5, KscreenWidth - 26, 20);
    NSString *storage = _model.storagename;
    NSString *stoCout = [NSString stringWithFormat:@"%@",_model.totalcount];
    NSString *probatch = [NSString stringWithFormat:@"%@",_model.probatch];
    NSString *specification = [NSString stringWithFormat:@"%@",_model.specification];
    if (storage.length == 0) {
        storage = @"未知";
    }
    if (probatch.length == 0) {
        probatch = @"未知";
    }
    if (specification.length == 0) {
        specification = @"未知";
    }
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.text = [NSString stringWithFormat:@"%@  |数量:%@   |批次:%@  | 规格:%@",storage,stoCout,probatch,specification];
           
    
    
}



@end
