//
//  KHShuJuCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import "KHShuJuCell.h"

@implementation KHShuJuCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    [self initView];
    
}
- (void)initView{
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, KscreenWidth - 40, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, KscreenWidth - 40, 20)];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_detailLabel];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    _titleLabel.text= [NSString stringWithFormat:@"客户名称:%@",_model.custname];
//    _detailLabel.text = [NSString stringWithFormat:@"发货金额:%@ | 回款金额:%@",_model.fahuojine,_model.huikuanjine];
    _model.custname = [self convertNull:_model.custname];
    _model.fahuojine = [self convertNull:_model.fahuojine];
    _model.tuihuojine = [self convertNull:_model.tuihuojine];
    _model.chongzhangjine = [self convertNull:_model.chongzhangjine];
    _model.huikuanjine = [self convertNull:_model.huikuanjine];
    _model.yinghuikuanjine = [self convertNull:_model.yinghuikuanjine];
    self.custLabel.text = [NSString stringWithFormat:@"客户名称:%@",_model.custname];
    self.custLabel.text = [NSString stringWithFormat:@"客户名称:%@",_model.custname];
    self.fahuojineLabel.text = [NSString stringWithFormat:@"发货金额:%@",_model.fahuojine];
    self.tuihuojineLabel.text = [NSString stringWithFormat:@"退货金额:%@",_model.tuihuojine];
    self.chongzhangjineLabel.text = [NSString stringWithFormat:@"冲账金额:%@",_model.chongzhangjine];
    self.shijireturnLabel.text = [NSString stringWithFormat:@"实际回款金额:%@",_model.huikuanjine];
    self.willReturnLabel.text = [NSString stringWithFormat:@"应回款金额:%@",_model.yinghuikuanjine];
}

-(NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}

@end
