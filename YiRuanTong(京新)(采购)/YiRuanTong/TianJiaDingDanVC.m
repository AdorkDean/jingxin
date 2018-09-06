//
//  TianJiaDingDanVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "TianJiaDingDanVC.h"
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


@interface TianJiaDingDanVC ()<UITextFieldDelegate,UIAlertViewDelegate>

{
    
    MBProgressHUD *_hud;
    MBProgressHUD *_HUD;
    MBProgressHUD *_Hud;
    //客户信息添加字段
    NSString *singleprice;
    NSString *count;
    NSArray *_YNArray;
    //
    NSInteger _page;
    NSInteger _page1;
    NSInteger _flag;
    //客户名称、产品名称数字
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
    
    //////////////////////////////新字段
    //客户信息
    UIButton  *_nameButton;
    UITextField *_yuEField;
    UIButton *_payTypeButton;
    NSString * _custname;
    
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
    
    
    
    NSString *_totalZheHou;
    NSString *_totalJine;
    NSString *_totalaccount;
    NSString *_saletypeid;  //销售类型ID
    NSString *_jine1;
    NSString *_proid;
    NSString *_unitid;
    NSString *_unitPrice;
    NSString *_payTypeId;
    NSString *_price;    //价格
    NSInteger _nullFlag;
    NSInteger _chanpinokFlag;
    
    UITextField *_proField;    //输入产品名称
    UITextField *_custField;   //客户名称
    NSString *_currentDateStr;
    NSString *_saler;
    NSString *_salerId;
    
    BOOL isHaveDian;
    //
    UIView *_detailView;
    UIAlertView *_showOrder;    //订单添加提示
    UIButton* _hide_keHuPopViewBut;
}

@property (strong,nonatomic) NSMutableArray *fuKuanFangShiArr;
@property (strong,nonatomic) NSMutableArray *faPiaoLieXingArr;
@property (strong,nonatomic) NSMutableArray *wuLiuMingChenArr;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UITableView *payTypeTableView;
@property(nonatomic,retain)UITableView *wuLiuTableView;
@property(nonatomic,retain)UITableView *daiShouTableView;

@end

@implementation TianJiaDingDanVC
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"下订单";
    _dataArray = [[NSMutableArray alloc] init];
    _dataArray1 = [[NSMutableArray alloc] init];
    _page1 = 1;
    _page = 1;
    _flag = 0;
    _chanpinokFlag = 0;
    _YNArray = @[@"是",@"否"];
    
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
    _HUD.labelText = @"网络不给力，正在加载中...";
    _HUD.dimBackground = YES;
    [_HUD show:YES];

   //客户页面
    [self initCustView];
    //默认一个产品信息页面
    [self addProducts];
    [self initCustDetailView];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self nameRequest];
        [self wuLiuRequest];
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

    UILabel *label1 =  [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 45)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"客户名称*";
    [self.dingDanAddScrollView addSubview:label1];
    _nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nameButton.frame = CGRectMake(85, 0, KscreenWidth - 90, 45);
    [_nameButton setTintColor:[UIColor blackColor]];
    _nameButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_nameButton addTarget:self action:@selector(nameAction) forControlEvents:UIControlEventTouchUpInside];
    [_nameButton setTitle:@"请选择客户" forState:UIControlStateNormal];
    _nameButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_nameButton];

    UIView *line1  = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    line1.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 46, 80, 45)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"客户余额";
    [self.dingDanAddScrollView addSubview:label2];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 91, KscreenWidth, 1)];
    line2.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanAddScrollView addSubview:line2];
    _yuEField = [[UITextField alloc] initWithFrame:CGRectMake(85, 46, KscreenWidth - 90, 45)];
    _yuEField.delegate = self;
    _yuEField.font = [UIFont systemFontOfSize:14];
    _yuEField.userInteractionEnabled = NO;
    [self.dingDanAddScrollView addSubview:_yuEField];
    
    
    
    UILabel  *label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 92, 80, 45)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"付款方式";
    [self.dingDanAddScrollView addSubview:label3];
    _payTypeButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _payTypeButton.frame = CGRectMake(85, 92, KscreenWidth - 90, 45);
    [_payTypeButton setTintColor:[UIColor grayColor]];
    _payTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_payTypeButton setTitle:@"请选择付款方式" forState:UIControlStateNormal];
    [_payTypeButton addTarget:self action:@selector(payTypeAction) forControlEvents:UIControlEventTouchUpInside];
    _payTypeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanAddScrollView addSubview:_payTypeButton];
    
    
//    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(5, 138, 80, 45)];
//    label4.font = [UIFont systemFontOfSize:13];
//    label4.text = @"物流名称";
//    [self.dingDanAddScrollView addSubview:label4];
//    UIButton *wuLiuButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
//    wuLiuButton.frame = CGRectMake(85, 138, KscreenWidth - 90, 45);
//    [wuLiuButton setTitle:@"请选择物流名称" forState:UIControlStateNormal];
//    [self.dingDanAddScrollView addSubview:wuLiuButton];
//    
//    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 137, KscreenWidth, 10)];
//    view0.backgroundColor = COLOR(225, 225, 225, 1);
//    [self.dingDanAddScrollView addSubview:view0];


}


#pragma mark ----------------------------- 添加产品-------------------------------  -
- (void)addProducts
{
//    if (_nullFlag == 1) {
        NSString *proname;
        for (int i = 0; i < _flag; i++) {
            
            UIButton *btn = [_cpNameBtnArray objectAtIndex:i];
            proname = btn.titleLabel.text;
            proname = [self replaceChar:proname];
        }
        if ([proname isEqualToString:@"请选择产品"]) {
            [self showAlert:@"请选择产品后再继续添加"];
            return;
        }
//    }
    
    [self saleTypeRequest];
        _chanpinokFlag = 1;
        
        _flag = _flag + 1;
        self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, 137 + _flag * 455 + 330);
    
        UIView *chanpinView = [[UIView alloc] initWithFrame:CGRectMake(0, 137 + 455 * (_flag - 1), KscreenWidth, 480)];
        chanpinView.backgroundColor = [UIColor whiteColor];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
                if (_flag>=2) {
                    [self.dingDanAddScrollView setContentOffset:CGPointMake(0,137 + (_flag-1) * 455) animated:YES];
                }
            });
        
        });
    
        //产品UI搭建
    
#pragma mark - 产品UI搭建
        UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 39)];
        info.backgroundColor = COLOR(220, 220, 220, 1);
        info.text = [NSString stringWithFormat:@"产品信息（%zi）",_flag];
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
        chanPinName.text = @"产品名称*";
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
        [CPNameBtn setTitle:@"请选择产品" forState:UIControlStateNormal];
        [CPNameBtn addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
        [chanpinView addSubview:CPNameBtn];
        [_cpNameBtnArray addObject:CPNameBtn];
    UILabel *CPID = [[UILabel alloc] initWithFrame:CGRectMake(86, 40, KscreenWidth - 90, 45)];
    [_CPIdArray addObject:CPID];
    
    
    UILabel *cPNO = [[UILabel alloc] initWithFrame:CGRectMake(5, chanPinName.bottom + 1 , 80, 45)];
    cPNO.text = @"产品编码";
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
        chanPinGuiGe.text = @"产品规格";
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
        chanPinDanWei.text = @"产品单位";
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
        [chanPinDanWeiButton1 addTarget:self action:@selector(danweiAction) forControlEvents:UIControlEventTouchUpInside];
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
    
        UILabel *danJia1 =[[UILabel alloc] initWithFrame:CGRectMake(86, chanPinDanWei.bottom + 1, 60, 45)];
        danJia1.font =[UIFont systemFontOfSize:14];
        danJia1.textAlignment = NSTextAlignmentLeft;
        danJia1.textColor = [UIColor grayColor];
        [chanpinView addSubview:danJia1];
        [_singlePriceArray addObject:danJia1];
    
        //折后单价
    UILabel *zhehoudanJia =[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2, chanPinDanWei.bottom + 1, 80, 45)];
    zhehoudanJia.text = @"折后单价";
    zhehoudanJia.font = [UIFont systemFontOfSize:14];
//    UIView *linedanjia = [[UIView alloc] initWithFrame:CGRectMake(0, zhehoudanJia.bottom, KscreenWidth, 1)];
//    linedanjia.backgroundColor = lineColor;
//    [chanpinView addSubview:linedanjia];
    [chanpinView addSubview:zhehoudanJia];
    
    UILabel *zhehoudanJia1 =[[UILabel alloc] initWithFrame:CGRectMake(zhehoudanJia.right+5, chanPinDanWei.bottom + 1, 60, 45)];
    zhehoudanJia1.font =[UIFont systemFontOfSize:14];
    zhehoudanJia1.textAlignment = NSTextAlignmentLeft;
    zhehoudanJia1.textColor = [UIColor grayColor];
    [chanpinView addSubview:zhehoudanJia1];
    [_zhehouSinglePriceArray addObject:zhehoudanJia1];

        //销售类型
        UILabel *xiaoShouLeiXing = [[UILabel alloc] initWithFrame:CGRectMake(5, zhehoudanJia.bottom + 1, 80, 45)];
        xiaoShouLeiXing.text = @"销售类型";
        xiaoShouLeiXing.font = [UIFont systemFontOfSize:14];
        UIView *line5 =[[UIView alloc] initWithFrame:CGRectMake(0, xiaoShouLeiXing.bottom, KscreenWidth, 1)];
        line5.backgroundColor = lineColor;
        [chanpinView addSubview:line5];
        [chanpinView addSubview:xiaoShouLeiXing];
        UIButton *xiaoShouLeiXingButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        xiaoShouLeiXingButton1.frame = CGRectMake(86, zhehoudanJia.bottom + 1, KscreenWidth - 90, 45);
        xiaoShouLeiXingButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [xiaoShouLeiXingButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [xiaoShouLeiXingButton1 addTarget:self action:@selector(saleTypeAction) forControlEvents:UIControlEventTouchUpInside];
        [xiaoShouLeiXingButton1 setTitle:@"请选择销售类型" forState:UIControlStateNormal];
        xiaoShouLeiXingButton1.titleLabel.font = [UIFont systemFontOfSize:14];
        xiaoShouLeiXing.tag = _flag * 100;
        [chanpinView addSubview:xiaoShouLeiXingButton1];
    UILabel *SaleTypeId = [[UILabel alloc] initWithFrame:CGRectMake(86, 40, KscreenWidth - 90, 45)];
    [_SaleTypeIdArray addObject:SaleTypeId];
                        //默认销售类型
    NSLog(@"销售类型%@",_leixingArr);
        if (_leixingArr.count != 0) {
                DWandLXModel *model = _leixingArr[0];
                [xiaoShouLeiXingButton1 setTitle:model.name forState:UIControlStateNormal];
            SaleTypeId.text = [NSString stringWithFormat:@"%@",model.Id];
        }
        [_xiaoshouTypeArray addObject:xiaoShouLeiXingButton1];
    UILabel *returnRate = [[UILabel alloc] initWithFrame:CGRectMake(5, xiaoShouLeiXing.bottom + 1, 80, 45)];
    returnRate.text = @"返利率";
    returnRate.font = [UIFont systemFontOfSize:14];
    UIView *lineFan =[[UIView alloc] initWithFrame:CGRectMake(0, returnRate.bottom, KscreenWidth, 1)];
    lineFan.backgroundColor = lineColor;
    [chanpinView addSubview:lineFan];
    [chanpinView addSubview:returnRate];
    UITextField *returnRate1 = [[UITextField alloc] initWithFrame:CGRectMake(86, xiaoShouLeiXing.bottom + 1, KscreenWidth - 90, 45)];
    returnRate1.delegate = self;
    returnRate1.textColor = [UIColor lightGrayColor];
    returnRate1.tag = 102;
    returnRate1.font = [UIFont systemFontOfSize:14];
    [chanpinView addSubview:returnRate1];
    [_fanliLvArray addObject:returnRate1];
    
        //数量
        UILabel *shuLiang = [[UILabel alloc] initWithFrame:CGRectMake(5, returnRate.bottom + 1, 80, 45)];
        shuLiang.text = @"数量";
        shuLiang.font = [UIFont systemFontOfSize:14];
        UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(0, shuLiang.bottom, KscreenWidth, 1)];
        line7.backgroundColor = lineColor;
        [chanpinView addSubview:line7];
        [chanpinView addSubview:shuLiang];
        UITextField *shuLiang1 = [[UITextField alloc] initWithFrame:CGRectMake(86, returnRate.bottom + 1, KscreenWidth - 90, 45)];
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
    
    //折后金额
    
    UILabel *zhehoujinE = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2, shuLiang.bottom + 1, 80, 45)];
    zhehoujinE.text = @"折后金额";
    zhehoujinE.font =[UIFont systemFontOfSize:14];
//    UIView *line11 = [[UIView alloc] initWithFrame:CGRectMake(0, zhehoujinE.bottom, KscreenWidth, 1)];
//    line11.backgroundColor = lineColor;
//    [chanpinView addSubview:line11];
    [chanpinView addSubview:zhehoujinE];
    UILabel *zhehoujinE1 = [[UILabel alloc] initWithFrame:CGRectMake(zhehoujinE.right+5, shuLiang.bottom + 1, 60, 45)];
    zhehoujinE1.font = [UIFont systemFontOfSize:14];
    zhehoujinE1.textAlignment = NSTextAlignmentLeft;
    zhehoujinE1.textColor = [ UIColor grayColor];
    [chanpinView addSubview:zhehoujinE1];
    [_zhehouJineArray addObject:zhehoujinE1];

    
//        //可用库存
//        UILabel *keYongKuCun = [[UILabel alloc] initWithFrame:CGRectMake(5, 362, 80, 45)];
//        keYongKuCun.text = @"可用库存";
//        keYongKuCun.font = [UIFont systemFontOfSize:14];
//        UIView *line12 = [[UIView alloc] initWithFrame:CGRectMake(0,407, KscreenWidth, 1)];
//        line12.backgroundColor = lineColor;
//        [chanpinView addSubview:line12];
//        [chanpinView addSubview:keYongKuCun];
        UILabel *keYongKuCun1 = [[UILabel alloc] initWithFrame:CGRectMake(86, 362, KscreenWidth - 90, 45)];
        keYongKuCun1.font = [UIFont systemFontOfSize:14];
        keYongKuCun1.textAlignment = NSTextAlignmentLeft;
        keYongKuCun1.textColor = [UIColor grayColor];
        [_keyongKuCunArray addObject:keYongKuCun1];
        [self.dingDanAddScrollView addSubview:chanpinView];
    
    [_chanpinViewArray addObject:chanpinView];
    
    
    
        //添加产品的按钮设置
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 455, KscreenWidth, 45)];
        buttonView.backgroundColor = COLOR(220, 220, 220, 1);
        UIButton *tianJiaButton = [[UIButton alloc] initWithFrame:CGRectMake(KscreenWidth - 90, 0, 80, 45)];
        [tianJiaButton setTitle:@"添加产品" forState:UIControlStateNormal];
        [tianJiaButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
        [tianJiaButton addTarget:self action:@selector(addProducts) forControlEvents:UIControlEventTouchUpInside];
        tianJiaButton.backgroundColor = [UIColor clearColor];
        tianJiaButton.titleLabel.font = [ UIFont systemFontOfSize:16];
        [buttonView  addSubview:tianJiaButton];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(KscreenWidth - 180, 0, 80, 45);
    [closeBtn setTitle:@"删除产品" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.titleLabel.font = [ UIFont systemFontOfSize:16];
    [closeBtn addTarget:self action:@selector(closeChanpinView:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:closeBtn];
//    [_colseArray addObject:closeBtn];
    
        [chanpinView addSubview:buttonView];
    //[self initCustDetailView];
    _detailView.frame = CGRectMake(0, 182 + 455 + (_flag - 1)  * 455, KscreenWidth, 310);
}


#pragma mark - 客户的联系人物流界面
- (void)initCustDetailView{
    
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 182 + 455 + (_flag - 1)  * 455, KscreenWidth, 310)];
    [self.dingDanAddScrollView addSubview:_detailView];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 45)];
    label1.text = @"物流名称";
    label1.font =[UIFont systemFontOfSize:14];
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [_detailView addSubview:view1];
    [_detailView addSubview:label1];
    _wuLiuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _wuLiuButton.frame = CGRectMake(86, 0, KscreenWidth - 90, 45);
    [_wuLiuButton setTintColor:[UIColor grayColor]];
    _wuLiuButton.tag = 10;
    _wuLiuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_wuLiuButton addTarget:self action:@selector(wuLiuAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_detailView addSubview:_wuLiuButton];
    if (self.m_wuLiuArr.count != 0) {
         NSString *wuliu = self.m_wuLiuArr[0][@"logname"];
        [_wuLiuButton setTitle:wuliu forState:UIControlStateNormal];
    }
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 46, 80, 45)];
    label2.text = @"收货人";
    label2.font =[UIFont systemFontOfSize:14];
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 91, KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    _receiver =[[UITextField alloc]initWithFrame:CGRectMake(86, 46, KscreenWidth - 90, 45)];
    _receiver.font =[UIFont systemFontOfSize:14];
    _receiver.textAlignment = NSTextAlignmentLeft;
    _receiver.delegate = self;
    [_detailView addSubview:label2];
    [_detailView addSubview:view2];
    [_detailView addSubview:_receiver];
    
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 92, 80, 45)];
    label3.text = @"收货人电话";
    label3.font = [UIFont systemFontOfSize:14];
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 137, KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    _receiveTel = [[UITextField alloc] initWithFrame:CGRectMake(86, 92, KscreenWidth - 90, 45)];
    _receiveTel.delegate  = self;
    _receiveTel.font = [UIFont systemFontOfSize:14];
    _receiveTel.textAlignment = NSTextAlignmentLeft;
    [_detailView addSubview:label3];
    [_detailView addSubview:view3];
    [_detailView addSubview:_receiveTel];
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(5, 138, 80, 45)];
    label4.text = @"收货人地址";
    label4.font = [UIFont systemFontOfSize:14];
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 183, KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    _receiveAdd =[[UITextField alloc]initWithFrame:CGRectMake(86, 138, KscreenWidth - 90, 45)];
    _receiveAdd.font =[UIFont systemFontOfSize:14];
    _receiveAdd.textAlignment = NSTextAlignmentLeft;
    _receiveAdd.delegate = self;
    [_detailView addSubview:label4];
    [_detailView addSubview:view4];
    [_detailView addSubview:_receiveAdd];
    
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(5, 184, 80, 45)];
    label5.text = @"物流代收";
    label5.font = [UIFont systemFontOfSize:14];
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, 229, KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    _wuLiuDaiShou = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _wuLiuDaiShou.frame = CGRectMake(86, 184, KscreenWidth - 90, 45);
    [_wuLiuDaiShou setTintColor:[UIColor grayColor]];
    _wuLiuDaiShou.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_wuLiuDaiShou addTarget:self action:@selector(YORN) forControlEvents:UIControlEventTouchUpInside];
    [_wuLiuDaiShou setTitle:@"否" forState:UIControlStateNormal];
    [_detailView addSubview:label5];
    [_detailView addSubview:view5];
    [_detailView addSubview:_wuLiuDaiShou];
    
   
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(5, 230, 80, 45)];
    label6.text = @"代收金额";
    label6.font =[UIFont systemFontOfSize:14];
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 275, KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    _daiShouJinE = [[UITextField alloc] initWithFrame:CGRectMake(86, 230, KscreenWidth - 90, 45)];
    _daiShouJinE.delegate = self;
    _daiShouJinE.font = [UIFont systemFontOfSize:14];
    _daiShouJinE.textAlignment = NSTextAlignmentLeft;
    [_detailView addSubview:label6];
    [_detailView addSubview:view6];
    [_detailView addSubview:_daiShouJinE];
    NSString *daishou = _wuLiuDaiShou.titleLabel.text;
    if ([daishou isEqualToString:@"否"]) {
        _daiShouJinE.userInteractionEnabled = NO;
    }else{
        _daiShouJinE.userInteractionEnabled = YES;
    }

    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(5, 276, 80, 45)];
    label7.text = @"备注";
    label7.font =[UIFont systemFontOfSize:14];
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, 321, KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [_detailView addSubview:label7];
    [_detailView addSubview:view7];
    _note = [[UITextField alloc] initWithFrame:CGRectMake(86, 276, KscreenWidth - 90, 45)];
    _note.font = [UIFont systemFontOfSize:14];
    _note.textAlignment = NSTextAlignmentLeft;
    _note.delegate = self;
    [_detailView addSubview:_note];
    _receiver.text = self.custInfo[@"receiver"];
    _receiveTel.text = self.custInfo[@"receivertel"];
    _receiveAdd.text = self.custInfo[@"receiveaddr"];

}
#pragma mark ---------------客户信息加载方法-----------------
#pragma mark - 客户信息
//名字按钮点击方法
- (void)nameAction
{
 
   [self showCustTableView];
    NSLog(@"数据个数%zi",_dataArray.count);
    NSLog(@"11");
        if (_dataArray.count == 0) {
            NSLog(@"12");
            [self nameRequest];
            [self.custTableView reloadData];
        }
    
        [_Hud removeFromSuperview];

    
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
////    NSString *realStr = textField.text;
////    double m = [realStr doubleValue];
////    if (0.00  <= m  < 1.00) {
////        return YES;
////    }else{
////        
////        [self showAlert:@"返利率输入错误！"];
////        return NO;
////    }
//    
//    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
//        isHaveDian = NO;
//    }
//    if ([string length]>0)
//    {
//        unichar single = [string characterAtIndex:0];//当前输入的字符
//        if ((single >='0' && single<='9') || single=='.')//数据格式正确
//        {
//            //首字母不能为0和小数点
//            if([textField.text length]==0){
//                if(single == '.'){
//                    [self showAlert:@"第一个数字不能为小数点"];
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//                if (single != '0') {
//                    [self showAlert:@"第一个数字不能大于1"];
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//            }
//            if (single=='.')
//            {
//                if(!isHaveDian)//text中还没有小数点
//                {
//                    isHaveDian=YES;
//                    return YES;
//                }else
//                {
//                    [self showAlert:@"您已经输入过小数点了"];
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//            }
//            else
//            {
//                if (isHaveDian)//存在小数点
//                {
//                    //判断小数点的位数
//                    NSRange ran=[textField.text rangeOfString:@"."];
//                    int tt = range.location - ran.location;
//                    if (tt <= 4){
//                        return YES;
//                    }else{
//                        
//                        return NO;
//                    }
//                }
//                else
//                {
//                    return YES;
//                }
//            }
//        }else{//输入的数据格式不正确
//            [self showAlert:@"您输入的格式不正确"];
//            [textField.text stringByReplacingCharactersInRange:range withString:@""];
//            return NO;
//        }
//    }
//    else
//    {
//        return YES;
//    }
//
//
//}

- (void)showCustTableView{
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
    [btn addTarget:self action:@selector(getName) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:btn];

    if (self.custTableView == nil) {
        self.custTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 80,KscreenWidth-40, KscreenHeight-174) style:UITableViewStylePlain];
        self.custTableView.backgroundColor = [UIColor whiteColor];
    }
    self.custTableView.dataSource = self;
    self.custTableView.delegate = self;
    self.custTableView.tag = 10;
    self.custTableView.rowHeight = 50;
    [self.m_keHuPopView addSubview:self.custTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.custTableView reloadData];
    
    _Hud = [MBProgressHUD showHUDAddedTo:self.custTableView animated:YES];
    //设置模式为进度框形的
    _Hud.mode = MBProgressHUDModeIndeterminate;
    _Hud.labelText = @"网络不给力，正在加载中...";
    _Hud.dimBackground = YES;
    [_Hud show:YES];

   
}
- (void)getName{
    
    NSString *custName = _custField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户数据数据%@",array);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            KHnameModel *model = [[KHnameModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.custTableView reloadData];
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


- (void)nameRequest
{
    //客户名称 的浏览接口
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getSelectName",@"table":@"khxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
                for (NSDictionary *dic in array) {
                        KHnameModel *model = [[KHnameModel alloc] init];
                        [model setValuesForKeysWithDictionary:dic];
                        [_dataArray addObject:model];
                    }
        
        [self.custTableView reloadData];
        NSLog(@"客户名称数据%@",array);
       
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

- (void)upRefresh
{
    _page++;
    
    [self nameRequest];
}
- (void)getCustInfo
{
    //数据地址拼接
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary *params = @{@"action":@"getCustInfo",@"params":[NSString stringWithFormat:@"{\"id\":\"%@\"}",_custid]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =  [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户详情%@",array);
        if (array.count != 0) {
            
            self.custInfo = array[0];
           
            _yuEField.text =  [NSString stringWithFormat:@"%@",_custInfo[@"creditline"]];
            _receiver.text =  _custInfo[@"receiver"];
            _receiveTel.text = _custInfo[@"receivertel"];
            _receiveAdd.text = _custInfo[@"receiveaddr"];
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

#pragma mark  物流信息
- (void)getWuliuInfo
{
    //客户添加——物流详情的接口
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getLogisInfo",@"table":@"wlxx",@"params":@{@"idEQ":self.wuLiuID}};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        self.wuLiuArr = array;
         NSLog(@"物流信息返回:%@",self.wuLiuArr);
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

#pragma mark -  业务员信息
- (void)getYewuyuanInfo
{
    //数据地址拼接

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipalByCust",@"params":[NSString stringWithFormat:@"{\"custidEQ\":\"%@\"}",_custid]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        self.yewuYuanArr = array;
        if (array.count != 0) {
            _saler = array[0][@"name"];
            _salerId = array[0][@"id"];
        }
        NSLog(@"客户业务员信息返回:%@",array);
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


- (void)YORN{
    
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor lightGrayColor];
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
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.daiShouTableView == nil) {
        self.daiShouTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.daiShouTableView.backgroundColor = [UIColor grayColor];
    }
    self.daiShouTableView.dataSource = self;
    self.daiShouTableView.delegate = self;
    self.daiShouTableView.tag = 80;
    [bgView addSubview:self.daiShouTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.daiShouTableView reloadData];

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

#pragma mark -   付款方式
-(void)payTypeAction
{
    
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
    self.payTypeTableView.tag = 20;
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
            [self.fuKuanFangShiArr addObject:str];
            [_fukuanfangshiId addObject:fukuanid];
        }
        if (_fuKuanFangShiArr.count != 0) {
            [_payTypeButton setTitle:_fuKuanFangShiArr[0] forState:UIControlStateNormal];
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
//发票类型  的点击方法
-(void)faPiaoAction
{
    /*
     发票类型
     http://182.92.96.58:8005/yrt/servlet/sysbase
     action	getSelectType
     type	invoicetype
     table	base
     */
    //客户添加 ——发票类型的接口
    
    
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
    self.tableView.tag = 30;
    [bgView addSubview:self.tableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.tableView reloadData];
}
//#pragma mark - 发票请求方法
//- (void)faPiaoRequeat{
//    
//    //_fapiaoleixingId = [[NSMutableArray alloc] init];
//    
//    NSString *strAdress = @"/sysbase";
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
//    
//    NSURL *url =[NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str =@"action=getSelectType&type=invoicetype&table=base";
//    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSArray * dict8 = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
//        self.faPiaoLieXingArr = [NSMutableArray arrayWithCapacity:10];
//        for (int i = 0; i < dict8.count; i++) {
//            NSString *str = dict8[i][@"name"];
//            NSString *fapiaoid = dict8[i][@"id"];
//            
//            [self.faPiaoLieXingArr addObject:str];
//           // [_fapiaoleixingId addObject:fapiaoid];
//        }
//        
//    }
//
//
//}
//物流名称  的点击方法
- (void)wuLiuAction
{
    /*
     物流名称
     http://182.92.96.58:8005/yrt/servlet/customer
     action	getSelectLog
     table	wlxx
     */
    //物流名称－－的接口  
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
    self.tableView.tag = 40;
    [bgView addSubview:self.tableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.tableView reloadData];
}
#pragma mark - 物流请求方法
- (void)wuLiuRequest{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectLog",@"table":@"wlxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        self.m_wuLiuArr = array;
        self.wuLiuMingChenArr = [NSMutableArray array];
        for (NSDictionary *dic in  array) {
            NSString * str = dic[@"logname"];
            [self.wuLiuMingChenArr addObject:str];
        }
        if (array.count != 0) {
            NSString *wuliu = array[0][@"logname"];
            [_wuLiuButton setTitle:wuliu forState:UIControlStateNormal];
            _wuLiuID = array[0][@"id"];
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

//关闭产品界面
- (void)closeChanpinView:(UIButton *)button
{
    if (_flag == 1) {
        [self showAlert:@"至少保留一条产品信息"];
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
            [_fanliLvArray removeObjectAtIndex:_flag - 1];
            [_keyongKuCunArray removeObjectAtIndex:_flag - 1];
            [_zhehouJineArray removeObjectAtIndex:_flag - 1];
            [_cpDanweiArray removeObjectAtIndex:_flag - 1];
            [_xiaoshouTypeArray removeObjectAtIndex:_flag - 1];
            [_zhehouSinglePriceArray removeObjectAtIndex:_flag - 1];
            [_JineArray removeObjectAtIndex:_flag - 1];
            [_cpNameBtnArray removeObjectAtIndex:_flag - 1];
            [_countArray removeObjectAtIndex:_flag - 1];
            
            UIView *view = [_chanpinViewArray objectAtIndex:_flag - 1];
            [view removeFromSuperview];
            [_chanpinViewArray removeObjectAtIndex:_flag - 1];
            self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, self.dingDanAddScrollView.contentSize.height - 455 + 45);
            //客户详情的位置
             _detailView.frame = CGRectMake(0, 182 +  (_flag - 1)  * 455, KscreenWidth, 310);
            _flag -= 1;
        }

        
    }else if (alertView.tag == 1010){
        
        if (buttonIndex == 1) {
            
            [self sureComit];
            _showOrder.userInteractionEnabled = NO; //禁止点击事件防止多次点击
        }
        
    }
    
}
-(void)sureComit{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    //计算总金额
    double totalmoney = 0;
    double totalzhehou = 0;
    NSInteger totalshumu = 0;
    
    for (int i = 0; i < _flag; i++) {
        
        UILabel *jinE = [_JineArray objectAtIndex:i];
        UITextField *shuliang = [_countArray objectAtIndex:i];
        UILabel *zhehoujine = [_zhehouJineArray objectAtIndex:i];
        
        totalmoney = totalmoney + [jinE.text doubleValue];
        totalzhehou = totalzhehou + [zhehoujine.text doubleValue];
        totalshumu = totalshumu + [shuliang.text integerValue];
    }
    _totalZheHou = [NSString stringWithFormat:@"%.2f",totalzhehou];
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
    _saler = [self convertNull:_saler];
    _salerId = [self convertNull:_salerId];
    NSString *creditline = _yuEField.text;
    creditline = [self convertNull:creditline];
    NSString *paidtype = _payTypeButton.titleLabel.text;
    paidtype = [self convertNull:paidtype];
    _payTypeId = [self convertNull:_payTypeId];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"SP=true&action=add&table=ddxx&data={\"addType\":\"2\",\"daidai\":\"%@\",\"daishoumoney\":\"%@\",\"bussinesstime\":\"\",\"custaddr\":\"\",\"creditline\":\"%@\",\"receiver\":\"%@\",\"ordercount\":\"%@\",\"telno\":\"\",\"salerid\":\"%@\",\"ordertime\":\"%@\",\"table\":\"ddxx\",\"invoicetype\":\"\",\"returnordermoney\":\"%@\",\"saler\":\"%@\",\"paidtypeid\":\"%@\",\"logisticsid\":\"%@\",\"custlinker\":\"\",\"ordernote\":\"%@\",\"receivertel\":\"%@\",\"logisticsname\":\"%@\",\"ordermoney\":\"%@\",\"receiveaddr\":\"%@\",\"paidtype\":\"%@\",\"custname\":\"%@\",\"custid\":\"%@\"}",daiShou,daiShouMoney,creditline,reciever,_totalaccount,_salerId,_currentDateStr,_totalZheHou,_saler,_payTypeId,wuliuId,_note.text,recieveTel,wuliu,_totalJine,recieveAdd,paidtype,name,_custid];
    
    NSMutableString *chanpinStr = [NSMutableString stringWithFormat:@"\"ddmxList\":[]"];
    //        NSMutableString *aichongStr = [NSMutableString stringWithFormat:@"\"proList\":[]"];
    
    for (int i = 0; i < _flag; i++) {
        
        UIButton *chanpindanwei = [_cpDanweiArray objectAtIndex:i];
        //UIButton *xiaoshouleiixng = [_xiaoshouTypeArray objectAtIndex:i];
        UITextField *shuliang = [_countArray objectAtIndex:i];
        
        if (chanpindanwei.titleLabel.text.length == 0 || shuliang.text.length == 0) {
            
            _nullFlag = 0;
        } else {
            
            _nullFlag = 1;
        }
        
    }
    
    if (_nullFlag == 1) {
        
        for (int i = 0; i < _flag; i++) {
            
            UIButton *btn = [_cpNameBtnArray objectAtIndex:i];
            NSString *proname = btn.titleLabel.text;
            proname = [self replaceChar:proname];
            UILabel *chanpinCode = [_cpCodeArray objectAtIndex:i];
            UILabel *chanpinguige = [_cpGuigeArray objectAtIndex:i];
            UILabel *danjia = [_singlePriceArray objectAtIndex:i];
            UITextField *fanlilu = [_fanliLvArray objectAtIndex:i];
            UILabel *keyongkucun = [_keyongKuCunArray objectAtIndex:i];
            UILabel *zhehoudanjia = [_zhehouSinglePriceArray objectAtIndex:i];
            UIButton *chanpindanwei = [_cpDanweiArray objectAtIndex:i];
            UILabel *zhehouJine = [_zhehouJineArray objectAtIndex:i];
            UITextField *shuliang = [_countArray objectAtIndex:i];
            UILabel *jinE = [_JineArray objectAtIndex:i];
            UILabel *CpId = [_CPIdArray objectAtIndex:i];
            UILabel *SaleTyepId = [_SaleTypeIdArray objectAtIndex:i];  //销售类型ID
            UILabel *UnitId = [_UnitIdArray objectAtIndex:i];
            UILabel *danWeiId = [_zhuFuDanWeiArray objectAtIndex:i]; //区分主副单位的ID
            //aichong
            //              [aichongStr insertString:[NSString stringWithFormat:@"{\"table\":\"pro_order_detail\",\"proid\":\"%@\",\"proname\":\"%@\",\"specification\":\"%@\",\"price\":\"%@\",\"count\":\"%@\",\"money\":\"%@\",\"type\":\"%@\",\"jxdanweiid\":\"%@\",\"jxdanweiname\":\"%@\",\"jxprice\":\"%@\",\"jxtype\":\"%@\",\"jxcount\":\"%@\",\"prono\":\"%@\",\"danwei\":\"%@\"},",CpId.text,proname,chanpinguige.text,zhehoudanjia.text,shuliang.text,jinE.text,danWeiId.text,danWeiId.text,chanpindanwei.titleLabel.text,zhehoudanjia.text,@"",shuliang.text,chanpinCode.text,chanpindanwei.titleLabel.text] atIndex:aichongStr.length - 1];
            //////
            [chanpinStr insertString:[NSString stringWithFormat:@"{\"totalmoney\":\"%@\",\"returnrate\":\"%@\",\"prono\":\"%@\",\"proname\":\"%@\",\"table\":\"ddmx\",\"type\":\"%@\",\"singleprice\":\"%@\",\"maincount\":\"%@\",\"remaincount\":\"%@\",\"stockcount\":\"%@\",\"saletype\":\"%@\",\"saledprice\":\"%@\",\"specification\":\"%@\",\"prounitname\":\"%@\",\"proid\":\"%@\",\"prounitid\":\"%@\",\"saledmoney\":\"%@\"},",jinE.text,fanlilu.text,chanpinCode.text,proname,danWeiId.text,danjia.text,shuliang.text,shuliang.text,keyongkucun.text,SaleTyepId.text,zhehoudanjia.text,chanpinguige.text,chanpindanwei.titleLabel.text,CpId.text,UnitId.text,zhehouJine.text] atIndex:chanpinStr.length - 1];
        }
        
        //           NSUInteger length1 = aichongStr.length;
        //           [aichongStr deleteCharactersInRange:NSMakeRange(length1-2, 1)];
        //           NSLog(@"添加爱宠订单字符串:%@",aichongStr);
        
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
        
    } else if (_nullFlag == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"销售类型、单位和数量不可为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag != 101) {
//        for (int i = 0; i < _flag; i++) {
//            UITextField * spTf = [_fanliLvArray objectAtIndex:i];
//            singleprice = spTf.text;
//            singleprice = [self replaceChar:singleprice];
//            UITextField * ctTf = [_countArray objectAtIndex:i];
//            count = ctTf.text;
//            count = [self replaceChar:count];
//            double danjia = [singleprice floatValue];
//            double shumu = [count doubleValue];
//            double jine = danjia * shumu ;
//            _jine1 = [NSString stringWithFormat:@"%.2f",jine];
//            UILabel *jinE = _JineArray[i];
//            jinE.text = _jine1;
//        }
        
        for (int i = 0; i < _flag; i++) {
        //计算金额
        UILabel *danJia = [_singlePriceArray objectAtIndex:i];
        UITextField *shuliang = [_countArray objectAtIndex:i];
        UITextField *reRate = [_fanliLvArray objectAtIndex:i];
        UILabel *zheHouDanJia = [_zhehouSinglePriceArray objectAtIndex:i];
        UILabel *zhehouJine = [_zhehouJineArray objectAtIndex:i];
        UILabel *jinE = [_JineArray objectAtIndex:i];
        
        double danjia = [danJia.text floatValue];
        double shumu = [shuliang.text doubleValue];
        double m = [reRate.text doubleValue];
        
        double jine = danjia * shumu ;
        double zhehoudanjia = danjia * (1.00 - m);
        double zhehoujine = danjia * shumu * (1.00 - m);
        
        _jine1 = [NSString stringWithFormat:@"%.2f",jine];
        jinE.text = _jine1;
        NSString *zheHouDanJiaStr = [NSString stringWithFormat:@"%.2f",zhehoudanjia];
        NSString *zheHouJinEStr = [NSString stringWithFormat:@"%.2f",zhehoujine];
        //
        zheHouJinEStr = [self getNumber:zheHouJinEStr];
        zheHouDanJia.text = zheHouDanJiaStr;
        zhehouJine.text = zheHouJinEStr;
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
            UILabel *zhehoudanjia = [_zhehouSinglePriceArray objectAtIndex:_flag - 1];
            UITextField *falilv = [_fanliLvArray objectAtIndex:_flag - 1];
            UILabel *jinE = [_JineArray objectAtIndex:_flag - 1];
            UILabel *zheHouJinE = [_zhehouJineArray objectAtIndex:_flag - 1];
            UITextField *shuliang = [_countArray objectAtIndex:_flag - 1];
            UILabel *danWeiId = [_zhuFuDanWeiArray objectAtIndex:_flag - 1];
            danWeiId.text = [NSString stringWithFormat:@"%@",dic[@"type"]];
            
            double reRate = [falilv.text doubleValue];
            double danJia = [unitPrice doubleValue];
            double count = [shuliang.text doubleValue];
            double zheHouDanJia = danJia * (1.00 - reRate);
            
            
            double zhehoujine = zheHouDanJia * count;
            double jine = danJia *count;
            //最高限制销售类型
            if ([saleType isEqualToString:@"赠品"]) {
                danjia.text = @"0.00";
                zhehoudanjia.text = @"0.00";
                jinE.text = @"0.00";
                zheHouJinE.text = @"0.00";
                
            } else{
                
                danjia.text = unitPrice;
                zhehoudanjia.text = [NSString stringWithFormat:@"%.2f",zheHouDanJia];
                jinE.text = [NSString stringWithFormat:@"%.2f",jine];
                zheHouJinE.text = [NSString stringWithFormat:@"%.2f",zhehoujine];
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
     action	fuzzyQuery
     mobile	true
     page	1
     params	{"proname":"","custid":"137"}  id = 1357;
     rows	10
     table	cpxx
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
        self.proTableView.rowHeight = 80;
      [self.m_keHuPopView addSubview:self.proTableView];
//      [self.view addSubview:self.m_keHuPopView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
        [self getCPInfo];
    }
}
////产品名称搜索方法
//- (void)getPro{
//
//    /*
//     /product
//     action=fuzzyQuery
//
//     params= {"pronameLIKE":"sdfsdfs","custid":"111"}
//
//     */
//
//    if (_custid == nil) {
//
//        [self showAlert:@"请先选择客户"];
//    }else{
//
//
//        NSString *proName = _proField.text;
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
//        NSDictionary *params = @{@"action":@"fuzzyQuery",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\",\"custid\":\"%@\"}",proName,_custid]};
//        NSLog(@"上传数组%@",params);
//        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//
//            NSLog(@"产品信息搜索返回:%@",dic);
//            [_dataArray1 removeAllObjects];
//            for (NSDictionary *dic1 in dic) {
//                CPINfoModel *model = [[CPINfoModel alloc] init];
//                [model setValuesForKeysWithDictionary:dic1];
//                [_dataArray1 addObject:model];
////                NSArray *array = dic1[@"unitlist"];
////                [_UNITArray addObject:array];
//            }
//            //[_UNITArray addObjectsFromArray:_dataArray1];
//            [self.proTableView reloadData];
//
//
//        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//            NSInteger errorCode = error.code;
//            NSLog(@"错误信息%@",error);
//            if (errorCode == 3840 ) {
//                NSLog(@"自动登录");
//                [self selfLogin];
//            }else{
//
//                //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
//            }
//
//        }];
//
//
//    }
//
//}
- (void)getCPInfo
{
    if (_custid == nil) {
        
        [self showAlert:@"请先选择客户"];
    }else{
        
        NSString *proName = _proField.text;

        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
        NSDictionary *params = @{@"action":@"getMBProduct",@"mobile":@"true",@"table":@"cpxx",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"proname\":\"%@\",\"custid\":\"%@\"}",proName,_custid]};
        NSLog(@"%@",params);
        [_UNITArray removeAllObjects];
        [DataPost  requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSArray *array = dic[@"rows"];
            NSLog(@"产品信息返回:%@",dic);
           [_dataArray1 removeAllObjects];

            for (NSDictionary *dic in array) {
                CPINfoModel *model = [[CPINfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
                [_UNITArray addObject:dic[@"unitlist"]];
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
    
}


#pragma mark - TableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 10) {
        return _dataArray.count;
    }else if(tableView.tag == 20){
        return self.fuKuanFangShiArr.count;
    }else if(tableView.tag == 30){
        return self.faPiaoLieXingArr.count;
    }else if(tableView.tag == 40){
        return self.wuLiuMingChenArr.count;
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
        
        cell2.model = _dataArray[indexPath.row];
        return cell2;
        
    }else if(tableView.tag == 20){
        cell.textLabel.text = self.fuKuanFangShiArr[indexPath.row];
        return cell;
        
    }else if (tableView.tag == 30){
        
        cell.textLabel.text = self.faPiaoLieXingArr[indexPath.row];
        return cell;
        
    }else if (tableView.tag == 40){
        
        cell.textLabel.text = self.wuLiuMingChenArr[indexPath.row];
        return cell;
        
    }else if (tableView.tag == 50){
        
        cell1.model = _dataArray1[indexPath.row];
        return cell1;

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
    
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView.tag == 10) {
        [self.m_keHuPopView removeFromSuperview];
        _nameButton.userInteractionEnabled = YES;
        KHnameModel *model = [_dataArray objectAtIndex:indexPath.row];
        [_nameButton setTitle:model.name forState:UIControlStateNormal];
        _custid = model.Id;
        [self getCustInfo];
        [self getYewuyuanInfo];
        [self getCPInfo];
    } else if(tableView.tag == 20) {
        
        _payTypeButton.userInteractionEnabled = YES;
        [_payTypeButton setTitle:_fuKuanFangShiArr[indexPath.row] forState:UIControlStateNormal];
        _payTypeId = _fukuanfangshiId[indexPath.row];
        
    } else if (tableView.tag == 30){
        
//        [self.m_faPiaoLeiXingButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
//        _fapiaoleixingid = [_fapiaoleixingId objectAtIndex:indexPath.row];
        
    } else if (tableView.tag == 40){
        
        [_wuLiuButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        NSDictionary *dict = self.m_wuLiuArr[indexPath.row];
        self.wuLiuID = dict[@"id"];
        
        
        
    } else if (tableView.tag == 50){
            //产品信息
        CPINfoModel *model = [_dataArray1 objectAtIndex:indexPath.row];
        
        NSArray *array = _UNITArray[indexPath.row];
        _UnitPriceArray = [NSMutableArray array];
        for (NSDictionary *dic  in array) {
            UnitModel *model = [[UnitModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_UnitPriceArray addObject:model];
        }
        NSLog(@"单位价格%@",array);
        NSString *proprice;
        NSString *unit;
        NSString *unitId;
        
        for (UnitModel *model1 in _UnitPriceArray) {
            NSLog(@"ismain %@ ",model1.ismain);
            NSString *ismain = [NSString stringWithFormat:@"%@",model1.ismain];
            if ([ismain isEqualToString:@"1"]) {
                proprice = [NSString stringWithFormat:@"%@",model1.proprice];
                unitId = [NSString stringWithFormat:@"%@",model1.Id];
                unit = model1.name;
            }
        }

        
        UIButton *btn = [_cpNameBtnArray objectAtIndex:_flag-1];
        UILabel *cpCode = [_cpCodeArray objectAtIndex:_flag - 1];
        UILabel *chanpinguige = [_cpGuigeArray objectAtIndex:_flag-1];
        UILabel *danjia = [_singlePriceArray objectAtIndex:_flag-1];
        UILabel *keyongkucun = [_keyongKuCunArray objectAtIndex:_flag-1];
        UIButton *danWei = [_cpDanweiArray objectAtIndex:_flag - 1];
        UILabel *CpId = [_CPIdArray objectAtIndex:_flag - 1];
        UILabel *UnitId = [_UnitIdArray objectAtIndex:_flag - 1];
        UIButton *saleButton = [_xiaoshouTypeArray objectAtIndex:_flag - 1];
        NSString *saleType = saleButton.titleLabel.text;
        UITextField *reRate = [_fanliLvArray objectAtIndex:_flag - 1];  //返利率
        UILabel *zhehoudanjia = [_zhehouSinglePriceArray objectAtIndex:_flag - 1];//折后单价
        _proid =  [NSString stringWithFormat:@"%@",model.Id];
        
        reRate.text = [NSString stringWithFormat:@"%@",model.returnrate];
        [btn setTitle:model.proname forState:UIControlStateNormal];
        cpCode.text = [NSString stringWithFormat:@"%@",model.prono];
        chanpinguige.text = [NSString stringWithFormat:@"%@",model.specification];
        UITextField *shuliang = [_countArray objectAtIndex:_flag - 1];
        UILabel *jinE = [_JineArray objectAtIndex:_flag - 1];
        UILabel *zheHouJinE = [_zhehouJineArray objectAtIndex:_flag - 1];
        
        
        if ([saleType isEqualToString:@"赠品"]) {
            danjia.text = @"0.00";
            zhehoudanjia.text = @"0.00";
            
        }else{
            double count = [shuliang.text doubleValue];
            double falilv = [reRate.text doubleValue];
            double price = [proprice doubleValue];
            double zhehouPrice = price * (1.00 - falilv);
            double zhehoujine = price * count;
            double jine = zhehouPrice *count;
            NSLog(@"数量%.2f",count);
            danjia.text = [NSString stringWithFormat:@"%@",proprice];
            zhehoudanjia.text = [NSString stringWithFormat:@"%.2f",zhehouPrice];
            jinE.text = [NSString stringWithFormat:@"%.2f",jine];
            zheHouJinE.text = [NSString stringWithFormat:@"%.2f",zhehoujine];
        }
       _price = [NSString stringWithFormat:@"%@",proprice];
        NSLog(@"产品单价%@",proprice);
        keyongkucun.text = [NSString stringWithFormat:@"%@",model.freecount];
        CpId.text = [NSString stringWithFormat:@"%@",model.Id];
    
        //主单位设置
        [danWei setTitle:unit forState:UIControlStateNormal];
        UnitId.text = unitId;
        //[self danweiRequest];
        
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
{/*
  添加订单（保存）
  http://182.92.96.58:8005/yrt/servlet/order
  SP	true
  action	add
  table	ddxx
  
  data:"{"isFormal":"1","id":"","table":"ddxx","custid":"2010","custname":"测试数据线","salerid":"199","saler":"田靖","creditline":"0","ordertime":"2015-08-13","logisticsid":"","logisticsname":"","daidai":"1","daishoumoney":"1000","receiver":"","receivertel":"18865677898","receiveaddr":"山东济南历下区","ordercount":"87","ordermoney":"4440","returnordermoney":"4440","ordernote":"测试","ddmxList":[{"table":"ddmx","proid":"504","proname":"大输液ABC28","prono":"pc001","specification":"40袋/盒","prounitid":"191","prounitname":"盒","saletype":"125","singleprice":"52","remaincount":"33","maincount":"33","returnrate":"0","saledprice":"52","totalmoney":"1716","saledmoney":"1716","returnmoney":"","type":"1","stockcount":"48200"},{"table":"ddmx","proid":"503","proname":"大输液ABC27","prono":"pc001","specification":"39袋/盒","prounitid":"191","prounitname":"盒","saletype":"125","singleprice":"51","remaincount":"44","maincount":"44","returnrate":"0","saledprice":"51","totalmoney":"2244","saledmoney":"2244","returnmoney":"","type":"1","stockcount":"195"},{"table":"ddmx","proid":"500","proname":"大输液ABC24","prono":"pc001","specification":"36袋/盒","prounitid":"191","prounitname":"盒","saletype":"125","singleprice":"48","remaincount":"10","maincount":"10","returnrate":"0","saledprice":"48","totalmoney":"480","saledmoney":"480","returnmoney":"","type":"1","stockcount":"72"}]}"
  
  
  */
    
    if (_chanpinokFlag == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加产品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else if (_chanpinokFlag == 1){
        NSString * proname;
        for (int i = 0; i < _flag; i++) {
            
            UIButton *btn = [_cpNameBtnArray objectAtIndex:i];
            proname = btn.titleLabel.text;
            proname = [self replaceChar:proname];
            UITextField * spTf = [_fanliLvArray objectAtIndex:i];
            singleprice = spTf.text;
            singleprice = [self replaceChar:singleprice];
            UITextField * ctTf = [_countArray objectAtIndex:i];
            count = ctTf.text;
            count = [self replaceChar:count];
            if ([singleprice isEqualToString:@""]) {
                [self showAlert:@"返利率不可为空"];
                return;
            }
            if ([count isEqualToString:@""]){
                [self showAlert:@"数量不可为空"];
                return;
            }
            
        }
        if ([proname isEqualToString:@"请选择产品"]) {
            [self showAlert:@"请选择产品"];
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
#pragma mark - 提交按钮方法
- (void)addNext{
//    NSString *count = [NSString stringWithFormat:@"订单数量:%@",_totalaccount];
//    NSString *money = [NSString stringWithFormat:@"订单金额:%@",_totalJine];
    [self shangChuan];
    
    
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


- (void)searchAction{

}

@end
