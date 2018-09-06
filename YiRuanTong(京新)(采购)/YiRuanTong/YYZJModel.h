//
//  YYZJModel.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYZJModel : NSObject
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *custname;
@property(nonatomic,copy)NSString *salername;   //装机人员
@property(nonatomic,copy)NSString *installdate; //装机时间
@property(nonatomic,copy)NSString *reportdate;
@property(nonatomic,copy)NSString *linker;
@property(nonatomic,copy)NSString *linkertel;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *note;
@end
