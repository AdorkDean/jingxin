//
//  OrderViewCell.m
//  YiRuanTong
//
//  Created by 联祥 on 16/4/5.
//  Copyright © 2016年 联祥. All rights reserved.
//

#import "OrderViewCell.h"
#import "UIViewExt.h"

#define lineColor  COLOR(240, 240, 240, 1);

@implementation OrderViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}
- (void)initView{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 45)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.backgroundColor = COLOR(220, 220, 220, 1);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    //
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10,_titleLabel.bottom, 80, 45)];
    label1.text = @"产品名称";
    label1.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label1];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, label1.bottom, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [self.contentView addSubview:view1];
    //
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10,label1.bottom, 80, 45)];
    label2.text = @"产品编码";
    label2.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label2];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    [self.contentView addSubview:view2];
    _proCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, label2.top, KscreenWidth - 110, 45)];
    _proCodeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_proCodeLabel];
    //
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10,label2.bottom, 80, 45)];
    label3.text = @"产品规格";
    label3.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label3];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, label3.bottom, KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    [self.contentView addSubview:view3];
    _specLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, label3.top, KscreenWidth - 110, 45)];
    _specLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_specLabel];
    //
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10,label3.bottom, 80, 45)];
    label4.text = @"产品单位";
    label4.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label4];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, label4.bottom, KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    [self.contentView addSubview:view4];
    //
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(10,label4.bottom, 80, 45)];
    label5.text = @"单价";
    label5.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label5];
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, label5.bottom, KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    [self.contentView addSubview:view5];
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, label5.top, KscreenWidth - 110, 45)];
    _priceLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_priceLabel];
    
    //
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(10,label5.bottom, 80, 45)];
    label6.text = @"折后单价";
    label6.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label6];
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    [self.contentView addSubview:view6];
    //
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(10,label6.bottom, 80, 45)];
    label7.text = @"销售类型";
    label7.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label7];
    UIView *view7 = [[UIView alloc] initWithFrame:CGRectMake(0, label7.bottom, KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [self.contentView addSubview:view7];
    //
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(10,label7.bottom, 80, 45)];
    label8.text = @"返利率";
    label8.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label8];
    UIView *view8 = [[UIView alloc] initWithFrame:CGRectMake(0, label8.bottom, KscreenWidth, 1)];
    view8.backgroundColor = lineColor;
    [self.contentView addSubview:view8];
    //
    UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(10,label8.bottom, 80, 45)];
    label9.text = @"数量";
    label9.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label9];
    UIView *view9 = [[UIView alloc] initWithFrame:CGRectMake(0, label9.bottom, KscreenWidth, 1)];
    view9.backgroundColor = lineColor;
    [self.contentView addSubview:view9];
    //
    UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(10,label9.bottom, 80, 45)];
    label10.text = @"金额";
    label10.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label10];
    UIView *view10 = [[UIView alloc] initWithFrame:CGRectMake(0, label10.bottom, KscreenWidth, 1)];
    view10.backgroundColor = lineColor;
    [self.contentView addSubview:view10];
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, label10.top, KscreenWidth - 110, 45)];
    _moneyLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_moneyLabel];
    //
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(10,label10.bottom, 80, 45)];
    label11.text = @"折后金额";
    label11.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label11];
    _rateMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, label11.top, KscreenWidth - 110, 45)];
    _rateMoneyLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_rateMoneyLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSString *proCode = [NSString stringWithFormat:@"%@",_model.prono];
    proCode = [self convertNull:proCode];
    _proCodeLabel.text = [self convertNull:[NSString stringWithFormat:@"%@",_model.prono]];
    _specLabel.text = [self convertNull:[NSString stringWithFormat:@"%@",_model.specification]];
    _priceLabel.text = [self convertNull:[NSString stringWithFormat:@"%@",_model.singleprice]];
    _moneyLabel.text = [self convertNull:[NSString stringWithFormat:@"%@",_model.totalmoney]];
    _rateMoneyLabel.text = [self convertNull:[NSString stringWithFormat:@"%@",_model.saledmoney]];
    
    
    
    
}

-(NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }else if (object==nil){
        return @"";
    }else if ([object isEqualToString:@"(null)"]){
        return @"";
    }
    return object;
    
}

@end
