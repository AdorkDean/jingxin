//
//  CustSaleCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/28.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustSaleModel.h"
@interface CustSaleCell : UITableViewCell{
    
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    
}
@property(nonatomic,retain)CustSaleModel *model;

@end
