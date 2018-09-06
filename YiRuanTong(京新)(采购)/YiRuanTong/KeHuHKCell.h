//
//  KeHuHKCell.h
//  yiruantong
//
//  Created by 邱 德政 on 15/1/16.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHfukuanModel.h"
@interface KeHuHKCell : UITableViewCell{

    UILabel *_name;
    UILabel *_typeLabel;
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UILabel *_label4;
    
}

@property(nonatomic,retain)KHfukuanModel *model;


@end
