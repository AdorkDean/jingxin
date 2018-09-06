//
//  OrderModel.h
//  YiRuanTong
//
//  Created by 联祥 on 16/4/5.
//  Copyright © 2016年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property(nonatomic,copy)NSString *totalmoney;  
@property(nonatomic,copy)NSString *returnrate;
@property(nonatomic,copy)NSString *prono;
@property(nonatomic,copy)NSString *proname;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *singleprice;
@property(nonatomic,copy)NSString *maincount;    //数量
@property(nonatomic,copy)NSString *remaincount;  //数量
@property(nonatomic,copy)NSString *stockcount;   //
@property(nonatomic,copy)NSString *saletype;
@property(nonatomic,copy)NSString *saletypename;
@property(nonatomic,copy)NSString *saledprice;
@property(nonatomic,copy)NSString *specification;
@property(nonatomic,copy)NSString *prounitname;
@property(nonatomic,copy)NSString *prounitid;
@property(nonatomic,copy)NSString *prounitType;   //主副单位

@property(nonatomic,copy)NSString *proid;
@property(nonatomic,copy)NSString *saledmoney;
@property(nonatomic,copy)NSString *addtype;



/*{
 1"totalmoney": "%@",
 2"returnrate": "%@",
 3"prono": "%@",
 4"proname": "%@",
 5"table": "ddmx",
 6"type": "%@",
 7"singleprice": "%@",
 8"maincount": "%@",
 9"remaincount": "%@",
 10"stockcount": "%@",
 11"saletype": "%@",
 12"saledprice": "%@",
 13"specification": "%@",
 14"prounitname": "%@",
 15"proid": "%@",
 16"prounitid": "%@",
 17"saledmoney": "%@"
 }
 */


@end
