//
//  CgApplyVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "CgApplyVC.h"
#import "DingDanViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "KHnameModel.h"
#include "CPINfoModel.h"
#include "CPInfoCell.h"
#import "CustCell.h"
#import "DWandLXModel.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "UnitModel.h"
#define lineColor  COLOR(240, 240, 240, 1);
@interface CgApplyVC ()<UITextFieldDelegate,UIAlertViewDelegate>

{
    
    MBProgressHUD *_hud;
    MBProgressHUD *_HUD;
    MBProgressHUD *_Hud;
    //客户信息添加字段
    
    NSArray *_YNArray;
    //
    UIView *_timeView;
    NSInteger _page;
    NSInteger _page1;
    NSInteger _flag;
    //客户名称、产品名称数字
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
    NSMutableArray *_departArr;
    NSMutableArray *_cgpeopleArr;
    NSMutableArray *_cgpeopleIdArr;
    NSMutableArray *_cgAreaArr;
    NSMutableArray *_payTypeArr;
    NSMutableArray *_surpportArr;
    
    //////////////////////////////新字段
    //客户信息
    UIButton  *_nameButton;
    UITextField *_yuEField;
    UIButton *_payTypeButton;
    UIButton *_cgpeopleBtn;
    UIButton *_cgplaceBtn;
    UIButton *_startBtn;
    NSString * _custname;
    UIButton *_surpportBtn;
    //客户联系人物流字段
    UIButton *_wuLiuButton;
    UITextField *_receiver;
    UITextField *_receiveTel;
    UITextField *_receiveAdd;
    UIButton *_wuLiuDaiShou;
    UITextField *_daiShouJinE;
    UITextField *_note;
    //增加产品
    NSMutableArray *_cpNameBtnArray;
    NSMutableArray *_cpCodeArray;
    NSMutableArray *_cpGuigeArray;
    NSMutableArray *_cpDanweiArray;
    NSMutableArray *_xiaoshouTypeArray;
    NSMutableArray *_singlePriceArray;
    NSMutableArray *_countArray;
    NSMutableArray *_JineArray;
    NSMutableArray *_keyongKuCunArray;
    NSMutableArray *_chanpinViewArray;
    NSMutableArray *_leixingArr;//销售类型
    NSMutableArray *_fukuanfangshiId;
    NSMutableArray *_colseArray;
    NSMutableArray *_danweiArr;
    NSMutableArray *_fanliLvArray;
    NSMutableArray *_zhuFuDanWeiArray;
    NSMutableArray *_CPIdArray;
    NSMutableArray *_UnitIdArray;
    NSMutableArray *_SaleTypeIdArray;
    NSMutableArray *_zhehouSinglePriceArray;  //折后单价
    NSMutableArray *_zhehouJineArray;         //折后金额
    //
    NSMutableArray *_UNITArray;
    NSMutableArray *_UnitPriceArray;
    
    NSString *singleprice;
    NSString *count;
    
    NSString *_totalZheHou;
    NSString *_totalJine;
    NSString *_totalaccount;
    NSString *_saletypeid;  //销售类型ID
    NSString *_jine1;
    NSString *_proid;
    NSString *_measureunitid;
    NSString *_unitid;
    NSString *_unitPrice;
    NSString *_price;    //价格
    NSInteger _nullFlag;
    NSInteger _chanpinokFlag;
    
    UITextField *_proField;    //输入产品名称
    UITextField *_custField;   //采购员名称
    UITextField *_departField;//部门名称
    UITextField *_areaField;//区域名称
    UITextField *_supportField;//区域名称
    NSString *_currentDateStr;
    NSString *_saler;
    NSString *_salerId;
    NSString *_cgpeopleId;
    NSString *_cgplaceId;
    NSString *_payTypeId;
    NSString *_supportId;
    UITextField *danJia1;
    UITextField *shuLiang1;
    
    BOOL isHaveDian;
    //
    UIView *_detailView;
    UIAlertView *_showOrder;    //订单添加提示
    UIButton* _hide_keHuPopViewBut;
}
@property (strong,nonatomic) NSMutableArray *fuKuanFangShiArr;
@property (strong,nonatomic) NSMutableArray *faPiaoLieXingArr;
@property (strong,nonatomic) NSMutableArray *wuLiuMingChenArr;
@property(nonatomic,retain)UITableView *cgpeopleTable;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *departTable;
@property(nonatomic,retain)UITableView *payTypeTableView;
@property(nonatomic,retain)UITableView *cgAreaTable;
@property(nonatomic,retain)UITableView *supportTable;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation CgApplyVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"采购申请";
    _dataArray = [[NSMutableArray alloc] init];
    _dataArray1 = [[NSMutableArray alloc] init];
    _page1 = 1;
    _page = 1;
    _flag = 0;
    _chanpinokFlag = 0;
    _YNArray = @[@"是",@"否"];
    _departArr = [[NSMutableArray alloc] init];
    _cgpeopleIdArr = [[NSMutableArray alloc] init];
    _cgpeopleArr = [[NSMutableArray alloc] init];
    _cgAreaArr = [[NSMutableArray alloc] init];
    _payTypeArr = [[NSMutableArray alloc] init];
    _surpportArr = [[NSMutableArray alloc] init];
    
    _cpNameBtnArray = [[NSMutableArray alloc] init];
    _cpCodeArray = [[NSMutableArray alloc] init];
    _cpGuigeArray = [[NSMutableArray alloc] init];
    _cpDanweiArray = [[NSMutableArray alloc] init];
    _xiaoshouTypeArray = [[NSMutableArray alloc] init];
    _singlePriceArray = [[NSMutableArray alloc] init];
    _countArray = [[NSMutableArray alloc] init];
    _cpCodeArray = [[NSMutableArray alloc] init];
    _JineArray = [[NSMutableArray alloc] init];
    _keyongKuCunArray = [[NSMutableArray alloc] init];
    _colseArray = [NSMutableArray array];
    _fanliLvArray = [NSMutableArray array];
    _zhehouSinglePriceArray = [NSMutableArray array];
    _zhehouJineArray = [NSMutableArray array];
    //
    _CPIdArray = [[NSMutableArray alloc] init];
    _UnitIdArray = [[NSMutableArray alloc] init];
    _SaleTypeIdArray = [[NSMutableArray alloc] init];
    
    _chanpinViewArray = [[NSMutableArray alloc] init];
    _UNITArray = [NSMutableArray array];
    _UnitPriceArray = [NSMutableArray array];
    _zhuFuDanWeiArray = [NSMutableArray array];
    
    [self showBarWithName:@"提交" addBarWithName:nil];
    
    
    //进度HUD
    
    [self initScrollView];
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"正在加载中...";
    _HUD.dimBackground = YES;
    [_HUD show:YES];
    
    //客户页面
    [self initCustView];
    //默认一个产品信息页面
    [self addProducts];
//    [self initCustDetailView];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self nameRequest];
//        [self wuLiuRequest];
        [self fuKuanReqyest];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // [self PageViewDidLoad];
            
            
            [_HUD removeFromSuperview];
        });
    });
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    
}
- (void)initScrollView{
    
    self.dingDanAddScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    //self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, 790);
    self.dingDanAddScrollView.bounces = NO;
    self.dingDanAddScrollView.backgroundColor = [UIColor whiteColor];
    self.dingDanAddScrollView.delegate = self;
    [self.view addSubview:self.dingDanAddScrollView];
    
    
}
#pragma mark   客户信息页面
- (void)initCustView{
    //菜狗部门
    UILabel *label1 =  [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 45)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"采购部门*";
    [self.dingDanAddScrollView addSubview:label1];
    _nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nameButton.frame = CGRectMake(85, 0, KscreenWidth - 90, 45);
    [_nameButton setTintColor:[UIColor blackColor]];
    _nameButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_nameButton addTarget:self action:@selector(cgDepartAction) forControlEvents:UIControlEventTouchUpInside];
    [_nameButton setTitle:@"请选择部门" forState:UIControlStateNormal];
    _nameButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_nameButton];
    
    UIView *line1  = [[UIView alloc] initWithFrame:CGRectMake(0, _nameButton.bottom, KscreenWidth, 1)];
    line1.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line1];
    //采购员
    UILabel  *label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, line1.bottom+1, 80, 45)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"采购员";
    [self.dingDanAddScrollView addSubview:label3];
    _cgpeopleBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _cgpeopleBtn.frame = CGRectMake(85, line1.bottom+1, KscreenWidth - 90, 45);
    [_cgpeopleBtn setTintColor:[UIColor blackColor]];
    _cgpeopleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cgpeopleBtn setTitle:@"请选择采购员" forState:UIControlStateNormal];
    [_cgpeopleBtn addTarget:self action:@selector(cgpeopleAction) forControlEvents:UIControlEventTouchUpInside];
    _cgpeopleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_cgpeopleBtn];
    
    UIView *line2  = [[UIView alloc] initWithFrame:CGRectMake(0, _cgpeopleBtn.bottom, KscreenWidth, 1)];
    line2.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line2];
    //菜狗区域
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(5, line2.bottom+1, 80, 45)];
    label4.font = [UIFont systemFontOfSize:13];
    label4.text = @"采购区域";
    [self.dingDanAddScrollView addSubview:label4];
    _cgplaceBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _cgplaceBtn.frame = CGRectMake(85, line2.bottom+1, KscreenWidth - 90, 45);
    [_cgplaceBtn setTitle:@"请选择区域" forState:UIControlStateNormal];
    [_cgplaceBtn setTintColor:[UIColor blackColor]];
    _cgplaceBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_cgplaceBtn addTarget:self action:@selector(areaAction) forControlEvents:UIControlEventTouchUpInside];
    _cgplaceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_cgplaceBtn];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, _cgplaceBtn.bottom, KscreenWidth, 1)];
    line3.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line3];
    //付款方式
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(5, line3.bottom+1, 80, 45)];
    label5.font = [UIFont systemFontOfSize:13];
    label5.text = @"付款方式";
    [self.dingDanAddScrollView addSubview:label5];
    _payTypeButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _payTypeButton.frame = CGRectMake(85, line3.bottom+1, KscreenWidth - 90, 45);
    [_payTypeButton setTitle:@"请选择付款方式" forState:UIControlStateNormal];
    [_payTypeButton setTintColor:[UIColor blackColor]];
    _payTypeButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_payTypeButton addTarget:self action:@selector(paytypeAction) forControlEvents:UIControlEventTouchUpInside];
    _payTypeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_payTypeButton];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, _payTypeButton.bottom, KscreenWidth, 1)];
    line4.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line4];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(5, line4.bottom+1, 80, 45)];
    label6.font = [UIFont systemFontOfSize:13];
    label6.text = @"供应商";
    [self.dingDanAddScrollView addSubview:label6];
    _surpportBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _surpportBtn.frame = CGRectMake(85, line4.bottom+1, KscreenWidth - 90, 45);
    [_surpportBtn setTitle:@"请选择供应商" forState:UIControlStateNormal];
    [_surpportBtn setTintColor:[UIColor blackColor]];
    _surpportBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_surpportBtn addTarget:self action:@selector(surpportAction) forControlEvents:UIControlEventTouchUpInside];
    _surpportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_surpportBtn];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, _surpportBtn.bottom, KscreenWidth, 1)];
    line5.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line5];
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(5, line5.bottom+1, 80, 45)];
    label7.font = [UIFont systemFontOfSize:13];
    label7.text = @"采购时间";
    [self.dingDanAddScrollView addSubview:label7];
    _startBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _startBtn.frame = CGRectMake(85, line5.bottom+1, KscreenWidth - 90, 45);
    [_startBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
    [_startBtn setTintColor:[UIColor blackColor]];
    _startBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_startBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    _startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_startBtn];
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, _startBtn.bottom, KscreenWidth, 1)];
    line6.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line6];
    
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(5, line6.bottom+1, 80, 45)];
    label8.font = [UIFont systemFontOfSize:13];
    label8.text = @"备注";
    [self.dingDanAddScrollView addSubview:label8];
    _note = [[UITextField alloc]initWithFrame:CGRectMake(85, line6.bottom+1, KscreenWidth - 90, 45)];
    _note.textAlignment = NSTextAlignmentLeft;
    _note.textColor = [UIColor blackColor];
    _note.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_note];
    
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0, _startBtn.bottom, KscreenWidth, 1)];
    line7.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line7];
}


#pragma mark ----------------------------- 添加产品-------------------------------  -
- (void)addProducts
{
    
    NSString *proname;
    for (int i = 0; i < _flag; i++) {
        
        UIButton *btn = [_cpNameBtnArray objectAtIndex:i];
        proname = btn.titleLabel.text;
        proname = [self replaceChar:proname];
    }
    if ([proname isEqualToString:@"请选择物料"]) {
        [self showAlert:@"请选择物料后再继续添加"];
        return;
    }
    
    [self saleTypeRequest];
    _chanpinokFlag = 1;
    
    _flag = _flag + 1;
    self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, _note.bottom + _flag * 385+50);
    
    UIView *chanpinView = [[UIView alloc] initWithFrame:CGRectMake(0, _note.bottom + 385 * (_flag - 1), KscreenWidth, 480)];
    chanpinView.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            if (_flag>=2) {
                [self.dingDanAddScrollView setContentOffset:CGPointMake(0,(_flag-1) * 385) animated:YES];
            }
        });
        
    });
    
    //产品UI搭建
    
#pragma mark - 产品UI搭建
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 39)];
    info.backgroundColor = COLOR(220, 220, 220, 1);
    info.text = [NSString stringWithFormat:@"物料信息（%zi）",_flag];
    info.textAlignment = NSTextAlignmentCenter;
    info.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [chanpinView addSubview:info];
    //关闭按钮
//    if (_flag > 1) {
//        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        closeBtn.frame = CGRectMake(KscreenWidth - 40, 0, 40, 35);
//
//        [closeBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(closeChanpinView:) forControlEvents:UIControlEventTouchUpInside];
//        [chanpinView addSubview:closeBtn];
//        [_colseArray addObject:closeBtn];
//
//    }
    UILabel *line0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, KscreenWidth, 1)];
    line0.backgroundColor =  lineColor;
    [chanpinView addSubview:line0];
    
    //产品名称
    UILabel *chanPinName = [[UILabel alloc] initWithFrame:CGRectMake(5, 40 , 80, 45)];
    chanPinName.text = @"物料名称*";
    chanPinName.font = [UIFont systemFontOfSize:14];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 85, KscreenWidth, 1)];
    line1.backgroundColor = COLOR(240, 240, 240, 1);
    [chanpinView addSubview:line1];
    [chanpinView addSubview:chanPinName];
    
    UIButton *CPNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(86, 40, KscreenWidth - 90, 45)];
    CPNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CPNameBtn.tag = _flag;
    [CPNameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [CPNameBtn.titleLabel  setFont:[UIFont systemFontOfSize:14]];
    [CPNameBtn setTitle:@"请选择物料" forState:UIControlStateNormal];
    [CPNameBtn addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
    [chanpinView addSubview:CPNameBtn];
    [_cpNameBtnArray addObject:CPNameBtn];
    UILabel *CPID = [[UILabel alloc] initWithFrame:CGRectMake(86, 40, KscreenWidth - 90, 45)];
    [_CPIdArray addObject:CPID];
    
    
    UILabel *cPNO = [[UILabel alloc] initWithFrame:CGRectMake(5, chanPinName.bottom + 1 , 80, 45)];
    cPNO.text = @"物料编码";
    cPNO.font = [UIFont systemFontOfSize:14];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, cPNO.bottom, KscreenWidth, 1)];
    line2.backgroundColor = COLOR(240, 240, 240, 1);
    [chanpinView addSubview:line2];
    [chanpinView addSubview:cPNO];
    UILabel *proNo = [[UILabel alloc] initWithFrame:CGRectMake(86, chanPinName.bottom + 1, KscreenWidth - 90, 45)];
    proNo.font = [UIFont systemFontOfSize:14];
    proNo.textAlignment = NSTextAlignmentLeft;
    proNo.textColor = [UIColor grayColor];
    [chanpinView addSubview:proNo];
    [_cpCodeArray addObject:proNo];
    
    
    //产品规格
    UILabel *chanPinGuiGe =[[UILabel alloc] initWithFrame:CGRectMake(5, cPNO.bottom + 1, 80, 45)];
    chanPinGuiGe.text = @"物料规格";
    chanPinGuiGe.font = [UIFont systemFontOfSize:14];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, chanPinGuiGe.bottom, KscreenWidth, 1)];
    line3.backgroundColor = COLOR(240, 240, 240, 1);
    [chanpinView addSubview:line3];
    [chanpinView addSubview:chanPinGuiGe];
    UILabel *chanPinGuiGe1 = [[UILabel alloc] initWithFrame:CGRectMake(86, cPNO.bottom + 1, KscreenWidth - 90, 45)];
    chanPinGuiGe1.font = [UIFont systemFontOfSize:14];
    chanPinGuiGe1.textAlignment = NSTextAlignmentLeft;
    chanPinGuiGe1.textColor = [UIColor grayColor];
    [chanpinView addSubview:chanPinGuiGe1];
    [_cpGuigeArray addObject:chanPinGuiGe1];

    //产品单位
    UILabel *chanPinDanWei = [[UILabel alloc] initWithFrame:CGRectMake(5, chanPinGuiGe.bottom + 1, 80, 45)];
    chanPinDanWei.text = @"计量单位";
    chanPinDanWei.font = [UIFont systemFontOfSize:14];
    UIView *line4 =[[UIView alloc]initWithFrame:CGRectMake(0, chanPinDanWei.bottom, KscreenWidth, 1)];
    line4.backgroundColor = lineColor;
    [chanpinView addSubview:line4];
    [chanpinView addSubview:chanPinDanWei];
    UIButton *chanPinDanWeiButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    chanPinDanWeiButton1.frame = CGRectMake(86, chanPinGuiGe.bottom + 1, KscreenWidth - 90, 45);
    chanPinDanWeiButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [chanPinDanWeiButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    chanPinDanWeiButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    //chanPinDanWeiButton1.userInteractionEnabled = NO;
//    [chanPinDanWeiButton1 addTarget:self action:@selector(danweiAction) forControlEvents:UIControlEventTouchUpInside];
    chanPinDanWeiButton1.tag = _flag * 10;
    [chanpinView addSubview:chanPinDanWeiButton1];
    [_cpDanweiArray addObject:chanPinDanWeiButton1];
    //主副单位的ID
    UILabel *UnitID = [[UILabel alloc] initWithFrame:CGRectMake(86, 40, KscreenWidth - 90, 45)];
    [_UnitIdArray addObject:UnitID];
    //区分主副单位的ID
    UILabel *danWeiID = [[UILabel alloc] initWithFrame:CGRectMake(86, 40, KscreenWidth - 90, 45)];
    danWeiID.text= @"1";
    [_zhuFuDanWeiArray addObject:danWeiID];
    
    
    
    //单价
    UILabel *danJia =[[UILabel alloc] initWithFrame:CGRectMake(5, chanPinDanWei.bottom + 1, 80, 45)];
    danJia.text = @"单价";
    danJia.font = [UIFont systemFontOfSize:14];
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, danJia.bottom, KscreenWidth, 1)];
    line6.backgroundColor = lineColor;
    [chanpinView addSubview:line6];
    [chanpinView addSubview:danJia];
    
    danJia1 =[[UITextField alloc] initWithFrame:CGRectMake(86, chanPinDanWei.bottom + 1, KscreenWidth - 90, 45)];
    danJia1.font =[UIFont systemFontOfSize:14];
    danJia1.delegate = self;
    danJia1.tag = 102;
    danJia1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    danJia1.textAlignment = NSTextAlignmentLeft;
    danJia1.textColor = [UIColor grayColor];
    [chanpinView addSubview:danJia1];
    [_singlePriceArray addObject:danJia1];
    
    //数量
    UILabel *shuLiang = [[UILabel alloc] initWithFrame:CGRectMake(5, danJia1.bottom + 1, 80, 45)];
    shuLiang.text = @"数量";
    shuLiang.font = [UIFont systemFontOfSize:14];
    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(0, shuLiang.bottom, KscreenWidth, 1)];
    line7.backgroundColor = lineColor;
    [chanpinView addSubview:line7];
    [chanpinView addSubview:shuLiang];
    shuLiang1 = [[UITextField alloc] initWithFrame:CGRectMake(86, danJia1.bottom + 1, KscreenWidth - 90, 45)];
    shuLiang1.font =[UIFont systemFontOfSize:14];
    shuLiang1.delegate = self;
    shuLiang1.tag = 103;
    shuLiang1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    shuLiang1.textAlignment = NSTextAlignmentLeft;
    shuLiang1.textColor = [UIColor grayColor];
    shuLiang1.placeholder = @"请输入数量";
    [chanpinView addSubview:shuLiang1];
    [_countArray addObject:shuLiang1];
    
    
    //金额
    UILabel *jinE = [[UILabel alloc] initWithFrame:CGRectMake(5, shuLiang.bottom + 1, 80, 45)];
    jinE.text = @"金额";
    jinE.font =[UIFont systemFontOfSize:14];
    UIView *line10 = [[UIView alloc] initWithFrame:CGRectMake(0, jinE.bottom, KscreenWidth, 1)];
    line10.backgroundColor = lineColor;
    [chanpinView addSubview:line10];
    [chanpinView addSubview:jinE];
    UILabel *jinE1 = [[UILabel alloc] initWithFrame:CGRectMake(86, shuLiang.bottom + 1, 60, 45)];
    jinE1.font = [UIFont systemFontOfSize:14];
    jinE1.textAlignment = NSTextAlignmentLeft;
    jinE1.textColor = [ UIColor grayColor];
    [chanpinView addSubview:jinE1];
    [_JineArray addObject:jinE1];
    
    [self.dingDanAddScrollView addSubview:chanpinView];
    
    [_chanpinViewArray addObject:chanpinView];
    
//    //添加产品的按钮设置
//    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 385, KscreenWidth, 45)];
//    buttonView.backgroundColor = COLOR(220, 220, 220, 1);
//    UIButton *tianJiaButton = [[UIButton alloc] initWithFrame:CGRectMake(KscreenWidth - 90, 0, 80, 45)];
//    [tianJiaButton setTitle:@"继续添加" forState:UIControlStateNormal];
//    [tianJiaButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [tianJiaButton addTarget:self action:@selector(addProducts) forControlEvents:UIControlEventTouchUpInside];
//    tianJiaButton.backgroundColor = [UIColor clearColor];
//    tianJiaButton.titleLabel.font = [ UIFont systemFontOfSize:16];
//    [buttonView  addSubview:tianJiaButton];
//    [chanpinView addSubview:buttonView];
    //[self initCustDetailView];
    
    //添加产品的按钮设置
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 385, KscreenWidth, 45)];
    buttonView.backgroundColor = COLOR(220, 220, 220, 1);
    UIButton *tianJiaButton = [[UIButton alloc] initWithFrame:CGRectMake(KscreenWidth - 90, 0, 80, 45)];
    [tianJiaButton setTitle:@"添加物料" forState:UIControlStateNormal];
    [tianJiaButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [tianJiaButton addTarget:self action:@selector(addProducts) forControlEvents:UIControlEventTouchUpInside];
    tianJiaButton.backgroundColor = [UIColor clearColor];
    tianJiaButton.titleLabel.font = [ UIFont systemFontOfSize:16];
    [buttonView  addSubview:tianJiaButton];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(KscreenWidth - 180, 0, 80, 45);
    [closeBtn setTitle:@"删除物料" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.titleLabel.font = [ UIFont systemFontOfSize:16];
    [closeBtn addTarget:self action:@selector(closeChanpinView:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:closeBtn];
    [chanpinView addSubview:buttonView];
    _detailView.frame = CGRectMake(0, 182 + 385 + (_flag - 1)  * 385, KscreenWidth, 310);
}
- (void)upRefresh
{
    _page++;
    
//    [self nameRequest];
}


- (void)upRefresh1
{
    _page1++;
    [self getCPInfo];
}
#pragma mark - 上拉判断
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh];
        }
    } else if (scrollView.tag == 50){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            
        }
    }
}

//关闭产品界面
- (void)closeChanpinView:(UIButton *)button
{
    
    if (_flag == 1) {
        [self showAlert:@"至少保留一条物料信息"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除本条信息吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 110;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 108) {
        
        if (buttonIndex == 0) {
            _wuLiuDaiShou.titleLabel.text  = @"否";
        }else if (buttonIndex == 1){
            
            _wuLiuDaiShou.titleLabel.text = @"是";
        }
        
    }else if(alertView.tag == 110) {
        
        
        
        if (buttonIndex == 1) {
            
            
            [_dataArray1 removeAllObjects];
            [_cpCodeArray removeObjectAtIndex:_flag - 1];
            [_cpGuigeArray removeObjectAtIndex:_flag - 1];
            [_singlePriceArray removeObjectAtIndex:_flag - 1];
            [_cpDanweiArray removeObjectAtIndex:_flag - 1];
//            [_UNITArray removeObjectAtIndex:_flag-1];
            [_JineArray removeObjectAtIndex:_flag - 1];
            [_cpNameBtnArray removeObjectAtIndex:_flag - 1];
            [_countArray removeObjectAtIndex:_flag - 1];
            
            UIView *view = [_chanpinViewArray objectAtIndex:_flag - 1];
            [view removeFromSuperview];
            [_chanpinViewArray removeObjectAtIndex:_flag - 1];
            self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, self.dingDanAddScrollView.contentSize.height - 385);
            //客户详情的位置
            _detailView.frame = CGRectMake(0, 182 +  (_flag - 1)  * 385, KscreenWidth, 310);
            _flag -= 1;
        }
        
        
    }else if (alertView.tag == 1010){
        
        if (buttonIndex == 1) {
            
            [self sureComit];
            
            
        }
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 103) {
        //计算金额
//        UITextField *danJia = [_singlePriceArray objectAtIndex:_flag -1];
//        UITextField *shuliang = [_countArray objectAtIndex:_flag - 1];
//        UILabel *jinE = [_JineArray objectAtIndex:_flag - 1];
        
        

        
        for (int i = 0; i < _flag; i++) {
            UITextField * spTf = [_singlePriceArray objectAtIndex:i];
            singleprice = spTf.text;
            singleprice = [self replaceChar:singleprice];
            UITextField * ctTf = [_countArray objectAtIndex:i];
            count = ctTf.text;
            count = [self replaceChar:count];
            double danjia = [singleprice floatValue];
            double shumu = [count doubleValue];
            double jine = danjia * shumu ;
            _jine1 = [NSString stringWithFormat:@"%.2f",jine];
            UILabel *jinE = _JineArray[i];
            jinE.text = _jine1;
        }
        
    }
    if (textField.tag == 102) {
        //计算金额
        for (int i = 0; i < _flag; i++) {
            UITextField * spTf = [_singlePriceArray objectAtIndex:i];
            singleprice = spTf.text;
            singleprice = [self replaceChar:singleprice];
            UITextField * ctTf = [_countArray objectAtIndex:i];
            count = ctTf.text;
            count = [self replaceChar:count];
            double danjia = [singleprice floatValue];
            double shumu = [count doubleValue];
            double jine = danjia * shumu ;
            _jine1 = [NSString stringWithFormat:@"%.2f",jine];
            UILabel *jinE = _JineArray[i];
            jinE.text = _jine1;
        }
        
    }
    
}
#pragma mark - 单位价格
- (void)getPriceOFUnit
{
    NSString *strAdress = @"/order";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSDictionary  *params = @{@"action":@"getPriceByUnit",@"params":[NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"unitid\":\"%@\"}",_custid,_proid,_unitid]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"单位加载%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            NSString *unitPrice = [NSString stringWithFormat:@"%@",dic[@"saleprice"]];
            
            UIButton *xiaoshouleixing = [_xiaoshouTypeArray objectAtIndex:_flag-1];
            NSString *saleType = xiaoshouleixing.titleLabel.text;
            
            UILabel *danjia = [_singlePriceArray objectAtIndex:_flag-1];
//            UILabel *zhehoudanjia = [_zhehouSinglePriceArray objectAtIndex:_flag - 1];
//            UITextField *falilv = [_fanliLvArray objectAtIndex:_flag - 1];
            UILabel *jinE = [_JineArray objectAtIndex:_flag - 1];
//            UILabel *zheHouJinE = [_zhehouJineArray objectAtIndex:_flag - 1];
            UITextField *shuliang = [_countArray objectAtIndex:_flag - 1];
            UILabel *danWeiId = [_zhuFuDanWeiArray objectAtIndex:_flag - 1];
            danWeiId.text = [NSString stringWithFormat:@"%@",dic[@"type"]];
            
//            double reRate = [falilv.text doubleValue];
            double danJia = [unitPrice doubleValue];
            double count = [shuliang.text doubleValue];
//            double zheHouDanJia = danJia * (1.00 - reRate);
            
            
//            double zhehoujine = zheHouDanJia * count;
            double jine = danJia *count;
            //最高限制销售类型
            if ([saleType isEqualToString:@"赠品"]) {
                danjia.text = @"0.00";
//                zhehoudanjia.text = @"0.00";
//                jinE.text = @"0.00";
//                zheHouJinE.text = @"0.00";
                
            } else{
                
                danjia.text = unitPrice;
//                zhehoudanjia.text = [NSString stringWithFormat:@"%.2f",zheHouDanJia];
//                jinE.text = [NSString stringWithFormat:@"%.2f",jine];
//                zheHouJinE.text = [NSString stringWithFormat:@"%.2f",zhehoujine];
            }
            
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    
}

#pragma mark - 产品单位请求
- (void)danweiAction
{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor grayColor];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tag = 60;
    [bgView addSubview:self.tableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self danweiRequest];
    
}
- (void)danweiRequest{
    
    _danweiArr = [[NSMutableArray alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary *params = @{@"action":@"getProUnitSelect",@"params":[NSString stringWithFormat:@"{\"proid\":\"%@\"}",_proid]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"单位:%@",array);
        for (NSDictionary *dic in array) {
            DWandLXModel *model = [[DWandLXModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_danweiArr addObject:model];
        }
        NSLog(@"单位%@",_danweiArr);
        [self.tableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
}

#pragma mark - 销售类型请求
- (void)saleTypeAction
{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tag = 70;
    [bgView addSubview:self.tableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self saleTypeRequest];
    
}
- (void)saleTypeRequest{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSString *str = @"type=saletype&action=getSelectType&table=base&";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        returnStr = [self replaceOthers:returnStr];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            _leixingArr = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                DWandLXModel *model = [[DWandLXModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_leixingArr addObject:model];
            }
            [self.tableView reloadData];
            NSLog(@"销售类型:%@",array);
        }
    }
    
}
//产品信息的  按钮
- (void)proAction
{
    /*
     产品名称
     http://182.92.96.58:8005/yrt/servlet/order
     action    fuzzyQuery
     mobile    true
     page    1
     params    {"proname":"","custid":"137"}  id = 1357;
     rows    10
     table    cpxx
     */
    //产品名称－－的接口
    //self.m_chanPinNameButton.userInteractionEnabled = NO;
    NSString *cust = _nameButton.titleLabel.text;
    
    if ([cust isEqualToString:@"请选择客户"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择客户再操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
        //      self.m_keHuPopView.backgroundColor = [UIColor grayColor];
        self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        //
        _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
        _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
        [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
        [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
        _proField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40,KscreenWidth - 80 , 40)];
        _proField.backgroundColor = [UIColor whiteColor];
        _proField.delegate = self;
        
        _proField.placeholder = @"名称关键字";
        _proField.borderStyle = UITextBorderStyleBezel;
        _proField.font = [UIFont systemFontOfSize:13];
        [self.m_keHuPopView addSubview:_proField];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"搜索" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        btn.frame = CGRectMake(_proField.right, 40, 60, 40);
        
        [btn.layer setBorderWidth:0.5]; //边框宽度
        [btn addTarget:self action:@selector(getCPInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.m_keHuPopView addSubview:btn];
        
        if (self.proTableView == nil) {
            self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 80,KscreenWidth-20, KscreenHeight-174) style:UITableViewStylePlain];
            self.proTableView.backgroundColor = [UIColor whiteColor];
        }
        self.proTableView.dataSource = self;
        self.proTableView.delegate = self;
        self.proTableView.tag = 50;
        self.proTableView.rowHeight = 50;
        [self.m_keHuPopView addSubview:self.proTableView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
        [self getCPInfo];
    }
}

- (void)getCPInfo
{
        NSString *proName = _proField.text;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/purchaseManage"];
        NSDictionary *params = @{@"action":@"getMaterials",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"nameLike\":\"%@\"}",proName]};
        NSLog(@"%@",params);
        [_UNITArray removeAllObjects];
        [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"产品信息返回:%@",dic);
            [_dataArray1 removeAllObjects];
            
            for (NSDictionary *dic in array) {
                KHnameModel *model = [[KHnameModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
                CPINfoModel *cpmodel = [[CPINfoModel alloc] init];
                [cpmodel setValuesForKeysWithDictionary:dic];
                [_UNITArray addObject:cpmodel];
//                [_UNITArray addObject:dic[@"measureunit"]];
            }
            
            
            
            [self.proTableView reloadData];
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSLog(@"加载失败");
            NSInteger errorCode = error.code;
            NSLog(@"错误信息%@",error);
            if (errorCode == 3840 ) {
                NSLog(@"自动登录");
                [self selfLogin];
            }else{
                
                //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
            }
            
        }];
}


#pragma mark - TableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 10) {
        return _departArr.count;
    }else if(tableView.tag == 20){
        return _cgpeopleArr.count;
    }else if(tableView.tag == 30){
        return _cgAreaArr.count;
    }else if(tableView.tag == 40){
        return _payTypeArr.count;
    }else if (tableView.tag == 1050){
        return _surpportArr.count;
    }else if (tableView.tag == 50){
        return _dataArray1.count;
    }else if (tableView.tag == 60){
        return _danweiArr.count;
    }else if (tableView.tag == 70){
        return _leixingArr.count;
    }else if (tableView.tag == 80){
        
        return _YNArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        //cell.textLabel.textColor = [UIColor whiteColor];
    }
    CPInfoCell *cell1 =  [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = (CPInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"CPInfoCell" owner:self options:nil]firstObject];
        cell1.backgroundColor = [UIColor whiteColor];
        
    }
    CustCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = (CustCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil]lastObject];
        cell2.backgroundColor = [UIColor whiteColor];
    }
    if (tableView.tag == 10) {
        if (_departArr.count) {
            
            cell2.model = _departArr[indexPath.row];
        }
        return cell2;
    }else if(tableView.tag == 20){
        cell.textLabel.text = _cgpeopleArr[indexPath.row];
      return cell;
        
    }else if (tableView.tag == 30){
        if (_cgAreaArr.count) {
            
            cell2.model = _cgAreaArr[indexPath.row];
        }
        return cell2;
        
    }else if (tableView.tag == 40){
        
        cell.textLabel.text = _payTypeArr[indexPath.row];
        return cell;
        
    }else if (tableView.tag == 1050){
        
        cell2.model = _surpportArr[indexPath.row];
        return cell2;
        
    }else if (tableView.tag == 50){
        
        cell2.model = _dataArray1[indexPath.row];
        return cell2;
        
    }else if (tableView.tag == 70) {
        DWandLXModel *model = [_leixingArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    } else if (tableView.tag == 60) {
        
        if (_danweiArr.count != 0) {
            DWandLXModel *model = [_danweiArr objectAtIndex:indexPath.row];
            cell.textLabel.text = model.name;
            return cell;
        }
        
    }else if (tableView.tag == 80){
        cell.textLabel.text = _YNArray[indexPath.row];
        return cell;
    }
    return cell;
}

//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.m_keHuPopView removeFromSuperview];
    if (tableView.tag == 10) {
        [self.m_keHuPopView removeFromSuperview];
        _nameButton.userInteractionEnabled = YES;
        KHnameModel *model = [_departArr objectAtIndex:indexPath.row];
        [_nameButton setTitle:model.name forState:UIControlStateNormal];
        _custid = model.Id;
        
        [self getCPInfo];
    } else if(tableView.tag == 20) {
        
        _cgpeopleBtn.userInteractionEnabled = YES;
        [_cgpeopleBtn setTitle:_cgpeopleArr[indexPath.row] forState:UIControlStateNormal];
        _cgpeopleId = _cgpeopleIdArr[indexPath.row];
        
    } else if (tableView.tag == 30){
        [self.m_keHuPopView removeFromSuperview];
        _cgplaceBtn.userInteractionEnabled = YES;
        KHnameModel *model = [_cgAreaArr objectAtIndex:indexPath.row];
        [_cgplaceBtn setTitle:model.name forState:UIControlStateNormal];
        _cgplaceId = model.Id;
        
    } else if (tableView.tag == 40){
        
        [_payTypeButton setTitle:_payTypeArr[indexPath.row] forState:UIControlStateNormal];
        _payTypeId = _fukuanfangshiId[indexPath.row];
        
        
        
    }else if (tableView.tag == 1050){
        
        [self.m_keHuPopView removeFromSuperview];
        _surpportBtn.userInteractionEnabled = YES;
        KHnameModel *model = [_surpportArr objectAtIndex:indexPath.row];
        [_surpportBtn setTitle:model.name forState:UIControlStateNormal];
        _supportId = model.Id;

    } else if (tableView.tag == 50){
        //产品信息
        CPINfoModel *model = [[CPINfoModel alloc]init];
        model = _UNITArray[indexPath.row];
        UIButton *btn = [_cpNameBtnArray objectAtIndex:_flag-1];
        
        UILabel *cpCode = [_cpCodeArray objectAtIndex:_flag - 1];
        UILabel *chanpinguige = [_cpGuigeArray objectAtIndex:_flag-1];
        UILabel *danjia = [_singlePriceArray objectAtIndex:_flag-1];
        UIButton *danWei = [_cpDanweiArray objectAtIndex:_flag - 1];
        UILabel *CpId = [_CPIdArray objectAtIndex:_flag - 1];
        UILabel *UnitId = [_UnitIdArray objectAtIndex:_flag - 1];
        _measureunitid =  [NSString stringWithFormat:@"%@",model.measureunitid];
        _proid =  [NSString stringWithFormat:@"%@",model.Id];
        [btn setTitle:model.name forState:UIControlStateNormal];
        cpCode.text = [NSString stringWithFormat:@"%@",model.materialsno];
        chanpinguige.text = [NSString stringWithFormat:@"%@",model.size];
        [danWei setTitle:model.measureunit forState:UIControlStateNormal];
        danjia.text = [NSString stringWithFormat:@"%@",model.price];
        
        CpId.text = [NSString stringWithFormat:@"%@",model.Id];
        
    } else if (tableView.tag == 60) {
        
        if (_danweiArr.count != 0) {
            DWandLXModel *model = [_danweiArr objectAtIndex:indexPath.row];
            UIButton *chanpindanwei = [_cpDanweiArray objectAtIndex:_flag-1];
            UILabel *UnitId = [_UnitIdArray objectAtIndex:_flag - 1];
            [chanpindanwei setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
            UnitId.text = [NSString stringWithFormat:@"%@",model.Id];
            _unitid = [NSString stringWithFormat:@"%@",model.Id];
            [self getPriceOFUnit];
        }
        
        
    } else if (tableView.tag == 70) {
        //销售类型控制单价金额
        DWandLXModel *model = [_leixingArr objectAtIndex:indexPath.row];
        UIButton *xiaoshouleixing = [_xiaoshouTypeArray objectAtIndex:_flag-1];
        UILabel *SaleTypeId = [_SaleTypeIdArray objectAtIndex:_flag - 1];
        [xiaoshouleixing setTitle:model.name forState:UIControlStateNormal];
        SaleTypeId.text = [NSString stringWithFormat:@"%@",model.Id];
        UILabel *danjia = [_singlePriceArray objectAtIndex:_flag-1];
        UILabel *zhehoudanjia = [_zhehouSinglePriceArray objectAtIndex:_flag - 1];
        UITextField *falilv = [_fanliLvArray objectAtIndex:_flag - 1];
        UILabel *jinE = [_JineArray objectAtIndex:_flag - 1];
        UILabel *zheHouJinE = [_zhehouJineArray objectAtIndex:_flag - 1];
        UITextField *shuliang = [_countArray objectAtIndex:_flag - 1];
        
        double reRate = [falilv.text doubleValue];
        double danJia = [_price doubleValue];
        double count = [shuliang.text doubleValue];
        double zheHouDanJia = danJia * (1.00 - reRate);
        
        
        double zhehoujine = zheHouDanJia * count;
        double jine = danJia *count;
        
        if ([model.name isEqualToString:@"赠品"]) {
            danjia.text = @"0.00";
            zhehoudanjia.text = @"0.00";
            jinE.text = @"0.00";
            zheHouJinE.text = @"0.00";
            
        } else{
            
            danjia.text = _price;
            zhehoudanjia.text = [NSString stringWithFormat:@"%.2f",zheHouDanJia];
            jinE.text = [NSString stringWithFormat:@"%.2f",jine];
            zheHouJinE.text = [NSString stringWithFormat:@"%.2f",zhehoujine];
        }
        
        
    }else if(tableView.tag == 80){
        
        [self.m_keHuPopView removeFromSuperview];
        NSString *str = _YNArray[indexPath.row];
        [_wuLiuDaiShou setTitle:str forState:UIControlStateNormal];
        //对代收金额输入限制
        NSString *daishou = str;
        if ([daishou isEqualToString:@"否"]) {
            _daiShouJinE.userInteractionEnabled = NO;
        }else{
            _daiShouJinE.userInteractionEnabled = YES;
        }
        
    }
}
#pragma mark  -- 订单添加事件
- (void)shangChuan
{
    
    if ([_nameButton.titleLabel.text isEqualToString:@"请选择部门"]) {
        [self showAlert:@"请选择部门"];
        return;
    }
    if ([_cgpeopleBtn.titleLabel.text isEqualToString:@"请选择采购员"]) {
        [self showAlert:@"请选择采购员"];
        return;
    }
    if ([_cgplaceBtn.titleLabel.text isEqualToString:@"请选择区域"]) {
        [self showAlert:@"请选择区域"];
        return;
    }
    if ([_payTypeButton.titleLabel.text isEqualToString:@"请选择付款方式"]) {
        [self showAlert:@"请选择付款方式"];
        return;
    }
    if ([_surpportBtn.titleLabel.text isEqualToString:@"请选择供应商"]) {
        [self showAlert:@"请选择供应商"];
        return;
    }
    if ([_startBtn.titleLabel.text isEqualToString:@"请选择时间"]) {
        [self showAlert:@"请选择时间"];
        return;
    }
    
    
    if (_chanpinokFlag == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加物料" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else if (_chanpinokFlag == 1){
        NSString *proname;
        
        for (int i = 0; i < _flag; i++) {
            
            UIButton *btn = [_cpNameBtnArray objectAtIndex:i];
            proname = btn.titleLabel.text;
            proname = [self replaceChar:proname];
            UITextField * spTf = [_singlePriceArray objectAtIndex:i];
            singleprice = spTf.text;
            singleprice = [self replaceChar:singleprice];
             UITextField * ctTf = [_countArray objectAtIndex:i];
            count = ctTf.text;
            count = [self replaceChar:count];
            if ([singleprice isEqualToString:@""]) {
                [self showAlert:@"单价不可为空"];
                return;
            }
            if ([count isEqualToString:@""]){
                [self showAlert:@"数量不可为空"];
                return;
            }
            
        }
        if ([proname isEqualToString:@"请选择物料"]) {
            [self showAlert:@"请添加物料"];
            return;
        }
        
        _showOrder = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否添加此订单?"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
            
            _showOrder.tag = 1010;
            [_showOrder show];
    }
}
//字典转json格式字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(void)sureComit{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/purchase"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    //计算总金额
    double totalmoney = 0;
    //        double totalzhehou = 0;
    NSInteger totalshumu = 0;
    
    for (int i = 0; i < _flag; i++) {
        
        UILabel *jinE = [_JineArray objectAtIndex:i];
        UITextField *shuliang = [_countArray objectAtIndex:i];
        //            UILabel *zhehoujine = [_zhehouJineArray objectAtIndex:i];
        
        totalmoney = totalmoney + [jinE.text doubleValue];
        //            totalzhehou = totalzhehou + [zhehoujine.text doubleValue];
        totalshumu = totalshumu + [shuliang.text integerValue];
    }
    //        _totalZheHou = [NSString stringWithFormat:@"%.2f",totalzhehou];
    _totalJine = [NSString stringWithFormat:@"%.2f",totalmoney];
    _totalaccount = [NSString stringWithFormat:@"%zi",totalshumu];
    
    
    //代收
    NSString *daishouStr  = _wuLiuDaiShou.titleLabel.text;
    NSLog(@"－－－－－长度%zi",daishouStr.length);
    NSString *daiShou;
    daiShou = [self convertNull:daiShou];
    NSString *daiShouMoney;
    daiShouMoney = [self convertNull:daiShouMoney];
    
    if ([daishouStr isEqualToString:@"是"]) {
        daiShou = @"1";
        daiShouMoney = _daiShouJinE.text;
        
    }else if([daishouStr isEqualToString:@"否"]){
        daiShou = @"0";
        daiShouMoney = @"0";
        daiShouMoney = [self convertNull:daiShouMoney];
    }
    
    //联系人
    NSString *reciever = _receiver.text;
    reciever = [self convertNull:reciever];
    
    NSString *recieveTel = _receiveTel.text;
    recieveTel = [self convertNull:recieveTel];
    
    NSString *recieveAdd = _receiveAdd.text;
    recieveAdd = [self convertNull:recieveAdd];
    
    NSString *wuliu = _wuLiuButton.titleLabel.text;
    wuliu = [self convertNull:wuliu];
    
    NSString *wuliuId = self.wuLiuID;
    wuliuId = [self convertNull:wuliuId];
    
    NSString *name = _nameButton.titleLabel.text;
    name = [self convertNull:name];
    
    NSString *cgplacename = _cgplaceBtn.titleLabel.text;
    cgplacename = [self convertNull:cgplacename];
    
    NSString *cgpeoplename = _cgpeopleBtn.titleLabel.text;
    cgpeoplename = [self convertNull:cgpeoplename];
    
    
    NSString *creditline = _yuEField.text;
    creditline = [self convertNull:creditline];
    
    NSString *notetf = _note.text;
    notetf = [self convertNull:notetf];
    
    NSString *paidtype = _payTypeButton.titleLabel.text;
    paidtype = [self convertNull:paidtype];
    _payTypeId = [self convertNull:_payTypeId];
    
    NSString *supportname = _surpportBtn.titleLabel.text;
    supportname = [self convertNull:supportname];
    
    NSString *startTime = _startBtn.titleLabel.text;
    startTime = [self convertNull:startTime];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"SP=true&action=addPurchase&table=cgd&data={\"table\":\"cgd\",\"totalmoney\":\"%@\",\"departid\":\"%@\",\"departname\":\"%@\",\"placeid\":\"%@\",\"placename\":\"%@\",\"accountid\":\"%@\",\"accountname\":\"%@\",\"paytypeid\":\"%@\",\"paytype\":\"%@\",\"time\":\"%@\",\"supplierid\":\"%@\",\"suppliername\":\"%@\",\"note\":\"%@\"}",_totalJine,_custid,name,_cgplaceId,cgplacename,_cgpeopleId,cgpeoplename,_payTypeId,paidtype,startTime,_supportId,supportname,notetf];
    NSMutableString *chanpinStr = [NSMutableString stringWithFormat:@"\"cgmxList\":[]"];

    
        for (int i = 0; i < _flag; i++) {
            
            UIButton *btn = [_cpNameBtnArray objectAtIndex:i];
            NSString *proname = btn.titleLabel.text;
            proname = [self replaceChar:proname];
            UILabel *chanpinCode = [_cpCodeArray objectAtIndex:i];
            UILabel *chanpinguige = [_cpGuigeArray objectAtIndex:i];
            UILabel *danjia = [_singlePriceArray objectAtIndex:i];
            UIButton *chanpindanwei = [_cpDanweiArray objectAtIndex:i];
            NSString *chanpindanweis = chanpindanwei.titleLabel.text;
            chanpindanweis = [self replaceChar:chanpindanweis];
            UITextField *shuliang = [_countArray objectAtIndex:i];
            UILabel *jinE = [_JineArray objectAtIndex:i];
            //                UILabel *CpId = [_CPIdArray objectAtIndex:i];
            UILabel *UnitId = [_UnitIdArray objectAtIndex:i];
            NSLog(@"%@",UnitId.text);
            //                UILabel *danWeiId = [_zhuFuDanWeiArray objectAtIndex:i]; //区分主副单位的ID
            [chanpinStr insertString:[NSString stringWithFormat:@"{\"table\":\"cgmx\",\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"specification\":\"%@\",\"mainunitid\":\"%@\",\"mainunitname\":\"%@\",\"rkstatus\":\"%@\",\"singleprice\":\"%@\",\"procount\":\"%@\",\"money\":\"%@\"},",_proid,proname,chanpinCode.text,chanpinguige.text,_measureunitid,chanpindanweis,@"0",danjia.text,shuliang.text,jinE.text] atIndex:chanpinStr.length - 1];
            
            
        }
        
        NSUInteger length = chanpinStr.length;
        [chanpinStr deleteCharactersInRange:NSMakeRange(length-2, 1)];
        [str insertString:[NSString stringWithFormat:@",%@",chanpinStr] atIndex:str.length-1];
        NSLog(@"添加订单字符串:%@",str);
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"添加订单返回信息:%@",str1);
        
        NSRange range = {1,str1.length-2};
        if (str1.length != 0) {
            NSString *reallystr = [str1 substringWithRange:range];
            if ([reallystr isEqualToString:@"true"]) {
                
                [self showAlert:@"添加订单成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrder" object:self];
            } else {
                
                [self showAlert:@"添加订单失败"];
                
            }
            _showOrder.userInteractionEnabled = YES;  //解开alert的禁止点击应用
        }
        
//    } else if (_nullFlag == 0){
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"单价、数量不可为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}
#pragma mark - 提交按钮方法
- (void)addNext{
    //    NSString *count = [NSString stringWithFormat:@"订单数量:%@",_totalaccount];
    //    NSString *money = [NSString stringWithFormat:@"订单金额:%@",_totalJine];
    
    [self shangChuan];
    _showOrder.userInteractionEnabled = NO; //禁止点击事件防止多次点击
    
    
}
-(NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}

-(NSString*)DeFault:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"0";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"0";
    }
    else if (object==nil){
        return @"0";
    }
    return object;
    
}
- (void)closePop
{
    _page1 = 1;
    _page = 1;
    if ([self keyboardDid]) {
        [_yuEField resignFirstResponder];
        [_receiver resignFirstResponder];
        [_receiveTel resignFirstResponder];
        [_receiveAdd resignFirstResponder];
        [_daiShouJinE resignFirstResponder];
        [_note resignFirstResponder];
        [_proField resignFirstResponder];
        [_custField resignFirstResponder];
        
    }else{
        _nameButton.userInteractionEnabled = YES;
        _payTypeButton.userInteractionEnabled = YES;
        _wuLiuButton.userInteractionEnabled = YES;
        
        [self.m_keHuPopView removeFromSuperview];
        [self.tableView removeFromSuperview];
    }
}

- (void)searchAction{
    
}
-(void)cgDepartAction{
    
    [self showDepartTableView];
    NSLog(@"数据个数%zi",_dataArray.count);
    NSLog(@"11");
    if (_departArr.count == 0) {
        NSLog(@"12");
        [self departDataRequest];
        [self.departTable reloadData];
    }
    [_Hud removeFromSuperview];
}
- (void)showDepartTableView{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    _departField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
    _departField.backgroundColor = [UIColor whiteColor];
    _departField.delegate = self;
    _departField.tag =  101;
    _departField.placeholder = @"名称关键字";
    _departField.borderStyle = UITextBorderStyleRoundedRect;
    _departField.font = [UIFont systemFontOfSize:13];
    [self.m_keHuPopView addSubview:_departField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_departField.right, 40, 60, 40);
    
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(departDataRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.departTable == nil) {
        self.departTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.departTable.backgroundColor = [UIColor whiteColor];
    }
    self.departTable.dataSource = self;
    self.departTable.delegate = self;
    self.departTable.tag = 10;
    self.departTable.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.departTable];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.departTable reloadData];
    
    _Hud = [MBProgressHUD showHUDAddedTo:self.departTable animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];
}
-(void)departDataRequest{
    ///department?action=getTree&table=xtbm
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/department"];
    NSDictionary *params = @{@"action":@"getPhoneDepartment",@"mobile":@"true",@"table":@"xtbm",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20"};
    NSLog(@"%@",params);
    [_departArr removeAllObjects];
    [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"产品信息返回:%@",dic);
        [_departArr removeAllObjects];
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_departArr addObject:model];
        }
        [self.departTable reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
}
-(void)cgpeopleAction{
    [self showCGPeopleTableView];
    NSLog(@"数据个数%zi",_cgpeopleArr.count);
    NSLog(@"11");
    if (_cgpeopleArr.count == 0) {
        NSLog(@"12");
        [self cgPeopleDataRequest];
        [self.cgpeopleTable reloadData];
    }
    [_Hud removeFromSuperview];
}
- (void)showCGPeopleTableView{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  101;
    _custField.placeholder = @"名称关键字";
    _custField.borderStyle = UITextBorderStyleRoundedRect;
    _custField.font = [UIFont systemFontOfSize:13];
    [self.m_keHuPopView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, 40, 60, 40);
    
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(departDataRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.cgpeopleTable == nil) {
        self.cgpeopleTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.cgpeopleTable.backgroundColor = [UIColor whiteColor];
    }
    self.cgpeopleTable.dataSource = self;
    self.cgpeopleTable.delegate = self;
    self.cgpeopleTable.tag = 20;
    self.cgpeopleTable.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.cgpeopleTable];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.cgpeopleTable reloadData];
    
    _Hud = [MBProgressHUD showHUDAddedTo:self.cgpeopleTable animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];
}
-(void)cgPeopleDataRequest{
    ///department?action=getTree&table=xtbm
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"mobile":@"true",@"table":@"ddxx",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",_custField.text]};
    NSLog(@"%@",params);
    [_cgpeopleArr removeAllObjects];
    [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"产品信息返回:%@",dic);
        [_cgpeopleArr removeAllObjects];
        for (NSDictionary *dic in array) {
            [_cgpeopleArr addObject:dic[@"name"]];
            [_cgpeopleIdArr addObject:dic[@"id"]];
        }
        [self.cgpeopleTable reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
        }
        
    }];
}
-(void)areaAction{
    [self showAreaTableView];
    NSLog(@"数据个数%zi",_cgAreaArr.count);
    NSLog(@"11");
    if (_cgAreaArr.count == 0) {
        NSLog(@"12");
        [self cgAreaDataRequest];
        [self.cgAreaTable reloadData];
    }
    [_Hud removeFromSuperview];
}
- (void)showAreaTableView{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    _areaField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
    _areaField.backgroundColor = [UIColor whiteColor];
    _areaField.delegate = self;
    _areaField.tag =  101;
    _areaField.placeholder = @"名称关键字";
    _areaField.borderStyle = UITextBorderStyleRoundedRect;
    _areaField.font = [UIFont systemFontOfSize:13];
    [self.m_keHuPopView addSubview:_areaField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_areaField.right, 40, 60, 40);
    
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(departDataRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.cgAreaTable == nil) {
        self.cgAreaTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.cgAreaTable.backgroundColor = [UIColor whiteColor];
    }
    self.cgAreaTable.dataSource = self;
    self.cgAreaTable.delegate = self;
    self.cgAreaTable.tag = 30;
    self.cgAreaTable.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.cgAreaTable];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.cgAreaTable reloadData];
    
    _Hud = [MBProgressHUD showHUDAddedTo:self.cgAreaTable animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];
}
-(void)cgAreaDataRequest{
    ///department?action=getTree&table=xtbm
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/department"];
    NSDictionary *params = @{@"action":@"getPhonePlace",@"mobile":@"true",@"table":@"cgqy",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20"};
    NSLog(@"%@",params);
    [_cgAreaArr removeAllObjects];
    [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"产品信息返回:%@",dic);
        [_cgAreaArr removeAllObjects];
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_cgAreaArr addObject:model];
        }
        [self.cgAreaTable reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
}
-(void)paytypeAction{
    [self showPayTypeTableView];
    NSLog(@"数据个数%zi",_payTypeArr.count);
    NSLog(@"11");
    if (_payTypeArr.count == 0) {
        NSLog(@"12");
        [self fuKuanReqyest];
        [self.payTypeTableView reloadData];
    }
    [_Hud removeFromSuperview];
    
}
-(void)showPayTypeTableView{
    _payTypeButton.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.payTypeTableView == nil) {
        self.payTypeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.payTypeTableView.backgroundColor = [UIColor whiteColor];
    }
    self.payTypeTableView.dataSource = self;
    self.payTypeTableView.delegate = self;
    self.payTypeTableView.tag = 40;
    [bgView addSubview:self.payTypeTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.payTypeTableView reloadData];
}
#pragma mark - 付款方式请求方法
- (void)fuKuanReqyest{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSDictionary *params = @{@"action":@"getSelectType",@"type":@"seal",@"table":@"base"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        
        self.fuKuanFangShiArr = [NSMutableArray array];
        _fukuanfangshiId = [NSMutableArray array];
        for (NSDictionary *dic in array ) {
            NSString * str = dic[@"name"];
            NSString *fukuanid = dic[@"id"];
            [_payTypeArr addObject:str];
            [_fukuanfangshiId addObject:fukuanid];
        }
        if (_fuKuanFangShiArr.count != 0) {
            [_payTypeButton setTitle:_payTypeArr[0] forState:UIControlStateNormal];
            _payTypeId = _fukuanfangshiId[0];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
    
    
    
}
-(void)surpportAction{
    [self showSupportTableView];
    NSLog(@"数据个数%zi",_surpportArr.count);
    NSLog(@"11");
    if (_surpportArr.count == 0) {
        NSLog(@"12");
        [self supportDataRequest];
        [self.supportTable reloadData];
    }
    [_Hud removeFromSuperview];
}
- (void)showSupportTableView{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    _supportField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40,KscreenWidth - 100 , 40)];
    _supportField.backgroundColor = [UIColor whiteColor];
    _supportField.delegate = self;
    _supportField.tag =  101;
    _supportField.placeholder = @"名称关键字";
    _supportField.borderStyle = UITextBorderStyleRoundedRect;
    _supportField.font = [UIFont systemFontOfSize:13];
    [self.m_keHuPopView addSubview:_supportField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_supportField.right, 40, 60, 40);
    
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(departDataRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.supportTable == nil) {
        self.supportTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.supportTable.backgroundColor = [UIColor whiteColor];
    }
    self.supportTable.dataSource = self;
    self.supportTable.delegate = self;
    self.supportTable.tag = 1050;
    self.supportTable.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.supportTable];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.supportTable reloadData];
    
    _Hud = [MBProgressHUD showHUDAddedTo:self.supportTable animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];
}
-(void)supportDataRequest{
    ///department?action=getTree&table=xtbm
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/purchase"];
    NSDictionary *params = @{@"action":@"getSupplier",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20"};
    NSLog(@"%@",params);
    [_surpportArr removeAllObjects];
    [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"产品信息返回:%@",dic);
        [_surpportArr removeAllObjects];
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_surpportArr addObject:model];
        }
        [self.supportTable reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        
    }];
}
-(void)startAction{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    _timeView.backgroundColor = [UIColor whiteColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight-270, KscreenWidth, 270)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [_timeView addSubview:bgView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, 240)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    [_startBtn setTitle:_currentDateStr forState:UIControlStateNormal];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
//监听datePicker值发生变化
- (void)dateChange1:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_startBtn setTitle:dateString forState:UIControlStateNormal];
}
- (void)closetime
{
    [_timeView removeFromSuperview];
}
@end
