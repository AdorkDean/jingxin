//
//  YingShouKuanCell.m
//  yiruantong
//
//  Created by 邱 德政 on 15/1/19.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "YingShouKuanCell.h"
#import "UIViewExt.h"

@implementation YingShouKuanCell

- (void)awakeFromNib {
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initView{
    
//    UILabel *saler = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
//    saler.text = @"业务员:";
//    saler.font = [UIFont systemFontOfSize:15];
//    [self.contentView addSubview:saler];
    _salerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, KscreenWidth - 80, 30)];
    _salerLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_salerLabel];
    //
    UILabel *qiChu = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, (KscreenWidth - 20)/4, 30)];
    qiChu.text = @"期初";
    qiChu.textColor = [UIColor grayColor];
    qiChu.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:qiChu];
    
    UILabel *yingShou = [[UILabel alloc] initWithFrame:CGRectMake(qiChu.right, 35, (KscreenWidth - 20)/4, 30)];
    yingShou.text = @"本期应收";
    yingShou.textColor = [UIColor grayColor];
    yingShou.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:yingShou];

    
    UILabel *yingHui = [[UILabel alloc] initWithFrame:CGRectMake(yingShou.right, 35, (KscreenWidth - 20)/4, 30)];
    yingHui.text = @"本期收回";
    yingHui.textColor = [UIColor grayColor];
    yingHui.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:yingHui];
    
    
    UILabel *yuE = [[UILabel alloc] initWithFrame:CGRectMake(yingHui.right, 35, (KscreenWidth - 20)/4, 30)];
    yuE.text = @"余额";
    yuE.textColor = [UIColor grayColor];
    yuE.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:yuE];
    //
    _qiChuLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, qiChu.bottom, (KscreenWidth - 20)/4, 30)];
    _qiChuLabel.font = [UIFont systemFontOfSize:15];
    _qiChuLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_qiChuLabel];
    
    _yiShououLabel = [[UILabel alloc] initWithFrame:CGRectMake(_qiChuLabel.right, qiChu.bottom, (KscreenWidth - 20)/4, 30)];
    _yiShououLabel.font = [UIFont systemFontOfSize:15];
    _yiShououLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_yiShououLabel];
    
    _yingHuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(_yiShououLabel.right, qiChu.bottom, (KscreenWidth - 20)/4, 30)];
    _yingHuiLabel.font = [UIFont systemFontOfSize:15];
    _yingHuiLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_yingHuiLabel];
    
    
    
    _yuELabel = [[UILabel alloc] initWithFrame:CGRectMake(_yingHuiLabel.right, qiChu.bottom, (KscreenWidth - 20)/4, 30)];
    _yuELabel.font = [UIFont systemFontOfSize:15];
    _yuELabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_yuELabel];

    
    

}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _salerLabel.text = _model.saler;
    _qiChuLabel.text = [NSString stringWithFormat:@"%@",_model.totalqichujine];
    _yingHuiLabel.text = [NSString stringWithFormat:@"%@",_model.totalfashengjine];
    _yiShououLabel.text = [NSString stringWithFormat:@"%@",_model.totalyingfashengjine];
    _yuELabel.text = [NSString stringWithFormat:@"%@",_model.totalyue];

}

@end
