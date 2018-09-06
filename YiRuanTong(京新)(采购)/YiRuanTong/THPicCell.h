//
//  THPicCell.h
//  YiRuanTong
//
//  Created by 联祥 on 15/11/3.
//  Copyright © 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THPicModel.h"
@interface THPicCell : UITableViewCell{
}

@property(nonatomic,retain)UIImageView *showImage;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)THPicModel *model;
@end
