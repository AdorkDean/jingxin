//
//  WLXXcellmodel.h
//  YiRuanTong
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLXXcellmodel : NSObject
@property (nonatomic,copy) NSString *name;       // 名称
@property (nonatomic,copy) NSString *size;      //规格
@property (nonatomic,copy) NSString *price;      //单价
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *typename;
@property (nonatomic,copy) NSString *typeid;
@property (nonatomic,copy) NSString *helpno;
@property (nonatomic,copy) NSString *measureunit;
@property (nonatomic,copy) NSString *measureunitid;
@property (nonatomic,copy) NSString *suppliername;
@property (nonatomic,copy) NSString *labelno;
@property (nonatomic,copy) NSString *shortname;
@property (nonatomic,copy) NSString *note;
//物料分类  typename
//分类ID  typeid
//物料名称  name
//物料规格  size
//物料价格  price
//助记码   helpno
//计量单位  measureunit
//计量单位id    measureunitid
//供货商       suppliername 
//标签编码  labelno
//物料简称  shortname
//备注    note
@end
