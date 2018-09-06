//
//  AddKeHuVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
@interface AddKeHuVC : BaseViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSInteger _flag1;
    NSInteger _flag2;
   


}

//经纬度
@property(strong,nonatomic)CLLocationManager * locationManager;

@property(nonatomic)NSString * lblLatitude;
@property(nonatomic)NSString * lblLongitude;

@property(strong,nonatomic) UIScrollView * mainScrollView;
@property(strong,nonatomic) UIScrollView * ziLiaoScrollView;
@property(nonatomic,retain)UIScrollView  *lianXiRenScrollview;
//数据
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


@end
/*
 {"businessarea":"很多",
 "salerList":[{"account":"管理员","accountid":"1","ismain":"1","table":"khfzr"}],
 "estabtime":"2015-01-24",
 "businessdiscribe":"好大",
 "expressList":[{"isdefault":"1","logname":"兔兔快运","logid":"102","table":"khwlxx"}],
 "invoicetel":"567",
 "latitudeafter":"",
 "invoiceaccount":"987654321",
 "name":"艾希",
 "typeid":"89",
 "receivertel":"12345678",
 "tracelevel":"A级客户",
 "receiveaddr":"中国",
 "classid":"22",
 "creditline":"200000",
 "receivername":"艾希",
 "classname":"往来客户",
"longitudeafter":"",
 "receivercell":"12345678900",
 "legalperson":"哦",
 "businesstime":"2015-01-24",
 "table":"khxx",
 "companyname":"拂面二货",
 "invoicename":"天王盖地虎",
 "invoiceaddr":"1401",
 "invoicebank":"银行",
 "taxpayeridno":"机电",
 "isprivate":"1",
 "address":"中国",
 "typename":"经销商",
 "tracelevelid":"118",
 "linkerList":[{"linker":"艾希","birthday":"2015-01-24","fax":"","native":"","email":"","duty":"睡觉","ismain":"1","telno":"","hobby":"","table":"khlxr","micromsg":"","qq":"12345","cellno":"12345678900"}],
 "registmoney":"29955855",
 "isteamwork":"1"}
 
 */