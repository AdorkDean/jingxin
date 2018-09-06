//
//  YingShouKuanCell.h
//  yiruantong
//
//  Created by 邱 德政 on 15/1/19.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YingShouKuanModel.h"
@interface YingShouKuanCell : UITableViewCell
{
    UILabel *_salerLabel;
    UILabel *_qiChuLabel;
    UILabel *_yingHuiLabel;
    UILabel *_yiShououLabel;
    UILabel *_yuELabel;
    


}
@property(nonatomic,retain)YingShouKuanModel *model;

@end
