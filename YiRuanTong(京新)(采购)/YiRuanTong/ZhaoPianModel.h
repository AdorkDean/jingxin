//
//  ZhaoPianModel.h
//  YiRuanTong
//
//  Created by lx on 15/4/21.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhaoPianModel : NSObject

@property (nonatomic,copy) NSString *srcfilename;
@property (nonatomic,copy) NSString *pictype;
@property (nonatomic,copy) NSString *autofilename;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *uploader;
@property (nonatomic,copy) NSString *createtime;
@property (nonatomic,copy) NSString *custname;
@property (nonatomic,copy) NSString *filenote;

//用于删除添加的
@property (nonatomic,copy) NSString* isselect;

@end
