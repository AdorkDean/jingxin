//
//  DDguanliModel.h
//  YiRuanTong
//
//  Created by lx on 15/4/17.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDguanliModel : NSObject

@property (nonatomic,copy) NSString *orderno;
@property (nonatomic,copy) NSString *custname;
@property (nonatomic,copy) NSString *custid;
@property (nonatomic,copy) NSString *creator;
@property (nonatomic,copy) NSString *ordertime;
@property (nonatomic,copy) NSString *ordernote;
@property (nonatomic,copy) NSString *orderstatus;  //订单状态
@property (nonatomic,copy) NSString *spnodename;
@property (nonatomic,copy) NSString *spstatus;
@property (nonatomic,copy) NSString *logisticsid;    //物流Id
@property (nonatomic,copy) NSString *logisticsname;  //物流
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *saler;
@property (nonatomic,copy) NSString *salerid;
@property (nonatomic,copy) NSString *paidtype;
@property (nonatomic,copy) NSString *paidtypeid;
@property (nonatomic,copy) NSString *telno;
@property (nonatomic,copy) NSString *custlinker;
@property(nonatomic,copy) NSString *note;
@property(nonatomic,copy) NSString *ordermoney;
@property(nonatomic,copy) NSString *receiver;
@property(nonatomic,copy) NSString *receivertel;
@property(nonatomic,copy) NSString *receiveaddr;
@property(nonatomic,copy) NSString *daidai;      //是否代收
@property(nonatomic,copy) NSString *daishoumoney;//代收金额
@property(nonatomic,copy) NSString *returnordermoney;//折后总金额
@property(nonatomic,copy) NSString *createtime;

@property (nonatomic,copy) NSString* creditline;//客户余额
@property (nonatomic,copy) NSString* addtype;


@end
