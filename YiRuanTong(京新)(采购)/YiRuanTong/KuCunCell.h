//
//  KuCunCell.h
//  yiruantong
//
//  Created by lx on 15/1/19.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCcheckModel.h"
@interface KuCunCell : UITableViewCell{

    UIView *_lineView1;
    UIView *_lineView2;

}
@property (strong, nonatomic) IBOutlet UILabel *pronameLabl;


@property (strong, nonatomic) IBOutlet UILabel *detailLabel;







@property(nonatomic,retain)KCcheckModel *model;



@end
