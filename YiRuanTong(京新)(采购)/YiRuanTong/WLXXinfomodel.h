//
//  WLXXinfomodel.h
//  YiRuanTong
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLXXinfomodel : NSObject
@property (nonatomic,copy) NSString *name;       // 名称
@property (nonatomic,copy) NSString *size;      //规格
@property (nonatomic,copy) NSString *price;      //单价
@property (nonatomic,copy) NSString *Id;
/*
 id = 1;
 inserttime = "2018-07-02 09:35:22";
 materialsno = WL201807020001;
 measureunit = "\U5428";
 measureunitid = 241;
 name = "\U6d4b\U8bd5\U7269\U6599";
 price = 122;
 size = 32323;
 typeid = 236;
 typename = "\U94a2\U6750\U7c7b";
 */
@end
