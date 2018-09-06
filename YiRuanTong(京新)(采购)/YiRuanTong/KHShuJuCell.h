//
//  KHShuJuCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHShuJuModel.h"
@interface KHShuJuCell : UITableViewCell{
    
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    
}
@property (strong, nonatomic) IBOutlet UILabel *custLabel;
@property (strong, nonatomic) IBOutlet UILabel *fahuojineLabel;
@property (strong, nonatomic) IBOutlet UILabel *chongzhangjineLabel;
@property (strong, nonatomic) IBOutlet UILabel *tuihuojineLabel;
@property (strong, nonatomic) IBOutlet UILabel *shijireturnLabel;
@property (strong, nonatomic) IBOutlet UILabel *willReturnLabel;


@property(nonatomic,retain)KHShuJuModel *model;

@end
