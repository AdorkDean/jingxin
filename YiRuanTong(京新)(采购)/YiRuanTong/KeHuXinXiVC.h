//
//  KeHuXinXiVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "KHmanageModel.h"

@interface KeHuXinXiVC : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UIScrollView *mainScrollView;
@property(strong,nonatomic) UIScrollView *salerScrollView;
@property(strong,nonatomic) UIScrollView *lianXiRenScrollview;

@property(assign,nonatomic)NSInteger Willselect;

//取得上一个cell
@property (nonatomic,strong) KHmanageModel *model;

//开票 信息
//@property(strong, nonatomic) NSDictionary *m_kaiPiaoMingChen;
//@property(strong, nonatomic) NSDictionary *m_naShuiRenShiBieHao;
//@property(strong, nonatomic) NSDictionary *m_diZhi;
//@property(strong, nonatomic) NSDictionary *m_dianHua;
//@property(strong, nonatomic) NSDictionary *m_kaiHuHang;
//@property(strong, nonatomic) NSDictionary *m_zhangHao;
//联系人   信息

@property (strong, nonatomic) UIView * m_keHuPopView;
@property (strong, nonatomic) UITableView * typetableView;
@property (strong, nonatomic) UITableView * classtableView;
@property (strong, nonatomic) UITableView * jibietableView;


@property (strong, nonatomic) UITableView * custtableView;
@property (strong, nonatomic) UITableView * provincetableView;
@property (strong, nonatomic) UITableView * citytableView;
@property (strong, nonatomic) UITableView * countytableView;

@property(strong,nonatomic) NSMutableArray *hangyefenleiArr;
@property(strong,nonatomic) NSMutableArray *hangyefenleiIdArr;
@property(strong,nonatomic) NSMutableArray *keHuXingZhiArr;
@property(strong,nonatomic) NSMutableArray *keHuXingZhiIDArr;
@property(strong,nonatomic) NSMutableArray *genZongJiBeiArr;
@property(strong,nonatomic) NSMutableArray *genZongJiBeiIdArr;
//省市县
@property(strong,nonatomic) NSMutableArray *shengArr;
@property(strong,nonatomic) NSMutableArray *shiArr;
@property(strong,nonatomic) NSMutableArray *xianArr;
@property (nonatomic,strong) NSMutableArray *shengIDArr;
@property (nonatomic,strong) NSMutableArray *shiIDArr;
@property (nonatomic,strong) NSMutableArray *xianIDArr;

@end
/*
 "rows":[{"id":1360,"name":"济宁市联成电子科技有限公司","helpno":"jnslcdzkjyxgs","principal":"","typeid":89,"typename":"经销商","classid":166,"classname":"一般客户","nature":"","tracelevel":"","tracelevelid":0,"mgrlevel":"","mgrlevelid":0,"isteamwork":"","isprivate":"1","isvalid":"1","estabtime":"","legalperson":"刘奎","firmsize":"","creditline":10,"registmoney":100000,"businessarea":"","businessdiscribe":"","province":16,"city":1465,"county":1541,"address":"","longitudebefore":"","latitudebefore":"","longitudeafter":"","latitudeafter":"","lastvisittime":"","lastvisitor":0,"receivername":"刘奎","receivercell":"18769776180","receivertel":"","receiveaddr":"济宁市任城区万通科技市场4楼西","express":"","invoicename":"","taxpayeridno":"","invoiceaddr":"","invoicetel":"","invoicebank":"","invoiceaccount":"","note":"","createtime":"2015-02-11 08:32:29","creatorid":122,"principalid":0,"creator":"石光胜","departid":0,"departname":"","businesstime":"2015-02-11 00:00:00","companyname":"","provincename":"山东省","cityname":"济宁市","countyname":"市中区"},
 */

