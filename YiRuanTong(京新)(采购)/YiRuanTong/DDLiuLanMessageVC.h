//
//  DDLiuLanMessageVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "DDguanliModel.h"
@interface DDLiuLanMessageVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UIScrollView *dingDanScrollView; //
//客户信息

@property (nonatomic,strong) DDguanliModel *model;
@property(nonatomic,retain)NSString *wuliuID;   //物流ID
@property(nonatomic,strong)NSDictionary *wuLiuData; //物流的数据
//物流信息
//物流显示label
@property(nonatomic,retain) UILabel *wuLiuMingChen1; //物流名称
@property(nonatomic,retain) UILabel *wuLiuLianXiRen1;//物流联系人
@property(nonatomic,retain) UILabel *wuLiuLianXiShouJi1; //物流联系手机
@property(nonatomic,retain) UILabel *wuLiuLianXiDianHua1;//物流联系电话
@property(nonatomic,retain) UILabel *shenPiZhuangTai1;   //审批状态
@property(nonatomic,retain) UILabel *beiZhu1;             //备注
//
@property(nonatomic,retain)NSString *chanpinID;   //产品ID
@property(nonatomic,retain)NSString *orderNo;     //订单单号
@property(nonatomic,retain)NSMutableArray *dataArray;          //产品信息
//产品信息

//产品显示label
@property(nonatomic,retain) UILabel *chanPinName1;      //产品名称
@property(nonatomic,retain) UILabel *chanPinBianMa1;    //产品编码
@property(nonatomic,retain) UILabel *chanPinGuiGe1;     //产品规格
@property(nonatomic,retain) UILabel *chanPinDanWei1;    //产品单位
@property(nonatomic,retain) UILabel *xiaoShouLeiXing1;  //销售类型
@property(nonatomic,retain) UILabel *danJia1;           //单价
@property(nonatomic,retain) UILabel *shuLiang1;         //数量
@property(nonatomic,retain) UILabel *fanLiLu1;          //返利率
@property(nonatomic,retain) UILabel *zheHouDanJia1;     //折后单价
@property(nonatomic,retain) UILabel *JinE1;             //金额
@property(nonatomic,retain) UILabel *zheHouJinE1;       //折后金额
@property(nonatomic,retain) UILabel *keYongKuCun1;      //可用库存


@end
