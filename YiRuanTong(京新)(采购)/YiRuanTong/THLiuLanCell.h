//
//  THLiuLanCell.h
//  yiruantong
//
//  Created by lx on 15/1/28.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THmanagerModel.h"
@interface THLiuLanCell : UITableViewCell{
   
    


}
@property (strong, nonatomic) IBOutlet UILabel *tuiHuoDanHao;
@property (strong, nonatomic) IBOutlet UILabel *keHuName;

@property (strong, nonatomic) IBOutlet UILabel *shenPiZhuangTai;
//@property (strong, nonatomic) IBOutlet UILabel *tuiHuoZhuangTai;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;





@property(nonatomic,retain)THmanagerModel *model;
@end
