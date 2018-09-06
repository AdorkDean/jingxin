//
//  KeHuHKCell.m
//  yiruantong
//
//  Created by 邱 德政 on 15/1/16.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "KeHuHKCell.h"
#import "UIViewExt.h"
@implementation KeHuHKCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initView{
    //客户名称
    _name  = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, KscreenWidth - 120, 30)];
    _name.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_name];
    //
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_name.right, 5, 80, 30)];
    _typeLabel.font = [UIFont boldSystemFontOfSize:12];
    _typeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_typeLabel];
    
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
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, qiChu.bottom, (KscreenWidth - 20)/4, 30)];
    _label1.font = [UIFont systemFontOfSize:15];
    _label1.textColor = [UIColor grayColor];
    [self.contentView addSubview:_label1];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(_label1.right, qiChu.bottom, (KscreenWidth - 20)/4, 30)];
    _label2.font = [UIFont systemFontOfSize:15];
    _label2.textColor = [UIColor grayColor];
    [self.contentView addSubview:_label2];
    
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(_label2.right, qiChu.bottom, (KscreenWidth - 20)/4, 30)];
    _label3.font = [UIFont systemFontOfSize:15];
    _label3.textColor = [UIColor grayColor];
    [self.contentView addSubview:_label3];
    
    _label4 = [[UILabel alloc] initWithFrame:CGRectMake(_label3.right, qiChu.bottom, (KscreenWidth - 20)/4, 30)];
    _label4.font = [UIFont systemFontOfSize:15];
    _label4.textColor = [UIColor grayColor];
    [self.contentView addSubview:_label4];
    
    

    
}
- (void)layoutSubviews{
    [super layoutSubviews];

    _name.text = [NSString stringWithFormat:@"%@",_model.custname ];
    _typeLabel.text = [NSString stringWithFormat:@"%@",_model.zhaiyao];
    _label1.text = [NSString stringWithFormat:@"%@",_model.qichujine];
    _label2.text = [NSString stringWithFormat:@"%@",_model.yingfashengjine];
    
    _label3.text = [NSString stringWithFormat:@"%@",_model.fashengjine];
    _label4.text = [NSString stringWithFormat:@"%@",_model.yue];
    
}
@end
