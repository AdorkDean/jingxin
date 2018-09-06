//
//  AddAnotherPlanVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/11.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "AddAnotherPlanVC.h"
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
#import "PlanProDetailModel.h"

#import "PlanProDetailCell.h"
#define lineColor  COLOR(240, 240, 240, 1);
@interface AddAnotherPlanVC ()<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

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
    UIButton  *_orderNoBtn;
    UITextField *_yuEField;
    UIButton *_payTypeButton;
    UIButton *_cgpeopleBtn;
    UIButton *_cgplaceBtn;
    UITextField *_noteTf;
    UILabel *_isspeed1;
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
    NSMutableArray *_orderNoArray;
    NSMutableArray *_orderIDArray;
    NSMutableArray *_cpGuigeArray;
    NSMutableArray *_cpDanweiArray;
    NSMutableArray *_xiaoshouTypeArray;
    NSMutableArray *_singlePriceArray;
    NSMutableArray *_countArray;
    NSMutableArray *_isUrgentArray;
    NSMutableArray *_noteArray;
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
@property(nonatomic,retain)UITableView *orderNoTable;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *departTable;
@property(nonatomic,retain)UITableView *payTypeTableView;
@property(nonatomic,retain)UITableView *cgAreaTable;
@property(nonatomic,retain)UITableView *supportTable;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation AddAnotherPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单申请计划下达";
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
    _orderNoArray = [[NSMutableArray alloc] init];
    _orderIDArray = [[NSMutableArray alloc] init];
    _cgAreaArr = [[NSMutableArray alloc] init];
    _payTypeArr = [[NSMutableArray alloc] init];
    _surpportArr = [[NSMutableArray alloc] init];
    _isUrgentArray = [[NSMutableArray alloc] init];
    _cpNameBtnArray = [[NSMutableArray alloc] init];
    _cpCodeArray = [[NSMutableArray alloc] init];
    _cpGuigeArray = [[NSMutableArray alloc] init];
    _cpDanweiArray = [[NSMutableArray alloc] init];
    _xiaoshouTypeArray = [[NSMutableArray alloc] init];
    _singlePriceArray = [[NSMutableArray alloc] init];
    _countArray = [[NSMutableArray alloc] init];
    _cpCodeArray = [[NSMutableArray alloc] init];
    _JineArray = [[NSMutableArray alloc] init];
    _noteArray = [[NSMutableArray alloc] init];
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
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    
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
    [self creatUI];
    //默认一个产品信息页面
//    [self addProducts];
    //    [self initCustDetailView];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        [self nameRequest];
        //        [self wuLiuRequest];
        //        [self fuKuanReqyest];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // [self PageViewDidLoad];
            
            
            [_HUD removeFromSuperview];
        });
    });

    
}
- (void)initScrollView{
    
    self.dingDanAddScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
//    self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, 0);
    self.dingDanAddScrollView.bounces = NO;
    self.dingDanAddScrollView.backgroundColor = [UIColor whiteColor];
    self.dingDanAddScrollView.delegate = self;
    [self.view addSubview:self.dingDanAddScrollView];
    
    
}
#pragma mark   客户信息页面
- (void)initCustView{
    //订单单号
    UILabel *label0 =  [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 45)];
    label0.font = [UIFont systemFontOfSize:14];
    label0.text = @"订单单号";
    [self.dingDanAddScrollView addSubview:label0];
    _orderNoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _orderNoBtn.frame = CGRectMake(85, 0, KscreenWidth - 90, 45);
    [_orderNoBtn setTintColor:[UIColor blackColor]];
    _orderNoBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_orderNoBtn addTarget:self action:@selector(orderNoAction) forControlEvents:UIControlEventTouchUpInside];
    [_orderNoBtn setTitle:@"请选择订单号" forState:UIControlStateNormal];
    _orderNoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_orderNoBtn];
    
    UIView *line0  = [[UIView alloc] initWithFrame:CGRectMake(0, _orderNoBtn.bottom, KscreenWidth, 1)];
    line0.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line0];
    //计划指定人
    UILabel *label1 =  [[UILabel alloc] initWithFrame:CGRectMake(5, line0.bottom+1, 80, 45)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"计划指定人";
    [self.dingDanAddScrollView addSubview:label1];
    _nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nameButton.frame = CGRectMake(85, line0.bottom+1, KscreenWidth - 90, 45);
    [_nameButton setTintColor:[UIColor blackColor]];
    _nameButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_nameButton addTarget:self action:@selector(cgpeopleAction) forControlEvents:UIControlEventTouchUpInside];
    [_nameButton setTitle:@"请选择指定人" forState:UIControlStateNormal];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefault objectForKey:@"account"];
    NSString* idstr = [userDefault objectForKey:@"id"];
    [_nameButton setTitle:account forState:UIControlStateNormal];
    _custid = idstr;
    _nameButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_nameButton];
    
    UIView *line1  = [[UIView alloc] initWithFrame:CGRectMake(0, _nameButton.bottom, KscreenWidth, 1)];
    line1.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line1];
    //时间
    UILabel  *label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, line1.bottom+1, 80, 45)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"计划时间";
    [self.dingDanAddScrollView addSubview:label3];
    _cgpeopleBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _cgpeopleBtn.frame = CGRectMake(85, line1.bottom+1, KscreenWidth - 90, 45);
    [_cgpeopleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cgpeopleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cgpeopleBtn setTitle:_currentDateStr forState:UIControlStateNormal];
    [_cgpeopleBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    _cgpeopleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_cgpeopleBtn];
    UIView *line2  = [[UIView alloc] initWithFrame:CGRectMake(0, _cgpeopleBtn.bottom, KscreenWidth, 1)];
    line2.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line2];
    //菜狗区域
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(5, line2.bottom+1, 80, 45)];
    label4.font = [UIFont systemFontOfSize:13];
    label4.text = @"备注";
    [self.dingDanAddScrollView addSubview:label4];
    _noteTf = [[UITextField alloc]initWithFrame:CGRectMake(85, line2.bottom+1, KscreenWidth - 90, 45)];
    _noteTf.placeholder = @"备注";
    _noteTf.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_noteTf];
    UIView* line3 = [[UIView alloc]initWithFrame:CGRectMake(0, _noteTf.bottom - 1, KscreenWidth, 1)];
    line3.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line3];
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
    [_cgpeopleBtn setTitle:_currentDateStr forState:UIControlStateNormal];
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
    [_cgpeopleBtn setTitle:dateString forState:UIControlStateNormal];
}
- (void)closetime
{
    [_timeView removeFromSuperview];
}
-(void)orderNoAction{
    [self showOrderNoTableView];
    NSLog(@"数据个数%zi",_orderNoArray.count);
    NSLog(@"11");
    if (_orderNoArray.count == 0) {
        NSLog(@"12");
        [self OrderNoDataRequest];
        [self.orderNoTable reloadData];
    }
    [_Hud removeFromSuperview];
}
- (void)showOrderNoTableView{
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
    [btn addTarget:self action:@selector(OrderNoDataRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.orderNoTable == nil) {
        self.orderNoTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.orderNoTable.backgroundColor = [UIColor whiteColor];
    }
    self.orderNoTable.dataSource = self;
    self.orderNoTable.delegate = self;
    self.orderNoTable.tag = 20;
    self.orderNoTable.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.orderNoTable];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.orderNoTable reloadData];
    
    _Hud = [MBProgressHUD showHUDAddedTo:self.orderNoTable animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];
}
-(void)OrderNoDataRequest{
    ///department?action=getTree&table=xtbm
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/production"];
    NSDictionary *params = @{@"action":@"getOrderList",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",_custField.text]};
    NSLog(@"%@",params);
    [_orderNoArray removeAllObjects];
    [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"产品信息返回:%@",dic);
            [_orderNoArray removeAllObjects];
            for (NSDictionary *dic in array) {
                [_orderNoArray addObject:dic[@"name"]];
                [_orderIDArray addObject:dic[@"id"]];
            }
            [self.orderNoTable reloadData];
            
        }

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
    [btn addTarget:self action:@selector(cgPeopleDataRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];
    
    if (self.cgpeopleTable == nil) {
        self.cgpeopleTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.cgpeopleTable.backgroundColor = [UIColor whiteColor];
    }
    self.cgpeopleTable.dataSource = self;
    self.cgpeopleTable.delegate = self;
    self.cgpeopleTable.tag = 30;
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
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"产品信息返回:%@",dic);
            [_cgpeopleArr removeAllObjects];
            for (NSDictionary *dic in array) {
                [_cgpeopleArr addObject:dic[@"name"]];
                [_cgpeopleIdArr addObject:dic[@"id"]];
            }
            [self.cgpeopleTable reloadData];
        }
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
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing linecolor:(UIColor *)linecolor{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:linecolor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
- (void)creatUI{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, _noteTf.bottom+10, KscreenWidth, 1) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollEnabled = NO;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.allowsMultipleSelectionDuringEditing = YES;
    [self.dingDanAddScrollView addSubview:_tbView];
}
- (void)DataRequest2WithProid:(NSString *)proid
{
    //产品信息 (订单详情)
    /*
     rootpath+/production
     参数：@"mobile":@"true",@"action":@"getDetailPlanBeans","params":{"idEQ":"产品ID"}
     */
    [_dataArray removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/production"];
    NSDictionary* parmas = @{@"mobile":@"true",@"action":@"getOrderDetail",@"params":[NSString stringWithFormat:@"{\"orderno\":\"%@\"}",proid]};
    
    [DataPost requestAFWithUrl:urlStr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* returnStr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in  arr) {
                PlanProDetailModel *model = [[PlanProDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            
            _tbView.frame = CGRectMake(0, _noteTf.bottom, KscreenWidth, 280*_dataArray.count+10);
            self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, _noteTf.bottom+280*_dataArray.count+10);
            [_tbView reloadData];
            NSLog(@"产品信息%@",arr);
        }
        [_HUD hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if (tableView == _tbView){
        return _dataArray.count;
     }else if(tableView == self.cgpeopleTable){
         return _cgpeopleArr.count;
     }else if (tableView == self.orderNoTable){
         return _orderNoArray.count;
     }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (tableView == _tbView) {
//        return _dataArray.count;
//    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        return 280;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 10;
    }
    return 0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    PlanProDetailCell* procell = [tableView dequeueReusableCellWithIdentifier:@"PlanProDetailCell"];
    if (!procell) {
        procell = [[[NSBundle mainBundle]loadNibNamed:@"PlanProDetailCell" owner:self options:nil]firstObject];
    }
    [procell setDelBtnBlock:^{
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_tbView beginUpdates];
        [_tbView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tbView endUpdates];
        self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, _noteTf.bottom+280*_dataArray.count+10);
        [_tbView reloadData];
    }];
    if (tableView == _tbView) {
        if (_dataArray.count!=0) {
            procell.model = _dataArray[indexPath.row];
            procell.count = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
            NSLog(@"procell.count%@",procell.count);
        }
        procell.selectionStyle = UITableViewCellSelectionStyleNone;
        return procell;
    }else if (tableView == self.orderNoTable){
        
       cell.textLabel.text = _orderNoArray[indexPath.row];
        return cell;
        
    }else if (tableView == self.cgpeopleTable){
        cell.textLabel.text = _cgpeopleArr[indexPath.row];
        return cell;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.m_keHuPopView removeFromSuperview];
    if(tableView == self.orderNoTable) {
        _orderNoBtn.userInteractionEnabled = YES;
        [_orderNoBtn setTitle:[_orderNoArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        _orderid = [_orderNoArray objectAtIndex:indexPath.row];
        [_tbView reloadData];
        [self DataRequest2WithProid:[_orderNoArray objectAtIndex:indexPath.row]];
        
    }else if (tableView == self.cgpeopleTable){
        _nameButton.userInteractionEnabled = YES;
        [_nameButton setTitle:[_cgpeopleArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        _custid = [_cgpeopleIdArr objectAtIndex:indexPath.row];
    }
}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        if (tableView == _tbView) {
//
//            [_dataArray removeObjectAtIndex:indexPath.row];
//            [_tbView beginUpdates];
//            [_tbView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [_tbView endUpdates];
//        }
//    }
//}
#pragma mark - 提交按钮方法
- (void)addNext{
    
    [self shangChuan];
    _showOrder.userInteractionEnabled = NO; //禁止点击事件防止多次点击
    
    
}
#pragma mark  -- 订单添加事件
- (void)shangChuan
{
    if ([_orderNoBtn.titleLabel.text isEqualToString:@"请选择订单号"]) {
        [self showAlert:@"请选择订单号"];
        return;
    }
    if ([_nameButton.titleLabel.text isEqualToString:@"请选择指定人"]) {
        [self showAlert:@"请选择指定人"];
        return;
    }
    if ([_cgpeopleBtn.titleLabel.text isEqualToString:@"请选择时间"]) {
        [self showAlert:@"请选择时间"];
        return;
    }
    if (_dataArray.count) {
        for (int i = 0; i<_dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            PlanProDetailCell *cell = [_tbView cellForRowAtIndexPath:indexPath];
            if ([cell.plancount.text isEqualToString:@""]) {
                [self showAlert:@"请选择计划数量"];
                return;
            }
        }
    }else{
        [self showAlert:@"订单号下没有产品不能提交"];
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
-(void)sureComit{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/production"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];

    NSString * orderno = _orderNoBtn.titleLabel.text;
    NSString *name = _nameButton.titleLabel.text;
    name = [self convertNull:name];
    NSString *notetf = _noteTf.text;
    notetf = [self convertNull:notetf];
    NSString *startTime = _cgpeopleBtn.titleLabel.text;
    startTime = [self convertNull:startTime];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"SP=true&action=addPlan&table=scjh&data={\"table\":\"scjh\",\"orderno\":\"%@\",\"creatorid\":\"%@\",\"creator\":\"%@\",\"plantime\":\"%@\",\"note\":\"%@\"}",orderno,_custid,name,startTime,notetf];
    NSMutableString *chanpinStr = [NSMutableString stringWithFormat:@"\"ddmxList\":[]"];
    
    for (int i = 0; i < _dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PlanProDetailCell *cell = [_tbView cellForRowAtIndexPath:indexPath];
        PlanProDetailModel *model = _dataArray[i];
        NSString * proid = model.proid;
//        proid = [self replaceChar:proid];
        
        NSString *proname = cell.proname.titleLabel.text;
//        proname = [self replaceChar:proname];
        
        NSString * mainunitid = model.prounitid;
//        mainunitid = [self replaceChar:mainunitid];
        
        NSString *chanpinguige = cell.prospe.text;
//        chanpinguige = [self replaceChar:chanpinguige];
        
        NSString *plancout = cell.plancount.text;
//        plancout = [self replaceChar:plancout];
        
        NSString *mainunitname = cell.prodanwei.text;
//        mainunitname = [self replaceChar:mainunitname];
        
        NSString *note = cell.note.text;
//        note = [self replaceChar:note];
        
        NSString *iss = cell.isUrgent.text;
//        iss = [self replaceChar:iss];
        if ([iss isEqualToString:@"是"]) {
            iss = @"1";
        }else{
            iss = @"0";
        }
        [chanpinStr insertString:[NSString stringWithFormat:@"{\"table\":\"scjhmx\",\"proid\":\"%@\",\"proname\":\"%@\",\"specification\":\"%@\",\"mainunitid\":\"%@\",\"mainunitname\":\"%@\",\"plancount\":\"%@\",\"pronote\":\"%@\",\"isurgent\":\"%@\"},",proid,proname,chanpinguige,mainunitid,mainunitname,plancout,note,iss] atIndex:chanpinStr.length - 1];
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
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1010){
        
        if (buttonIndex == 1) {
            
            [self sureComit];
            
            
        }
        
    }
    
}
@end
