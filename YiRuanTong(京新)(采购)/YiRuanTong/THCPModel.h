//
//  THCPModel.h
//  YiRuanTong
//
//  Created by 联祥 on 15/7/28.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THCPModel : NSObject


@property (nonatomic,copy) NSString *Id;           // ID
@property (nonatomic,copy) NSString *proname;      // 名称
@property (nonatomic,copy) NSString *prono;        // 编码
@property (nonatomic,copy) NSString *specification;// 规格
@property (nonatomic,copy) NSString *mainunitname; // 单位
@property (nonatomic,copy) NSString *mainunit;     // 单位ID
@property (nonatomic,copy) NSString *saleprice;    // 单价
@property (nonatomic,copy) NSString *secondunitname;
@property (nonatomic,copy) NSString *secondunit;
@property (nonatomic,copy) NSString *fileurl;


@end
