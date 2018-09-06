//
//  ReplyListCell.h
//  YiRuanTong
//
//  Created by lx on 15/3/26.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyListCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *name;
@property (nonatomic,strong) IBOutlet UILabel *content;
@property (nonatomic,strong) IBOutlet UILabel *time;

@end
