//
//  KeHuGuanLiCell.h
//  yiruantong
//
//  Created by lx on 15/1/21.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.


#import <UIKit/UIKit.h>
#import "KHmanageModel.h"
@interface KeHuGuanLiCell : UITableViewCell{
    
    UIView *_lineView1;
    UIView *_lineView2;

}

@property(nonatomic,retain)KHmanageModel *model;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel2;

@property (strong, nonatomic) IBOutlet UILabel *leiXingLabel2;

@property (strong, nonatomic) IBOutlet UILabel *salerLabel;






@end
