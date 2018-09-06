//
//  LXUploadPhotoCell.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/6.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXUploadPhotoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *selectPhoto;
@property (strong, nonatomic) IBOutlet UILabel *namelabel;


@property (nonatomic,strong)void(^selectPhotoBlock)();
@end
