//
//  ZYKDetailModel.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYKDetailModel : NSObject
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *filename;//文件名
@property(nonatomic,copy)NSString *uptime; // 上传时间
@property(nonatomic,copy)NSString *fileid;  //下载地址

@end
