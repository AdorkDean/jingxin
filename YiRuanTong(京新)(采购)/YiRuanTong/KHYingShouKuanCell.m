//
//  KHYingShouKuanCell.m
//  YiRuanTong
//
//  Created by 联祥 on 15/9/17.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "KHYingShouKuanCell.h"

@implementation KHYingShouKuanCell

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
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (KscreenWidth-20)/3*2, 40)];
    _label1.font =[UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_label1];
    
    //时间
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth-20)/3*2 + 10, 0, (KscreenWidth - 20)/3, 40)];
    _label2.font =[UIFont systemFontOfSize:15];
    _label2.textAlignment = NSTextAlignmentRight;
    _label2.textColor = [UIColor grayColor];
    [self.contentView addSubview:_label2];
   
    //
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, (KscreenWidth - 20)/3, 20)];
    label3.text = @"单据号";
    label3.font =[UIFont systemFontOfSize:13];
    label3.textColor = [UIColor grayColor];
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 120, KscreenWidth, 1)];
    view3.backgroundColor = [UIColor grayColor];
    _label33 =[[UILabel alloc]initWithFrame:CGRectMake(10, 60, (KscreenWidth - 20)/3, 20)];
    _label33.font =[UIFont systemFontOfSize:12];
    _label33.textColor = [UIColor grayColor];
    [self.contentView addSubview:label3];
   // [self.contentView addSubview:view3];
    [self.contentView addSubview:_label33];
   
    //
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth - 20)/3 + 10, 40, (KscreenWidth - 20)/3, 20)];
    label4.text = @"单据类型";
    label4.font =[UIFont systemFontOfSize:13];
    label4.textColor = [UIColor grayColor];
    [self.contentView addSubview:label4];
    _label44 =[[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth - 20)/3 + 10, 60, (KscreenWidth - 20)/3, 20)];
    _label44.font =[UIFont systemFontOfSize:13];
    _label44.textColor = [UIColor grayColor];
    [self.contentView addSubview:_label44];
    
    
    //
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth - 20)/3*2 + 10, 40, (KscreenWidth - 20)/3, 20)];
    label5.text = @"期初";
    label5.font =[UIFont systemFontOfSize:13];
    label5.textColor = [UIColor grayColor];
    [self.contentView addSubview:label5];
    _label55 =[[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth - 20)/3*2 + 10, 60, (KscreenWidth - 20)/3, 20)];
    _label55.font =[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_label55];
    _label55.textColor = [UIColor grayColor];
    
    
    
    //
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, (KscreenWidth - 20)/3, 20)];
    label6.text = @"本期应收";
    label6.font =[UIFont systemFontOfSize:13];
    label6.textColor = [UIColor grayColor];
    _label66 =[[UILabel alloc]initWithFrame:CGRectMake(10, 100, (KscreenWidth - 20)/3, 20)];
    _label66.font = [UIFont systemFontOfSize:13];
    _label66.textColor = [UIColor grayColor];
    [self.contentView addSubview:label6];
    [self.contentView addSubview:_label66];
    
    
    //
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth - 20)/3 + 10, 80, (KscreenWidth - 20)/3, 20)];
    label7.text = @"本期收回";
    label7.font =[UIFont systemFontOfSize:13];
    label7.textColor = [UIColor grayColor];
    [self.contentView addSubview:label7];
    _label77 = [[UILabel alloc] initWithFrame:CGRectMake((KscreenWidth - 20)/3 + 10, 100, (KscreenWidth - 20)/3, 20)];
    _label77.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_label77];
    _label77.textColor = [UIColor grayColor];
    
    
    //
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth - 20)/3*2 + 10, 80, (KscreenWidth - 20)/3, 20)];
    label8.text = @"余额";
    label8.font =[UIFont systemFontOfSize:13];
    label8.textColor = [UIColor grayColor];
    [self.contentView addSubview:label8];
    _label88 = [[UILabel alloc] initWithFrame:CGRectMake((KscreenWidth - 20)/3*2 + 10, 100, (KscreenWidth - 20)/3, 20)];
    _label88.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_label88];
    _label88.textColor = [UIColor grayColor];
    //
//    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 201, KscreenWidth, 1)];
//    view2.backgroundColor = [UIColor grayColor];
//    [self.contentView addSubview:view2];

}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _label1.text = [NSString stringWithFormat:@"%@",_model.custname];
    
    NSString *time  = [NSString stringWithFormat:@"%@",_model.createtime];
    if (_model.createtime.length != 0) {
        NSRange  range = {0,10};
        time = [time substringWithRange:range];
    }
    _label2.text = time;
    _label33.text = [NSString stringWithFormat:@"%@",_model.danjuhao];
    _label44.text = _model.zhaiyao;
    _label55.text = [NSString stringWithFormat:@"%@",_model.qichujine];
    _label66.text = [NSString stringWithFormat:@"%@",_model.yingfashengjine];
    _label77.text = [NSString stringWithFormat:@"%@",_model.fashengjine];
    _label88.text = [NSString stringWithFormat:@"%@",_model.yue];
    

}




@end
