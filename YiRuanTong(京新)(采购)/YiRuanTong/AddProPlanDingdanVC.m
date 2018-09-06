//
//  AddProPlanDingdanVC.m
//  YiRuanTong
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "AddProPlanDingdanVC.h"
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
@interface AddProPlanDingdanVC ()<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

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
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *departTable;
@property(nonatomic,retain)UITableView *payTypeTableView;
@property(nonatomic,retain)UITableView *cgAreaTable;
@property(nonatomic,retain)UITableView *supportTable;
@property(nonatomic,retain)UIDatePicker *datePicker;

@end

@implementation AddProPlanDingdanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生产计划下达";
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
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"---当前的时间的字符串 =%@",currentDateStr);
    _currentDateStr = currentDateStr;
    
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
//        [self fuKuanReqyest];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // [self PageViewDidLoad];
            
            
            [_HUD removeFromSuperview];
        });
    });

    
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
    //计划指定人
    UILabel *label1 =  [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 45)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"计划指定人";
    [self.dingDanAddScrollView addSubview:label1];
    _nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nameButton.frame = CGRectMake(85, 0, KscreenWidth - 90, 45);
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
#pragma mark ----------------------------- 添加产品-------------------------------  -
- (void)addProducts
{
    
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
    
//    [self saleTypeRequest];
    _chanpinokFlag = 1;
    
    _flag = _flag + 1;
    self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, _noteTf.bottom + _flag * 315+50);
    
    UIView *chanpinView = [[UIView alloc] initWithFrame:CGRectMake(0, _noteTf.bottom + 315 * (_flag - 1), KscreenWidth, 480)];
    chanpinView.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            if (_flag>=2) {
                [self.dingDanAddScrollView setContentOffset:CGPointMake(0,(_flag-1) * 315) animated:YES];
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
  
    
    //产品规格
    UILabel *chanPinGuiGe =[[UILabel alloc] initWithFrame:CGRectMake(5, chanPinName.bottom + 1, 80, 45)];
    chanPinGuiGe.text = @"规格";
    chanPinGuiGe.font = [UIFont systemFontOfSize:14];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, chanPinGuiGe.bottom, KscreenWidth, 1)];
    line3.backgroundColor = COLOR(240, 240, 240, 1);
    [chanpinView addSubview:line3];
    [chanpinView addSubview:chanPinGuiGe];
    UILabel *chanPinGuiGe1 = [[UILabel alloc] initWithFrame:CGRectMake(86, chanPinName.bottom + 1, KscreenWidth - 90, 45)];
    chanPinGuiGe1.font = [UIFont systemFontOfSize:14];
    chanPinGuiGe1.textAlignment = NSTextAlignmentLeft;
    chanPinGuiGe1.textColor = [UIColor grayColor];
    [chanpinView addSubview:chanPinGuiGe1];
    [_cpGuigeArray addObject:chanPinGuiGe1];
    
    //产品单位
    UILabel *chanPinDanWei = [[UILabel alloc] initWithFrame:CGRectMake(5, chanPinGuiGe.bottom + 1, 80, 45)];
    chanPinDanWei.text = @"单位";
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

    
    //数量
    UILabel *shuLiang = [[UILabel alloc] initWithFrame:CGRectMake(5, chanPinDanWeiButton1.bottom + 1, 80, 45)];
    shuLiang.text = @"计划数量";
    shuLiang.font = [UIFont systemFontOfSize:14];
    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(0, shuLiang.bottom, KscreenWidth, 1)];
    line7.backgroundColor = lineColor;
    [chanpinView addSubview:line7];
    [chanpinView addSubview:shuLiang];
    shuLiang1 = [[UITextField alloc] initWithFrame:CGRectMake(86, chanPinDanWeiButton1.bottom + 1, KscreenWidth - 90, 45)];
    shuLiang1.font =[UIFont systemFontOfSize:14];
    shuLiang1.delegate = self;
    shuLiang1.tag = 103;
    shuLiang1.keyboardType = UIKeyboardTypeNumberPad;
    shuLiang1.textAlignment = NSTextAlignmentLeft;
    shuLiang1.textColor = [UIColor grayColor];
    shuLiang1.placeholder = @"请输入数量";
    [chanpinView addSubview:shuLiang1];
    [_countArray addObject:shuLiang1];
    
    
    //是否加急
    UILabel *isspeed = [[UILabel alloc] initWithFrame:CGRectMake(5, shuLiang.bottom + 1, 80, 45)];
    isspeed.text = @"是否加急";
    isspeed.font =[UIFont systemFontOfSize:14];
    UIView *line10 = [[UIView alloc] initWithFrame:CGRectMake(0, isspeed.bottom, KscreenWidth, 1)];
    line10.backgroundColor = lineColor;
    [chanpinView addSubview:line10];
    [chanpinView addSubview:isspeed];
    UILabel *isurg = [[UILabel alloc] initWithFrame:CGRectMake(86, shuLiang.bottom + 1, KscreenWidth-86, 45)];
    isurg.font = [UIFont systemFontOfSize:14];
    isurg.textAlignment = NSTextAlignmentLeft;
    isurg.textColor = [ UIColor grayColor];
    isurg.text = @"否";
    isurg.tag = 2018;
    isurg.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectIsUrgent:)];
    [isurg addGestureRecognizer:tap];
    [chanpinView addSubview:isurg];
    [_JineArray addObject:isurg];
    
    
    
    UILabel *notelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, line10.bottom+1, 80, 45)];
    notelabel.font = [UIFont systemFontOfSize:14];
    notelabel.text = @"备注";
    UIView *lineNote = [[UIView alloc] initWithFrame:CGRectMake(0, notelabel.bottom, KscreenWidth, 1)];
    lineNote.backgroundColor = lineColor;
    [chanpinView addSubview:line10];
    [chanpinView addSubview:notelabel];
    _note = [[UITextField alloc]initWithFrame:CGRectMake(85, line10.bottom+1, KscreenWidth - 90, 45)];
    _note.textAlignment = NSTextAlignmentLeft;
    _note.textColor = [UIColor grayColor];
    _note.font = [UIFont systemFontOfSize:14];
    [chanpinView addSubview:_note];
    [_noteArray addObject:_note];
    
    
    [self.dingDanAddScrollView addSubview:chanpinView];
    [_chanpinViewArray addObject:chanpinView];
    

    
    //添加产品的按钮设置
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 315, KscreenWidth, 45)];
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
    [chanpinView addSubview:buttonView];
    _detailView.frame = CGRectMake(0, 182 + 315 + (_flag - 1)  * 315, KscreenWidth, 310);
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
-(void)selectIsUrgent:(UITapGestureRecognizer *)tap{
    
    
    //创建一个UIActionSheet，其中destructiveButton会红色显示，可以用在一些重要的选项
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否加急" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"否",@"是", nil,nil];
    
    int i = 0;
    for (UILabel *lab in _JineArray) {
        if ([lab isEqual:tap.view]) {
            actionSheet.tag = i+100;
        }
        i++;
    }
    //actionSheet风格，感觉也没什么差别- -
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;//
    //获取按钮总数
    NSString *num = [NSString stringWithFormat:@"%ld", actionSheet.numberOfButtons];
    NSLog(@"%@", num);
    
    //获取某个索引按钮的标题
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:1];
    NSLog(@"%@", btnTitle);
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
//根据被点击的按钮做出反应，0对应destructiveButton，之后的button依次排序
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    for (int i = 0; i<_flag; i++) {
        UILabel *isurgent = [_JineArray objectAtIndex:i];
        NSLog(@"%@",isurgent.text);
        
        if (actionSheet.tag-100==i) {
            if (buttonIndex == 0) {
                
                isurgent.text = @"否";
                
            }else if (buttonIndex == 1) {
                
                isurgent.text = @"是";
                
            }
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
//            [_cpCodeArray removeObjectAtIndex:_flag - 1];
            [_cpGuigeArray removeObjectAtIndex:_flag - 1];
//            [_singlePriceArray removeObjectAtIndex:_flag - 1];
            [_cpDanweiArray removeObjectAtIndex:_flag - 1];
            //            [_UNITArray removeObjectAtIndex:_flag-1];
            [_JineArray removeObjectAtIndex:_flag - 1];
            [_cpNameBtnArray removeObjectAtIndex:_flag - 1];
            [_countArray removeObjectAtIndex:_flag - 1];
            
            UIView *view = [_chanpinViewArray objectAtIndex:_flag - 1];
            [view removeFromSuperview];
            [_chanpinViewArray removeObjectAtIndex:_flag - 1];
            self.dingDanAddScrollView.contentSize = CGSizeMake(KscreenWidth, self.dingDanAddScrollView.contentSize.height - 315);
            //客户详情的位置
            _detailView.frame = CGRectMake(0, 182 +  (_flag - 1)  * 315, KscreenWidth, 310);
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
//    if (textField.tag == 103) {
//
//        for (int i = 0; i < _flag; i++) {
//            UITextField * spTf = [_singlePriceArray objectAtIndex:i];
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
//
//    }
//    if (textField.tag == 102) {
//        //计算金额
//        for (int i = 0; i < _flag; i++) {
//            UITextField * spTf = [_singlePriceArray objectAtIndex:i];
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
//
//    }
    
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/production"];
    NSDictionary *params = @{@"action":@"getProName",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",proName]};
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
    
    if(tableView.tag == 20){
        return _cgpeopleArr.count;
    }else if(tableView.tag == 30){
        return _cgAreaArr.count;
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
    if(tableView.tag == 20){
        cell.textLabel.text = _cgpeopleArr[indexPath.row];
        return cell;
        
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
     if(tableView.tag == 20) {
        _nameButton.userInteractionEnabled = YES;
        [_nameButton setTitle:[_cgpeopleArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        _custid = [_cgpeopleIdArr objectAtIndex:indexPath.row];
        
        
    }else if (tableView.tag == 50){
        //产品信息
        CPINfoModel *model = [[CPINfoModel alloc]init];
        model = _UNITArray[indexPath.row];
        UIButton *btn = [_cpNameBtnArray objectAtIndex:_flag-1];
        UILabel *chanpinguige = [_cpGuigeArray objectAtIndex:_flag-1];
        UIButton *danWei = [_cpDanweiArray objectAtIndex:_flag - 1];
        
        _measureunitid =  [NSString stringWithFormat:@"%@",model.mainunitid];
        _proid =  [NSString stringWithFormat:@"%@",model.Id];
        [btn setTitle:model.name forState:UIControlStateNormal];
        
        chanpinguige.text = [NSString stringWithFormat:@"%@",model.specification];
        [danWei setTitle:model.mainunitname forState:UIControlStateNormal];
        
        
    }
}
#pragma mark  -- 订单添加事件
- (void)shangChuan
{
    
    if ([_nameButton.titleLabel.text isEqualToString:@"请选择指定人"]) {
        [self showAlert:@"请选择指定人"];
        return;
    }
    if ([_cgpeopleBtn.titleLabel.text isEqualToString:@"请选择时间"]) {
        [self showAlert:@"请选择时间"];
        return;
    }
    
    
    if (_chanpinokFlag == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加产品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else if (_chanpinokFlag == 1){
        NSString *proname;
        
        for (int i = 0; i < _flag; i++) {
            
            UIButton *btn = [_cpNameBtnArray objectAtIndex:i];
            proname = btn.titleLabel.text;
            proname = [self replaceChar:proname];
            UITextField * ctTf = [_countArray objectAtIndex:i];
            count = ctTf.text;
            count = [self replaceChar:count];
            if ([count isEqualToString:@""]){
                [self showAlert:@"数量不可为空"];
                return;
            }
            
        }
        if ([proname isEqualToString:@"请选择产品"]) {
            [self showAlert:@"请添加产品"];
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
    //http://192.168.1.199:8080/jingxin/servlet/production?action=addPlan&SP=true
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/production"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    //计算总金额
//    double totalmoney = 0;
    //        double totalzhehou = 0;
    NSInteger totalshumu = 0;
    
    for (int i = 0; i < _flag; i++) {
        
        
        UITextField *shuliang = [_countArray objectAtIndex:i];
        totalshumu = totalshumu + [shuliang.text integerValue];
    }
    _totalaccount = [NSString stringWithFormat:@"%zi",totalshumu];

    
    NSString *name = _nameButton.titleLabel.text;
    name = [self convertNull:name];
    NSString *notetf = _noteTf.text;
    notetf = [self convertNull:notetf];
    NSString *startTime = _cgpeopleBtn.titleLabel.text;
    startTime = [self convertNull:startTime];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"SP=true&action=addPlan&table=scjh&data={\"table\":\"scjh\",\"creatorid\":\"%@\",\"creator\":\"%@\",\"plantime\":\"%@\",\"note\":\"%@\"}",_custid,name,startTime,notetf];
    NSMutableString *chanpinStr = [NSMutableString stringWithFormat:@"\"ddmxList\":[]"];
    
    for (int i = 0; i < _flag; i++) {
        
        UIButton *btn = [_cpNameBtnArray objectAtIndex:i];
        NSString *proname = btn.titleLabel.text;
        proname = [self replaceChar:proname];
        UILabel *chanpinguige = [_cpGuigeArray objectAtIndex:i];
        UIButton *chanpindanwei = [_cpDanweiArray objectAtIndex:i];
        NSString *chanpindanweis = chanpindanwei.titleLabel.text;
        UILabel *note = [_noteArray objectAtIndex:i];
        UILabel *isUrgent = [_JineArray objectAtIndex:i];
        chanpindanweis = [self replaceChar:chanpindanweis];
        UITextField *shuliang = [_countArray objectAtIndex:i];
        UILabel *UnitId = [_UnitIdArray objectAtIndex:i];
        NSLog(@"%@",UnitId.text);
        NSString * _iss;
        if ([isUrgent.text isEqualToString:@"是"]) {
            _iss = @"1";
        }else{
            _iss = @"0";
        }
        [chanpinStr insertString:[NSString stringWithFormat:@"{\"table\":\"scjhmx\",\"proid\":\"%@\",\"proname\":\"%@\",\"specification\":\"%@\",\"mainunitid\":\"%@\",\"mainunitname\":\"%@\",\"plancount\":\"%@\",\"pronote\":\"%@\",\"isurgent\":\"%@\"},",_proid,proname,chanpinguige.text,_measureunitid,chanpindanweis,shuliang.text,note.text,_iss] atIndex:chanpinStr.length - 1];
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
    [btn addTarget:self action:@selector(cgPeopleDataRequest) forControlEvents:UIControlEventTouchUpInside];
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
    _custField.text = [self convertNull:_custField.text];
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
@end
