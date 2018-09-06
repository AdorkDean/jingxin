//
//  VideoListCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/12.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface VideoListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) IBOutlet UILabel *videoLengh;
@property (strong, nonatomic) IBOutlet UILabel *createTime;
@property (nonatomic,strong)VideoModel * model;
@end
