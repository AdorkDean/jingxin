//
//  KeHuXinXiVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "KeHuXinXiVC.h"
#import "KeHuViewController.h"
#import "AFHTTPRequestOperationManager.h"
//#import "BMapKit.h"
#import "SeeLocationViewController.h"
#import "AddKeHuVC.h"
#import "MBProgressHUD.h"
#import "LinkerModel.h"
#import "UIViewExt.h"
#import "ProvinceModel.h"
#import "DataPost.h"
#import "CommonModel.h"
#define   lineColer COLOR(240, 240, 240, 1);

@interface KeHuXinXiVC ()<BMKLocationServiceDelegate,UIAlertViewDelegate,UITextFieldDelegate>

{
    MBProgressHUD *_hud;
    
    NSString *_logtitude;
    NSString *_latitude;
    BMKLocationService *_locService;
    NSArray *_yewuyuanInfo;
    NSArray *_wuliuInfo;
    NSArray *_linkerInfo;
    UIView *_buttonView;
    
    UIButton *_ziLiaoButton;
    UIButton *_yeWuYuanButton;
    UIButton *_shouHuoButton;
    UIButton *_wuLiuButton;
    UIButton *_kaiPiaoButton;
    UIButton *_lianXiRenButton;
    UIButton *_baiFangButton;
    
    UILabel *_ziLiaoLabel;
    UILabel *_yeWuYuanLabel;
    UILabel *_shouHuoLabel;
    UILabel *_wuLiuLabel;
    UILabel *_kaiPiaoLabel;
    UILabel *_lianXiRenLabel;
    UILabel *_baiFangLabel;
    
    NSMutableArray *_btnArray;
    UIButton *_currentBtn;
    
    NSString *_typeid;
    NSString *_classid;
    
    NSString *_isteamwork;
    NSString *_isprivate;
    NSString *_account;
    NSString *_accountid;
    NSString *_ismain;
    NSString *_ismainWuliu;
    NSString *_logid;
    NSString *_ismainLinker;
    NSString *_tracelevel;
    NSString *_classname;
    
    
    
    NSInteger _flag1;//联系人个数
    NSMutableArray *_QQarray;
    NSMutableArray *_viewArray;
    NSMutableArray *_lianxirenArray;
    NSMutableArray *_zhiwuArray;
    NSMutableArray *_shoujiArray;
    NSMutableArray *_zuojiArray;
    NSMutableArray *_youxiangArray;
    NSMutableArray *_zhuyaoLXRArray;
    NSMutableArray *_linkerDataArray;
    NSMutableArray *_kehudizhiArray;
    MBProgressHUD *_HUD;
    // 资料详情
    
    NSArray *_YNArray;
    UITableView *_YNTableView;
    //
    UIView  *_timeView;
    //资料
    UIView *_backView;
    UIButton *_typeButton;//客户性质
    UIButton *_custStatusBtn;
    UITextField *_note;
    UITextField *_cust;
    UIButton *_classButton;
    UITextField *_yeWuGuiMo;
    UIButton *_teamWork;
    UIButton *_dateButton;//成立时间
    UIButton *_date2Button; // 建立业务时间
    
    UIButton *_province;
    UIButton *_city;
    UIButton *_county;
    NSString *_provinceId;
    NSString *_cityId;
    NSString *_countyId;
    UITextField *_addressDetail; //详细地址
    UITextField *_companyName;   //客户简称
    UITextField *_creditLine;    //信用额度
    
    //
   // UIButton *_kehujibieButton; //跟踪级别
    NSString *_tracelevelid;
    UIButton *_private;         //是否私有
    UITextField *_zhuCeMoney; //注册资金
    UITextField *_qiyefaren;  //企业法人
    UITextField *_fushequyu;  //辐射区域
    UIButton *_area;        //所属区域
    NSString *_currentDateStr;
    
    //收货信息
    UIView  *_linkerView;
    UITextField *_receiverName;
    UITextField *_receiverCell;
    UITextField *_receiverTel;
    UITextField *_receiverAdress;
    UIView *_receiveBackView;
    //开票信息
    UITextField *_kaiPiaoName;
    UITextField *_shiBieHao;
    UITextField *_kaiPiaoAddress;
    UITextField *_kaiPiaoTel;
    UITextField *_kaiPiaoBank;
    UITextField *_kaiPiaoCardNo;
    UIView *_kaiPiaoBackView;
    //业务员
    NSInteger _salerFlag;
    NSMutableArray *_salerArray;
    NSMutableArray *_isMain;
    NSMutableArray *_salerViewArray;
    NSMutableArray *_salerIdArray;
    
    UITextField *_salerField;
    NSMutableArray *_salerDataArray;
    UIButton* _hide_keHuPopViewBut;
#pragma mark------------------------------------------------
    /*
     *记录一下scrollView滑动的起始位置，用于判断是否是横向滑动
     */
    CGFloat _startcontentOffsetX;
    
}
@property(nonatomic,retain)UIScrollView *ziLiaoScrollView;
@property(nonatomic,retain)UIScrollView *shouHuoScrollView;
@property(nonatomic,retain)UIScrollView *kaiPiaoScrollView;


@property(strong,nonatomic) UIDatePicker * datePicker;
@property(nonatomic,retain)UITableView *YorNTableView;  //是否合作
@property(nonatomic,retain)UITableView *YorNTableView1; //是否主要联系人
@property(nonatomic,retain)UITableView *YorNTableView2; //是否私有
@property(nonatomic,retain)UITableView *YorNTableView3;
@property(nonatomic,retain)UITableView *areaTableView;

@property(nonatomic,retain)UITableView *salerTableView;

@end

@implementation KeHuXinXiVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //标题
    self.title = @"客户信息";
    _btnArray = [[NSMutableArray alloc] init];
    _viewArray = [NSMutableArray array];
    _lianxirenArray = [NSMutableArray array];
    _zhiwuArray = [NSMutableArray array];
    _shoujiArray = [NSMutableArray array];
    _zuojiArray = [NSMutableArray array];
    _youxiangArray  = [NSMutableArray array];
    _kehudizhiArray = [NSMutableArray array];
    _zhuyaoLXRArray = [NSMutableArray array];
    _linkerDataArray = [NSMutableArray array];
    _QQarray = [NSMutableArray array];
    _YNArray = @[@"是",@"否"];
    //业务员数据
    _salerArray = [NSMutableArray array];
    _salerIdArray = [NSMutableArray array];
    _isMain = [NSMutableArray array];
    _salerViewArray = [NSMutableArray array];
    _salerDataArray = [NSMutableArray array];

    
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.labelText = @"网络不给力，正在加载中...";
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD show:YES];
    //添加按钮
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 20);
    [AddButton setTitle:@"修改" forState:UIControlStateNormal];
    [AddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(xiugaiKehu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;

    //GCD
    dispatch_async(dispatch_get_global_queue(0 , 0), ^{
        [self requestdata];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initMainView];
            [self initCustView];
            [self initLinkerView];
            [self initSalerView];
             [_HUD hide:YES afterDelay:1.0];
        });
    });

    
   
    //默认设置
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];

}

- (void)requestdata
{
    [self yewuyuanRequest];
    
    [self requestWuliuInfo];
   
    
    
}

#pragma mark -------------------------页面设置－－－－－－－－－－－－－－－－－－－－
- (void)initMainView
{
    //标题下方的6个按钮和view;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    //7个按钮的设置
    _ziLiaoButton = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth/6 - 20, 4, 40, 30)];
    _ziLiaoButton.tag = 0;
    _ziLiaoButton.titleLabel.text = @"资料";
    [_ziLiaoButton setImage:[UIImage imageNamed:@"kh_zl"] forState:UIControlStateNormal];
    [_ziLiaoButton setImage:[UIImage imageNamed:@"kh_zl1"] forState:UIControlStateSelected];
    _currentBtn = _ziLiaoButton;
    _currentBtn.selected = YES;
    _ziLiaoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _ziLiaoLabel =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/6 - 20, 36, 40, 10)];
    _ziLiaoLabel.font =[UIFont systemFontOfSize:13];
    _ziLiaoLabel.textColor =[UIColor grayColor];
    _ziLiaoLabel.text = @"资料";
    _ziLiaoLabel.textAlignment = NSTextAlignmentCenter;
    [_ziLiaoButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_ziLiaoButton];
    [buttonView addSubview:_ziLiaoLabel];
    
    
    _lianXiRenButton = [[UIButton alloc]initWithFrame:CGRectMake( KscreenWidth/3*1  + KscreenWidth/6 - 20 , 4, 40, 30)];
    _lianXiRenButton.tag = 1;
    _lianXiRenButton.titleLabel.text = @"联系人";
    [_lianXiRenButton setImage:[UIImage imageNamed:@"kh_lxr"] forState:UIControlStateNormal];
    [_lianXiRenButton setImage:[UIImage imageNamed:@"kh_lxr1"] forState:UIControlStateSelected];
    _lianXiRenButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _lianXiRenLabel = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/3*1  + KscreenWidth/6 - 20, 36, 40, 10)];
    _lianXiRenLabel.font = [UIFont systemFontOfSize:13];
    _lianXiRenLabel.textColor = [UIColor grayColor];
    _lianXiRenLabel.text = @"联系人";
    _lianXiRenLabel.textAlignment = NSTextAlignmentCenter;
    
    [_lianXiRenButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_lianXiRenButton];
    [buttonView addSubview:_lianXiRenLabel];
    
    
    _yeWuYuanButton = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth/3*2 + KscreenWidth/6 - 20, 4, 40, 30)];
    _yeWuYuanButton.tag = 2;
    _yeWuYuanButton.titleLabel.text = @"业务员";
    [_yeWuYuanButton setImage:[UIImage imageNamed:@"kh_ywy"] forState:UIControlStateNormal];
    [_yeWuYuanButton setImage:[UIImage imageNamed:@"kh_ywy1"] forState:UIControlStateSelected];
    _yeWuYuanButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _yeWuYuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/3*2  + KscreenWidth/6 - 20, 36, 40, 10)];
    _yeWuYuanLabel.font = [UIFont systemFontOfSize:13];
    _yeWuYuanLabel.textColor = [UIColor grayColor];
    _yeWuYuanLabel.text = @"业务员";
    _yeWuYuanLabel.textAlignment = NSTextAlignmentCenter;
    [_yeWuYuanButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_yeWuYuanButton];
    [buttonView addSubview:_yeWuYuanLabel];
    
    
    
    [_btnArray addObject:_ziLiaoButton];
    [_btnArray addObject:_lianXiRenButton];
    [_btnArray addObject:_yeWuYuanButton];
    
    
    //标题下方View的设置
    //UIScrollerView
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight-114)];
    self.mainScrollView.contentSize = CGSizeMake(KscreenWidth*3, KscreenHeight - 114);
    self.mainScrollView.bounces = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.alwaysBounceVertical = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    //客户信息
    self.ziLiaoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-114)];
    self.ziLiaoScrollView.contentSize = CGSizeMake(0, 580);
    self.ziLiaoScrollView.delegate = self;
    [self.mainScrollView addSubview:self.ziLiaoScrollView];
#pragma mark - 联系人Scrollview
    self.lianXiRenScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth, KscreenHeight-114)];
    self.lianXiRenScrollview.delegate = self;
    [self.mainScrollView addSubview:self.lianXiRenScrollview];
    //业务员
    self.salerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(KscreenWidth*2, 0, KscreenWidth, KscreenHeight-114)];
    self.salerScrollView.delegate=self;
    [self.mainScrollView addSubview:self.salerScrollView];
    
    //按钮下边的边线
    UIView *keHuXinXiView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, KscreenWidth, 1)];
    keHuXinXiView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:keHuXinXiView];
    
    
}


#pragma mark - 客户信息详情
- (void)initCustView{
    
   
    //资料
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, KscreenWidth - 80, 40)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.text = @"客户信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.ziLiaoScrollView addSubview:titleLabel];
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view0.backgroundColor = lineColer;
    [self.ziLiaoScrollView addSubview:view0];
    //
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, KscreenWidth, 778)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.ziLiaoScrollView addSubview:_backView];
    //客户资料详情
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"客户名称";
    label1.font =[UIFont systemFontOfSize:14];
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = lineColer;
    [_backView addSubview:view1];
    [_backView addSubview:label1];
    _cust = [[UITextField alloc] initWithFrame:CGRectMake(label1.right, 0, KscreenWidth - 100, 45)];
    _cust.delegate = self;
    _cust.font = [UIFont systemFontOfSize:14];
    _cust.textAlignment = NSTextAlignmentLeft;
    [_backView addSubview:_cust];
    _cust.text = _model.name;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"助记码";
    label2.font =[UIFont systemFontOfSize:14];
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
    view2.backgroundColor = COLOR(240, 240, 240, 1);
    _companyName =[[UITextField alloc] initWithFrame:CGRectMake(label2.right, label1.bottom + 1, KscreenWidth - 100, 45)];
    _companyName.font = [UIFont systemFontOfSize:14];
    _companyName.textAlignment = NSTextAlignmentLeft;
    _companyName.delegate = self;
    [_backView addSubview:label2];
    [_backView addSubview:view2];
    [_backView addSubview:_companyName];
    _companyName.text = [NSString stringWithFormat:@"%@",_model.helpno];
    
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"客户分类";
    label3.font =[UIFont systemFontOfSize:14];
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom, KscreenWidth, 1)];
    view3.backgroundColor = lineColer;
    _classButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _classButton.frame = CGRectMake(label3.right, label2.bottom + 1, KscreenWidth - 100, 45);
    [_classButton setTintColor:[UIColor grayColor]];
    _classButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _classButton.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
    [_classButton addTarget:self action:@selector(classAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:label3];
    [_backView addSubview:view3];
    [_backView addSubview:_classButton];
    [_classButton setTitle:_model.classname forState:UIControlStateNormal];
    _classid = _model.classid;
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"客户状态";
    label4.font =[UIFont systemFontOfSize:14];
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom, KscreenWidth, 1)];
    view4.backgroundColor = lineColer;
    _custStatusBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _custStatusBtn.frame = CGRectMake(label4.right, label3.bottom + 1, KscreenWidth - 100, 45);
    _custStatusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_custStatusBtn setTintColor:[UIColor grayColor]];
    _custStatusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_custStatusBtn addTarget:self action:@selector(kehujibie) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:label4];
    [_backView addSubview:view4];
    [_backView addSubview:_custStatusBtn];
    NSLog(@"状态%@",_model.tracelevel);
    [_custStatusBtn setTitle:_model.tracelevel forState:UIControlStateNormal];
    _tracelevelid = _model.tracelevelid;
    
    UILabel * label10 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label10.text = @"收货人";
    label10.font =[UIFont systemFontOfSize:14];
    UIView *view10 = [[UIView alloc]initWithFrame:CGRectMake(0, label10.bottom, KscreenWidth, 1)];
    view10.backgroundColor = lineColer;
    [_backView addSubview:label10];
    [_backView addSubview:view10];
    _receiverName = [[UITextField alloc] initWithFrame:CGRectMake(label10.right, label4.bottom + 1, KscreenWidth - 100, 45)];
    _receiverName.tag = 1001;
    _receiverName.textAlignment = NSTextAlignmentLeft;
    _receiverName.textColor = [UIColor grayColor];
    _receiverName.font = [UIFont systemFontOfSize:14];
    _receiverName.text = _model.receivername;
    [_backView addSubview:_receiverName];
    
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label10.bottom + 1, 80, 45)];
    label5.text = @"收货电话";
    label5.font =[UIFont systemFontOfSize:14];
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom, KscreenWidth, 1)];
    view5.backgroundColor = lineColer;
    [_backView addSubview:label5];
    [_backView addSubview:view5];
    _receiverTel = [[UITextField alloc] initWithFrame:CGRectMake(label5.right, label10.bottom + 1, KscreenWidth - 100, 45)];
    _receiverTel.tag = 1002;
    _receiverTel.delegate = self;
    _receiverTel.textAlignment = NSTextAlignmentLeft;
    _receiverTel.font = [UIFont systemFontOfSize:14];
    _receiverTel.textColor = [UIColor grayColor];
    _receiverTel.text = [NSString stringWithFormat:@"%@",_model.receivercell];
    [_backView addSubview:_receiverTel];
    ///////
    UILabel * label9 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label9.text = @"地址";
    label9.font =[UIFont systemFontOfSize:14];
    UIView *view9 = [[UIView alloc]initWithFrame:CGRectMake(0, label9.bottom, KscreenWidth, 1)];
    view9.backgroundColor = lineColer;
    [_backView addSubview:label9];
    [_backView addSubview:view9];
    _receiverAdress = [[UITextField alloc] initWithFrame:CGRectMake(label9.right, label5.bottom + 1, KscreenWidth - 100, 45)];
    _receiverAdress.tag = 1003;
    _receiverAdress.textAlignment = NSTextAlignmentLeft;
    _receiverAdress.font = [UIFont systemFontOfSize:14];
    _receiverAdress.textColor = [UIColor grayColor];
    _receiverAdress.text  = _model.receiveaddr;
    [_backView addSubview:_receiverAdress];
    
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, _receiverAdress.bottom + 1, 80, 45)];
    label6.text = @"省";
    label6.font =[UIFont systemFontOfSize:14];
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 1)];
    view6.backgroundColor = lineColer;
    [_backView addSubview:label6];
    [_backView addSubview:view6];
    
    _province = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _province.frame = CGRectMake(label6.right, _receiverAdress.bottom + 1, KscreenWidth - 100, 45);
    _province.titleLabel.font = [UIFont systemFontOfSize:14];
    [_province setTintColor:[UIColor grayColor]];
    _province.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_province addTarget:self action:@selector(KHprovince) forControlEvents:UIControlEventTouchUpInside];
    [_province setTitle:_model.provincename forState:UIControlStateNormal];
    [_backView addSubview:_province];
    
    
    //
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label6.bottom + 1, 80, 45)];
    label7.text = @"市";
    label7.font =[UIFont systemFontOfSize:14];
    UIView *view7 = [[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom, KscreenWidth, 1)];
    view7.backgroundColor = lineColer;
    [_backView addSubview:label7];
    [_backView addSubview:view7];
    _city = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _city.frame = CGRectMake(label7.right, label6.bottom + 1, KscreenWidth - 100, 45);
    _city.titleLabel.font = [UIFont systemFontOfSize:14];
    [_city setTintColor:[UIColor grayColor]];
    _city.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_city addTarget:self action:@selector(KHcity) forControlEvents:UIControlEventTouchUpInside];
    [_city setTitle:_model.cityname forState:UIControlStateNormal];
    [_backView addSubview:_city];
    //
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 80, 45)];
    label8.text = @"县";
    label8.font =[UIFont systemFontOfSize:14];
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, label8.bottom, KscreenWidth, 1)];
    view8.backgroundColor = lineColer;
    [_backView addSubview:label8];
    [_backView addSubview:view8];
    _county = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _county.frame = CGRectMake(label8.right, label7.bottom + 1, KscreenWidth - 100, 45);
    _county.titleLabel.font = [UIFont systemFontOfSize:14];
    [_county setTintColor:[UIColor grayColor]];
    _county.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_county addTarget:self action:@selector(KHcounty) forControlEvents:UIControlEventTouchUpInside];
    [_county setTitle:_model.countyname forState:UIControlStateNormal];
    [_backView addSubview:_county];
    //17
    
    
    UILabel * label11 = [[UILabel alloc]initWithFrame:CGRectMake(10, label8.bottom + 1, 80, 45)];
    label11.text = @"备注";
    label11.font =[UIFont systemFontOfSize:14];
    UIView *view11 = [[UIView alloc]initWithFrame:CGRectMake(0, label11.bottom, KscreenWidth, 1)];
    view11.backgroundColor = lineColer;
    [_backView addSubview:label11];
    [_backView addSubview:view11];
    _note = [[UITextField alloc] initWithFrame:CGRectMake(label11.right, label8.bottom + 1, KscreenWidth - 100, 45)];
    _note.textAlignment = NSTextAlignmentLeft;
    _note.textColor = [UIColor grayColor];
    _note.font = [UIFont systemFontOfSize:14];
    _note.text = _model.note;
    [_backView addSubview:_note];
    

    _provinceId = [NSString stringWithFormat:@"%@",_model.province];
    _cityId = [NSString stringWithFormat:@"%@",_model.city];;
    _countyId = [NSString stringWithFormat:@"%@",_model.county];;
    //禁用输入
    _backView.userInteractionEnabled = NO;

}

#pragma mark - 联系人详情
- (void)initLinkerView{
    
    [self requestLinkerInfo];
    
        self.lianXiRenScrollview.contentSize = CGSizeMake(0, _flag1*325 + 60);
        for (int i = 0; i < _flag1; i ++) {
            LinkerModel *model = _linkerDataArray[i];
            
            _linkerView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 325, KscreenWidth, 360)];
            _linkerView.backgroundColor = [UIColor whiteColor];
            [self.lianXiRenScrollview addSubview:_linkerView];
            
            [_viewArray addObject:_linkerView];
            //标题 取消按钮
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-140, 0, 280, 40)];
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = @"联系人信息";
            [_linkerView addSubview:titleLabel];
            //
            UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
            view0.backgroundColor = lineColer;
            [_linkerView addSubview:view0];
            //1
            UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 41, 80, 45)];
            label1.text = @"联系人";
            label1.font =[UIFont systemFontOfSize:14];
            UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, label1.bottom, KscreenWidth, 1)];
            view1.backgroundColor = lineColer;
            [_linkerView addSubview:view1];
            [_linkerView addSubview:label1];
            UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(90, 41, KscreenWidth - 100, 45)];
            field1.delegate = self;
            field1.textAlignment = NSTextAlignmentLeft;
            field1.font = [UIFont systemFontOfSize:14];
            [_linkerView addSubview:field1];
            [_lianxirenArray addObject:field1];
            field1.text = model.linker;
            //2
            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
            label2.text = @"联系人手机";
            label2.font =[UIFont systemFontOfSize:14];
            UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
            view2.backgroundColor =  lineColer;
            UITextField *field2 = [[UITextField alloc] initWithFrame:CGRectMake(90, label1.bottom + 1, KscreenWidth - 100, 45)];
            field2.font = [UIFont systemFontOfSize:14];
            field2.textAlignment = NSTextAlignmentLeft;
            field2.textColor = [UIColor grayColor];
            [_linkerView addSubview:label2];
            [_linkerView addSubview:view2];
            [_linkerView addSubview:field2];
            [_shoujiArray addObject:field2];
            field2.text = [NSString stringWithFormat:@"%@",model.cellno];
            //3 屏蔽
            UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
            label3.text = @"联系人电话";
            label3.font =[UIFont systemFontOfSize:14];
            UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom , KscreenWidth, 1)];
            view3.backgroundColor = lineColer;
            UITextField *field3 =[[UITextField alloc]initWithFrame:CGRectMake(90, label2.bottom + 1, KscreenWidth - 100, 45)];
            field3.font =[UIFont systemFontOfSize:14];
            field3.textColor = [UIColor grayColor];
            field3.textAlignment = NSTextAlignmentLeft;
//            [_linkerView addSubview:label3];
//            [_linkerView addSubview:view3];
//            [_linkerView addSubview:field3];
            [_zuojiArray addObject:field3];
            field3.text = [NSString stringWithFormat:@"%@",model.telno];
            //
            UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
            label4.text = @"QQ";
            label4.font =[UIFont systemFontOfSize:13];
            UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom, KscreenWidth, 1)];
            view4.backgroundColor = lineColer;
            UITextField *field4 =[[UITextField alloc]initWithFrame:CGRectMake(86, label2.bottom + 1, KscreenWidth - 100, 45)];
            field4.font =[UIFont systemFontOfSize:13];
            field4.textAlignment = NSTextAlignmentLeft;
            field4.textColor = [UIColor grayColor];
            [_linkerView addSubview:label4];
            [_linkerView addSubview:view4];
            [_linkerView addSubview:field4];
            [_QQarray addObject:field4];
            field4.text = model.qq;
            //5
            UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
            label5.text = @"邮箱";
            label5.font =[UIFont systemFontOfSize:13];
            UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom, KscreenWidth, 1)];
            view5.backgroundColor = lineColer;
            UITextField *field5 =[[UITextField alloc]initWithFrame:CGRectMake(86, label4.bottom + 1, KscreenWidth - 100, 45)];
            field5.font =[UIFont systemFontOfSize:13];
            field5.textAlignment = NSTextAlignmentLeft;
            field5.textColor = [UIColor grayColor];
            [_linkerView addSubview:label5];
            [_linkerView addSubview:view5];
            [_linkerView addSubview:field5];
            [_youxiangArray addObject:field5];
            field5.text = model.email;
            //
            UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
            label7.text = @"客户地址";
            label7.font =[UIFont systemFontOfSize:13];
            UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom, KscreenWidth, 1)];
            view7.backgroundColor = lineColer;
            UITextField *field7 =[[UITextField alloc]initWithFrame:CGRectMake(91, label5.bottom + 1, KscreenWidth - 100, 45)];
            field7.font =[UIFont systemFontOfSize:13];
            field7.textAlignment = NSTextAlignmentLeft;
            field7.delegate = self;
            [_linkerView addSubview:label7];
            [_linkerView addSubview:view7];
            [_linkerView addSubview:field7];
            [_kehudizhiArray addObject:field7];
            field7.text = model.address;
            
            //6
            UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 70, 45)];
            label6.text = @"是否为主要联系人";
            label6.numberOfLines = 0;
            label6.font =[UIFont systemFontOfSize:13];
            UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 1)];
            view6.backgroundColor = lineColer;
            UIButton *zhuYaoLinker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            zhuYaoLinker.frame = CGRectMake(86, label7.bottom +1, KscreenWidth - 100, 45);
            zhuYaoLinker.titleLabel.font = [UIFont systemFontOfSize:13];
            [zhuYaoLinker setTintColor:[UIColor grayColor]];
            zhuYaoLinker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [zhuYaoLinker addTarget:self action:@selector(YesOrNo2) forControlEvents:UIControlEventTouchUpInside];
            [_linkerView addSubview:label6];
            [_linkerView addSubview:view6];
            [_linkerView addSubview:zhuYaoLinker];
            [_zhuyaoLXRArray addObject:zhuYaoLinker];
            NSString *main = [NSString stringWithFormat:@"%@",model.ismain];
            int i = [main intValue];
            if (i == 1) {
                [zhuYaoLinker setTitle:@"是" forState:UIControlStateNormal];
            }else if(i == 0){
                [zhuYaoLinker setTitle:@"否" forState:UIControlStateNormal];
            }
            
            
            //禁用输入
            _linkerView.userInteractionEnabled = NO;
            
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 45)];
            tapView.backgroundColor = COLOR(220, 220, 220, 1);
            [_linkerView addSubview:tapView];
            
            UIButton *addLinker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            addLinker.frame = CGRectMake(KscreenWidth - 80, 2, 80, 40);
            [addLinker setTitle:@"继续添加" forState:UIControlStateNormal];
            addLinker.titleLabel.font = [UIFont systemFontOfSize:16];
            [addLinker addTarget:self action:@selector(addLinkerView) forControlEvents:UIControlEventTouchUpInside];
            [tapView addSubview:addLinker];

        }

    
}

- (void)addLinkerView{
    
    _flag1 = _flag1 + 1;
    self.lianXiRenScrollview.contentSize = CGSizeMake(KscreenWidth, _flag1 * 325 + 45 + 20);
    
    
    _linkerView = [[UIView alloc] initWithFrame:CGRectMake(0, (_flag1-1)*320, KscreenWidth, 360)];
    _linkerView.backgroundColor = [UIColor whiteColor];
    [self.lianXiRenScrollview addSubview:_linkerView];
    [_viewArray addObject:_linkerView];
    //标题 取消按钮
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-140, 0, 280, 40)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"联系人信息";
    [_linkerView addSubview:titleLabel];
    if (_flag1 > 1) {
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(KscreenWidth - 70, 0, 60, 40);
        cancel.tag = 1111;
        [cancel setTitle:@"删除" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_linkerView addSubview:cancel];
    }
    //
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view0.backgroundColor = lineColer;
    [_linkerView addSubview:view0];
    //1
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 41, 80, 45)];
    label1.text = @"联系人";
    label1.font =[UIFont systemFontOfSize:13];
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 86, KscreenWidth, 1)];
    view1.backgroundColor = lineColer;
    [_linkerView addSubview:view1];
    [_linkerView addSubview:label1];
    UITextField *field1 = [[UITextField alloc] initWithFrame:CGRectMake(86, 41, KscreenWidth - 100, 45)];
    field1.delegate = self;
    field1.font = [UIFont systemFontOfSize:13];
    field1.textAlignment = NSTextAlignmentLeft;
    [_linkerView addSubview:field1];
    [_lianxirenArray addObject:field1];
    
    //2
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 80, 45)];
    label2.text = @"联系方式";
    label2.font =[UIFont systemFontOfSize:13];
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 133, KscreenWidth, 1)];
    view2.backgroundColor = lineColer;
    UITextField *field2 = [[UITextField alloc] initWithFrame:CGRectMake(86, 87, KscreenWidth - 100, 45)];
    field2.font = [UIFont systemFontOfSize:13];
    field2.textAlignment = NSTextAlignmentLeft;
    [_linkerView addSubview:label2];
    [_linkerView addSubview:view2];
    [_linkerView addSubview:field2];
    [_shoujiArray addObject:field2];
    //3
    //3
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 134, 80, 45)];
    label3.text = @"联系人电话";
    label3.font =[UIFont systemFontOfSize:13];
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 179, KscreenWidth, 1)];
    view3.backgroundColor = lineColer;
    UITextField *field3 =[[UITextField alloc]initWithFrame:CGRectMake(86, 134, KscreenWidth - 100, 45)];
    field3.font =[UIFont systemFontOfSize:13];
    field3.textAlignment = NSTextAlignmentLeft;
    
    [_zuojiArray addObject:field3];
    //4
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label4.text = @"QQ";
    label4.font =[UIFont systemFontOfSize:13];
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom, KscreenWidth, 1)];
    view4.backgroundColor = lineColer;
    UITextField *field4 =[[UITextField alloc]initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 100, 45)];
    field4.font =[UIFont systemFontOfSize:13];
    field4.textAlignment = NSTextAlignmentLeft;
    [_linkerView addSubview:label4];
    [_linkerView addSubview:view4];
    [_linkerView addSubview:field4];
    [_QQarray addObject:field4];
    //5
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"邮箱";
    label5.font =[UIFont systemFontOfSize:13];
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom, KscreenWidth, 1)];
    view5.backgroundColor = lineColer;
    UITextField *field5 =[[UITextField alloc]initWithFrame:CGRectMake(91, label4.bottom + 1, KscreenWidth - 100, 45)];
    field5.font =[UIFont systemFontOfSize:13];
    field5.textAlignment = NSTextAlignmentLeft;
    [_linkerView addSubview:label5];
    [_linkerView addSubview:view5];
    [_linkerView addSubview:field5];
    [_youxiangArray addObject:field5];
    
    //
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label7.text = @"客户地址";
    label7.font =[UIFont systemFontOfSize:13];
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom, KscreenWidth, 1)];
    view7.backgroundColor = lineColer;
    UITextField *field7 =[[UITextField alloc]initWithFrame:CGRectMake(91, label5.bottom + 1, KscreenWidth - 100, 45)];
    field7.font =[UIFont systemFontOfSize:13];
    field7.textAlignment = NSTextAlignmentLeft;
    field7.delegate = self;
    [_linkerView addSubview:label7];
    [_linkerView addSubview:view7];
    [_linkerView addSubview:field7];
    [_kehudizhiArray addObject:field7];
    
    
    //6
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 80, 45)];
    label6.text = @"是否为主要联系人";
    label6.numberOfLines = 0;
    label6.font =[UIFont systemFontOfSize:12];
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 1)];
    view6.backgroundColor = lineColer;
    UIButton *zhuYaoLinker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zhuYaoLinker.frame = CGRectMake(91, label7.bottom +1, KscreenWidth - 100, 45);
    zhuYaoLinker.titleLabel.font = [UIFont systemFontOfSize:13];
    [zhuYaoLinker setTintColor:[UIColor grayColor]];
    zhuYaoLinker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [zhuYaoLinker addTarget:self action:@selector(YesOrNo2) forControlEvents:UIControlEventTouchUpInside];
    if (_flag1 == 1) {
        [zhuYaoLinker setTitle:@"是" forState:UIControlStateNormal];
    }else{
        [zhuYaoLinker setTitle:@"否" forState:UIControlStateNormal];
    }
    [_linkerView addSubview:label6];
    [_linkerView addSubview:view6];
    [_linkerView addSubview:zhuYaoLinker];
    [_zhuyaoLXRArray addObject:zhuYaoLinker];
    
    //
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 45)];
    tapView.backgroundColor = COLOR(220, 220, 220, 1);
    [_linkerView addSubview:tapView];
    
    UIButton *addLinker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addLinker.frame = CGRectMake(KscreenWidth - 80, 2, 80, 40);
    [addLinker setTitle:@"继续添加" forState:UIControlStateNormal];
    addLinker.titleLabel.font = [UIFont systemFontOfSize:16];
    [addLinker addTarget:self action:@selector(addLinkerView) forControlEvents:UIControlEventTouchUpInside];
    [tapView addSubview:addLinker];
    
    
    
}

#pragma mark - 业务员详情

- (void)initSalerView{
    
    for (int i = 0; i < _salerFlag; i ++) {
        NSDictionary *dic = _yewuyuanInfo[i];
        UIView  *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 135, KscreenWidth, 180)];
        salerView.backgroundColor = [UIColor whiteColor];
        [self.salerScrollView addSubview:salerView];
        [_salerViewArray addObject:salerView];
        //标题 取消按钮
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-140, 0, 280, 40)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"业务员信息";
        [salerView addSubview:titleLabel];
        //    if (_salerFlag > 1) {
        //        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        //        cancel.frame = CGRectMake(KscreenWidth - 70, 0, 60, 40);
        //        cancel.tag = 1112;
        //        [cancel setTitle:@"删除" forState:UIControlStateNormal];
        //        [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //        [cancel addTarget:self action:@selector(closeSaler) forControlEvents:UIControlEventTouchUpInside];
        //        [salerView addSubview:cancel];
        //    }
        //
        UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
        view0.backgroundColor = lineColer;
        [salerView addSubview:view0];
        //1
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 41, 80, 45)];
        label1.text = @"业务员";
        label1.font =[UIFont systemFontOfSize:14];
        UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 86, KscreenWidth, 1)];
        view1.backgroundColor = lineColer;
        [salerView addSubview:view1];
        [salerView addSubview:label1];
        UIButton *salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        salerButton.frame = CGRectMake(100, 41, KscreenWidth - 120, 45);
        salerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        salerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [salerButton setTitle:dic[@"account"] forState:UIControlStateNormal];
        [salerButton setTintColor:[UIColor blackColor]];
       // [salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
        [salerView addSubview:salerButton];
        [_salerArray addObject:salerButton];
        
         UILabel * salerIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 41, 80, 45)];
        salerIdLabel.text = [NSString stringWithFormat:@"%@",dic[@"accountid"]];
        [_salerIdArray addObject:salerIdLabel];
        
        //2
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 80, 45)];
        label2.text = @"是否主要业务员";
        label2.numberOfLines = 0;
        label2.font =[UIFont systemFontOfSize:14];
        UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 133, KscreenWidth, 1)];
        view2.backgroundColor = lineColer;
        UIButton *isMainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        isMainButton.frame = CGRectMake(100, 87, KscreenWidth - 120, 45);
        [isMainButton setTintColor:[UIColor lightGrayColor]];
        isMainButton.titleLabel.font = [UIFont systemFontOfSize:14];
        isMainButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        NSString *ismain = dic[@"ismain"];
        int m = [ismain intValue];
        if (m == 1) {
            [isMainButton setTitle:@"是" forState:UIControlStateNormal];
        }else{
            [isMainButton setTitle:@"否" forState:UIControlStateNormal];
        }
        [salerView addSubview:label2];
        [salerView addSubview:view2];
        [salerView addSubview:isMainButton];
        [_isMain addObject:isMainButton];
        //
//        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, label2.bottom + 1, KscreenWidth, 45)];
//        tapView.backgroundColor = COLOR(230, 230, 230, 1);
//        [salerView addSubview:tapView];
//        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        addButton.frame = CGRectMake(KscreenWidth - 100, 2, 80, 40);
//        addButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        [addButton setTitle:@"继续添加" forState:UIControlStateNormal];
//        [addButton addTarget:self action:@selector(addSalerView) forControlEvents:UIControlEventTouchUpInside];
//        [tapView addSubview:addButton];
        

    }
    

}

//- (void)addSalerView{
//    
//    
//    _salerFlag = _salerFlag + 1;
//    
//    _salerScrollView.contentSize = CGSizeMake(KscreenWidth , 135 * _salerFlag + 45 + 20);
//    //业务员View
//    
//    UIView  *salerView = [[UIView alloc] initWithFrame:CGRectMake(0, (_salerFlag - 1) * 135, KscreenWidth, 180)];
//    salerView.backgroundColor = [UIColor whiteColor];
//    [self.salerScrollView addSubview:salerView];
//    [_salerViewArray addObject:salerView];
//    //标题 取消按钮
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-140, 0, 280, 40)];
//    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"业务员信息";
//    [salerView addSubview:titleLabel];
//    if (_salerFlag > 1) {
//        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancel.frame = CGRectMake(KscreenWidth - 70, 0, 60, 40);
//        cancel.tag = 1112;
//        [cancel setTitle:@"删除" forState:UIControlStateNormal];
//        [cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [cancel addTarget:self action:@selector(closeSaler) forControlEvents:UIControlEventTouchUpInside];
//        [salerView addSubview:cancel];
//    }
//    //
//    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
//    view0.backgroundColor = lineColer;
//    [salerView addSubview:view0];
//    //1
//    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 41, 80, 45)];
//    label1.text = @"业务员";
//    label1.font =[UIFont systemFontOfSize:13];
//    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 86, KscreenWidth, 1)];
//    view1.backgroundColor = lineColer;
//    [salerView addSubview:view1];
//    [salerView addSubview:label1];
//    UIButton *salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    salerButton.frame = CGRectMake(100, 41, KscreenWidth - 120, 45);
//    [salerButton setTintColor:[UIColor blackColor]];
//    [salerButton addTarget:self action:@selector(salerAction) forControlEvents:UIControlEventTouchUpInside];
//    salerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [salerView addSubview:salerButton];
//    [_salerArray addObject:salerButton];
//    UILabel * salerIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 41, 80, 45)];
//    [_salerIdArray addObject:salerIdLabel];
//    
//   
//    
//    //2
//    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 80, 45)];
//    label2.text = @"是否主要业务员";
//    label2.numberOfLines = 0;
//    label2.font =[UIFont systemFontOfSize:12];
//    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 133, KscreenWidth, 1)];
//    view2.backgroundColor = lineColer;
//    UIButton *isMainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    isMainButton.frame = CGRectMake(100, 87, KscreenWidth - 120, 45);
//    
//    [isMainButton setTintColor:[UIColor lightGrayColor]];
//    [isMainButton addTarget:self action:@selector(YesOrNo) forControlEvents:UIControlEventTouchUpInside];
//    isMainButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [salerView addSubview:label2];
//    [salerView addSubview:view2];
//    [salerView addSubview:isMainButton];
//    [_isMain addObject:isMainButton];
//    
//    if (_salerFlag ==  1) {
//        [isMainButton setTitle:@"是" forState:UIControlStateNormal];
//    }else{
//        [isMainButton setTitle:@"否" forState:UIControlStateNormal];
//    }
//    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, label2.bottom + 1, KscreenWidth, 45)];
//    tapView.backgroundColor = COLOR(230, 230, 230, 1);
//    [salerView addSubview:tapView];
//    
//    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    addButton.frame = CGRectMake(KscreenWidth - 100, 2, 80, 40);
//    addButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [addButton setTitle:@"继续添加" forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(addSalerView) forControlEvents:UIControlEventTouchUpInside];
//    [tapView addSubview:addButton];
//    
//    
//    
//}


#pragma mark  - 取消按钮的点击事件
- (void)closeView
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定删除此条？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 101;
    [alert show];
    
    
    
}
- (void)closeSaler{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定删除此条？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 102;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        //联系人
        if (buttonIndex == 1) {
            //移除删掉的view中的各种信息
            [_lianxirenArray removeObjectAtIndex: _flag1 -1];
            [_shoujiArray removeObjectAtIndex:_flag1 - 1];
            [_zuojiArray removeObjectAtIndex:_flag1 - 1];
            [_QQarray removeObjectAtIndex:_flag1 - 1];
            [_youxiangArray removeObjectAtIndex:_flag1 - 1];
            [_zhuyaoLXRArray removeObjectAtIndex:_flag1 - 1];
            [_kehudizhiArray removeObjectAtIndex:_flag1 - 1];
            UIView *view = [_viewArray objectAtIndex:_flag1 - 1];
            [view removeFromSuperview];
            [_viewArray removeObjectAtIndex:_flag1 - 1];
            
            self.lianXiRenScrollview.contentSize = CGSizeMake(KscreenWidth, self.lianXiRenScrollview.contentSize.height - 180);
            _flag1 -= 1;
        }
        
    }
    if (alertView.tag == 102){
        //业务员
        if (buttonIndex == 1) {
            //移除删掉的view中的各种信息
            [_salerArray removeObjectAtIndex: _salerFlag -1];
            [_isMain removeObjectAtIndex:_salerFlag - 1];
            
            UIView *view = [_salerViewArray objectAtIndex:_salerFlag - 1];
            [view removeFromSuperview];
            [_salerViewArray removeObjectAtIndex:_salerFlag - 1];
            
            self.salerScrollView.contentSize = CGSizeMake(KscreenWidth * 2, self.salerScrollView.contentSize.height - 135);
            _salerFlag -= 1;
        }
        
        
    }
    if (alertView.tag == 103) {
        if (buttonIndex == 1) {
            //添加客户信息上传
            [self changeUpData];
        }
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1001 || textField.tag == 1002 || textField.tag == 1003) {
        UITextField *linker = _lianxirenArray[0];
        UITextField *linkerTel = _shoujiArray[0];
        UITextField *address = _kehudizhiArray[0];
        linker.text = _receiverName.text;
        linkerTel.text = _receiverTel.text;
        address.text = _receiverAdress.text;
        
    }
}

#pragma mark -——————————————————————  请求方法     --------------------------------
#pragma mark - 所属区域请求方法
- (void)areaAction{
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
    if (self.areaTableView== nil) {
        self.areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.areaTableView.backgroundColor = [UIColor grayColor];
    }
    self.areaTableView.dataSource = self;
    self.areaTableView.delegate = self;
    [bgView addSubview:self.areaTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.areaTableView reloadData];
    
}
- (void)areaRequest{
    /*
     syscate
     action:"getTree"
     table:"cate"
     catetype:"custarea"
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/syscate?action=getTree&table=cate"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"action":@"getTree",@"table":@"cate",@"catetype":@"custarea"};
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"所属区域:%@",dic);
        
        [_HUD hide:YES afterDelay:.8];
        [_HUD removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        if (errorCode == 3840|| errorCode == 1001) {
            UIAlertView *tan =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [tan show];
        }else{
            UIAlertView *tan =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [tan show];
            
        }
        NSLog(@"请求失败");
    }];
    
    
    
}
//#pragma mark -  saler
//- (void)salerAction{
//    
//    
//    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight- 64)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
//    //
//    
//    _salerField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
//    _salerField.backgroundColor = [UIColor whiteColor];
//    _salerField.delegate = self;
//    _salerField.tag =  102;
//    _salerField.placeholder = @"名称关键字";
//    _salerField.borderStyle = UITextBorderStyleRoundedRect;
//    _salerField.font = [UIFont systemFontOfSize:13];
//    [self.m_keHuPopView addSubview:_salerField];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"搜索" forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor whiteColor]];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    btn.frame = CGRectMake(_salerField.right, 40, 60, 40);
//    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
//    [btn.layer setBorderWidth:0.5]; //边框宽度
//    [btn addTarget:self action:@selector(getSalerName) forControlEvents:UIControlEventTouchUpInside];
//    [self.m_keHuPopView addSubview:btn];
//    
//    if (self.salerTableView == nil) {
//        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-154) style:UITableViewStylePlain];
//        self.salerTableView.backgroundColor = [UIColor whiteColor];
//    }
//    self.salerTableView.dataSource = self;
//    self.salerTableView.delegate = self;
//    self.salerTableView.rowHeight = 45;
//    [self.m_keHuPopView addSubview:self.salerTableView];
//    [self.view addSubview:self.m_keHuPopView];
//   
//}
//- (void)getSalerName{
//    
//    NSString *saler = _salerField.text;
//    saler = [self convertNull:saler];
//    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
//    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
//    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//        //  NSLog(@"业务员数据%@",array);
//        [_salerDataArray removeAllObjects];
//        for (NSDictionary *dic in array) {
//            CommonModel *model = [[CommonModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_salerDataArray addObject:model];
//        }
//        [self.salerTableView reloadData];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSLog(@"业务员名称加载失败");
//    }];
//    
//    
//}
//- (void)salerRequest{
//    
//    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
//    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh"};
//    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//            NSLog(@"业务员数据%@",array);
//       
//        for (NSDictionary *dic in array) {
//            CommonModel *model = [[CommonModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_salerDataArray addObject:model];
//        }
//        [self.salerTableView reloadData];
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//         NSLog(@"业务员名称加载失败");
//    }];
//    
//   
//    
//}
//

#pragma mark - 是否合作
- (void)YorN{
    
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
    if (self.YorNTableView== nil) {
        self.YorNTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.YorNTableView.backgroundColor = [UIColor grayColor];
    }
    self.YorNTableView.dataSource = self;
    self.YorNTableView.delegate = self;
    [bgView addSubview:self.YorNTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.YorNTableView reloadData];
    
}

- (void)YesOrNo{
    
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
    if (self.YorNTableView1 == nil) {
        self.YorNTableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.YorNTableView1.backgroundColor = [UIColor grayColor];
    }
    self.YorNTableView1.dataSource = self;
    self.YorNTableView1.delegate = self;
    [bgView addSubview:self.YorNTableView1];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.YorNTableView1 reloadData];
    
}

//是否私有
- (void)YesOrNo2{
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
    if (self.YorNTableView2 == nil) {
        self.YorNTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.YorNTableView2.backgroundColor = [UIColor grayColor];
    }
    self.YorNTableView2.dataSource = self;
    self.YorNTableView2.delegate = self;
    [bgView addSubview:self.YorNTableView2];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.YorNTableView2 reloadData];
    
}


#pragma mark - 资料页面请求方法
//客户性质
- (void)typeAction{
    //客户性质
    _typeButton.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor lightGrayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.typetableView == nil) {
        self.typetableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.typetableView.backgroundColor = [UIColor whiteColor];
    }
    self.typetableView.dataSource = self;
    self.typetableView.delegate = self;
    [bgView addSubview:self.typetableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.typetableView reloadData];
}
- (void)classAction{
    //行业分类
    _classButton.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    //
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
    if (self.classtableView == nil) {
        self.classtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.classtableView.backgroundColor = [UIColor grayColor];
    }
    self.classtableView.dataSource = self;
    self.classtableView.delegate = self;
    [bgView addSubview:self.classtableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.classtableView reloadData];
    
    
}
- (void)kehujibie{
    
    _custStatusBtn.userInteractionEnabled = NO;
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
    if (self.jibietableView == nil) {
        self.jibietableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.jibietableView.backgroundColor = [UIColor grayColor];
    }
    self.jibietableView.dataSource = self;
    self.jibietableView.delegate = self;
    [bgView addSubview:self.jibietableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.jibietableView reloadData];
    
    
}
- (void)closePop{
    [self.m_keHuPopView removeFromSuperview];
    _typeButton.userInteractionEnabled = YES;
    _classButton.userInteractionEnabled = YES;
    _province.userInteractionEnabled = YES;
    _city.userInteractionEnabled = YES;
    _county.userInteractionEnabled = YES;
}
#pragma mark - 时间
- (void)dateAction {
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0,0, KscreenWidth, KscreenHeight)];
//    _timeView.backgroundColor = [UIColor grayColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, KscreenWidth, 270)];//(0,_dateButton.bottom, KscreenWidth, 270)
    bgView.backgroundColor = [UIColor grayColor];
    [_timeView addSubview:bgView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40, KscreenWidth, 230)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 40)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
//    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];

}
- (void)closetime{
    [_timeView removeFromSuperview];
}
//监听datePicker值发生变化
-(void)dateChange1:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
}
- (void)date2Action{
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0,0, KscreenWidth, KscreenHeight)];
//    _timeView.backgroundColor = [UIColor grayColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, KscreenWidth, 270)];//(0,_dateButton.bottom, KscreenWidth, 270)
    bgView.backgroundColor = [UIColor grayColor];
    [_timeView addSubview:bgView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40, KscreenWidth,230)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 40)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange2:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
//    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}

//监听datePicker值发生变化
-(void)dateChange2:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_date2Button setTitle:dateString forState:UIControlStateNormal];
}

#pragma mark - 省市县
- (void)KHprovince
{
    _province.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    //
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
    if (self.provincetableView == nil) {
        self.provincetableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.provincetableView.backgroundColor = [UIColor grayColor];
    }
    self.provincetableView.dataSource = self;
    self.provincetableView.delegate = self;
    [bgView addSubview:self.provincetableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self suozaishengRequest];
    [self.provincetableView reloadData];
    
}

- (void)KHcity
{
    //市
    
    _city.userInteractionEnabled = NO;
    
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
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.citytableView == nil) {
        self.citytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.citytableView.backgroundColor = [UIColor grayColor];
    }
    self.citytableView.dataSource = self;
    self.citytableView.delegate = self;
    [bgView addSubview:self.citytableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self suozaishiRequest];
    [self.citytableView reloadData];
}

- (void)KHcounty
{   //县
    _county.userInteractionEnabled = NO;
   
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
    if (self.countytableView == nil) {
        self.countytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.countytableView.backgroundColor = [UIColor grayColor];
    }
    self.countytableView.dataSource = self;
    self.countytableView.delegate = self;
    [bgView addSubview:self.countytableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self suozaixianRequest];
    [self.countytableView reloadData];
}

- (void)suozaishengRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =@"action=getProvince&params={\"newinfo\":\"true\"}&table=xzqy";
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        self.shengArr = [NSMutableArray array];
        for (NSDictionary *dic  in array) {
            ProvinceModel *model = [[ProvinceModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.shengArr addObject:model];
        }
       
        NSLog(@"省数据%@",self.shengArr);
    }
    
    
}

- (void)suozaishiRequest
{
    if (_provinceId != nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
        NSURL *url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"parentid=%@&action=getCity&params={\"newinfo\":\"true\"}&table=xzqy",_provinceId];
        
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data1 != nil) {
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            self.shiArr = [NSMutableArray array];
            
            for (NSDictionary *dic  in array ) {
                ProvinceModel *model  =  [[ProvinceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.shiArr addObject:model];
            }
        }
    }
}
- (void)suozaixianRequest
{
    if (_cityId != nil) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
        [request setHTTPMethod:@"POST"];
        NSString *str =[NSString stringWithFormat:@"parentid=%@&action=getCounties&params={\"newinfo\":\"true\"}&table=xzqy",_cityId];
        
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(data1 != nil){
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            
            self.xianArr = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                ProvinceModel *model = [[ProvinceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.xianArr addObject:model];
            }
        }

    }
    
    
}

#pragma mark - 客户属性
- (void)kehujibieRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =@"action=getSelectType&type=manageclass";
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        
        self.genZongJiBeiArr = [[NSMutableArray alloc] init];
        self.genZongJiBeiIdArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++) {
            NSString * str = array[i][@"name"];
            NSString *jibieId = array[i][@"id"];
            [self.genZongJiBeiArr addObject:str];
            [self.genZongJiBeiIdArr addObject:jibieId];
        }
        if (_custStatusBtn.titleLabel.text.length == 0) {
            NSString *genzongjibie = [NSString stringWithFormat:@"%@",array[0][@"name"]];
            [ _custStatusBtn setTitle:genzongjibie forState:UIControlStateNormal];
            _tracelevel = genzongjibie;
            _tracelevelid = [NSString stringWithFormat:@"%@",array[0][@"id"]];
        }
    }
}

//- (void)kehuxingzhiRequest
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
//    NSURL *url =[NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = @"action=getSelectType&type=customertype";
//    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
//        NSLog(@"客户性质点击返回:%@",array);
//        self.keHuXingZhiArr = [[NSMutableArray alloc] init];
//        self.keHuXingZhiIDArr = [[NSMutableArray alloc] init];
//        for (int i = 0; i < array.count; i++) {
//            NSString * str = array[i][@"name"];
//            NSString *xingzhiID = array[i][@"id"];
//            [self.keHuXingZhiArr addObject:str];
//            [self.keHuXingZhiIDArr addObject:xingzhiID];
//        }
//        if (array.count != 0) {
//            NSString *kehuxingzhi = [NSString stringWithFormat:@"%@",array[0][@"name"]];
//            [_typeButton setTitle:kehuxingzhi forState:UIControlStateNormal];
//            
//            _typeid = [NSString stringWithFormat:@"%@",array[0][@"id"]];
//            
//        }
//    }
//    
//}

- (void)hangyefenleiRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/syscate"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getSelectForMobile&params={\"type\":\"customerclassify\"}";
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        self.hangyefenleiArr = [[NSMutableArray alloc] init];
        self.hangyefenleiIdArr = [[NSMutableArray alloc] init];
        NSLog(@"分类点击返回:%@",array);
        for (int i = 0; i < array.count; i++) {
            NSString * str = array[i][@"name"];
            NSString *kehufenLeiId = array[i][@"id"];
            [self.hangyefenleiIdArr addObject:kehufenLeiId];
            [self.hangyefenleiArr addObject:str];
        }
        if (_classButton.titleLabel.text.length  == 0) {
            NSString *kehuleixing = [NSString stringWithFormat:@"%@",array[0][@"name"]];
            [_classButton setTitle:kehuleixing forState:UIControlStateNormal];
            NSLog(@"行业分类%@",kehuleixing);
            _classname = kehuleixing;
            _classid = [NSString stringWithFormat:@"%@",array[0][@"id"]];
        }
        
    }
    
}


- (void)selectBtn:(UIButton *)btn
{
    if (btn != _currentBtn)
    {
        _currentBtn.selected = NO;
        _currentBtn = btn;
    }
    _currentBtn.selected = YES;
    [self.mainScrollView setContentOffset:CGPointMake(btn.tag * KscreenWidth, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //随着整页滑动的相关栏目的变色及移动  对应起来好看！
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    } else {
        int i = scrollView.contentOffset.x/KscreenWidth;
        if (scrollView.contentOffset.x || (_startcontentOffsetX != scrollView.contentOffset.x)) {   //将竖着滑动排除在外
            for (int j = 0; j < _btnArray.count; j++) {
                if (j == i) {
                    if (_btnArray[i] != _currentBtn) {
                        _currentBtn.selected = NO;
                        _currentBtn = _btnArray[i];
                    }
                    _currentBtn.selected = YES;
                }
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _startcontentOffsetX = scrollView.contentOffset.x;
}
#pragma mark - 业务员请求
- (void)yewuyuanRequest
{
    //客户业务员的信息
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
//    NSString *ID = _model.Id;
//    NSDictionary *params = @{@"action":@"toUpdateCust",@"table":@"khfzr",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\"}",ID]};
//    NSLog(@"上传字典%@",params);
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
//        NSLog(@"业务元信息详情%@",array);
//        _salerFlag = array.count;
//        _yewuyuanInfo = array;
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        NSInteger errorCode = error.code;
//        [self showAlert:[NSString stringWithFormat:@"连接服务器失败，错误码%zi",errorCode]];
//
//    }];
    
    NSString *urlStr = [NSString  stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"mobile=true&action=toUpdateCust&params={\"idEQ\":\"%@\"}&table=khfzr",_model.Id];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSLog(@"业务元信息详情%@",array);
        _salerFlag = array.count;
        _yewuyuanInfo = array;
    }else{
    
       // [self showAlert:@"业务员信息加载失败"];
    }
}
#pragma mark - 物流详情请求
- (void)requestWuliuInfo
{
    //物流信息
    NSString *urlStr = [NSString  stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"mobile=true&action=getCustLogs&params={\"idEQ\":\"%@\"}&table=khwlxx",_model.Id];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        _wuliuInfo = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
       // [self.wuLiuTableView reloadData];
        NSLog(@"客户物流信息:%@",_wuliuInfo);
    }
    
}
#pragma mark - 联系人详情请求
- (void)requestLinkerInfo
{
    //客户管理联系人的接口
    
    NSString *urlStr = [NSString  stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
//    NSDictionary *params = @{@"action":@"toUpdateCust",@"table":@"khlxr",@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\"}",_model.Id]};
//    NSLog(@"上传字典%@",params);
//    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        _linkerInfo = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
//        for (NSDictionary *dic in _linkerInfo) {
//            LinkerModel *model = [[LinkerModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_linkerDataArray addObject:model];
//        }
//        _flag1 = _linkerDataArray.count;
//    
//        NSLog(@"个数%zi",_flag1);
//        NSLog(@"客户联系人:%@",_linkerInfo);
//    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
//        
//        NSInteger errorCode = error.code;
//        [self showAlert:[NSString stringWithFormat:@"连接服务器失败，错误码%zi",errorCode]];
//    }];
//    
    

    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"mobile=true&action=toUpdateCust&params={\"idEQ\":\"%@\"}&table=khlxr",_model.Id];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        _linkerInfo = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        for (NSDictionary *dic in _linkerInfo) {
            LinkerModel *model = [[LinkerModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_linkerDataArray addObject:model];
        }
        _flag1 = _linkerDataArray.count;
        NSLog(@"个数%zi",_flag1);
        NSLog(@"客户联系人:%@",_linkerInfo);
    }
    
}


#pragma mark-UITableViewDelegateAndDataSource协议方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.jibietableView){
        return _genZongJiBeiArr.count;
    }else if(tableView == self.classtableView){
        return _hangyefenleiArr.count;
    }else if (tableView == self.typetableView){
        return _keHuXingZhiArr.count;
    }else if(tableView == self.YorNTableView){
        return _YNArray.count;
    }else if(tableView == self.YorNTableView2){
        return _YNArray.count;
    }else if(tableView == self.provincetableView){
        return self.shengArr.count;
    }else if(tableView == self.citytableView){
        return self.shiArr.count;
    }else if(tableView == self.countytableView){
        return self.xianArr.count;
    }else if (tableView == self.salerScrollView){
        return _salerDataArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor grayColor];
    }
    
     if(tableView == self.classtableView){
        NSString *class = _hangyefenleiArr[indexPath.row];
        cell.textLabel.text = class;
        return cell;
    }else if(tableView == self.typetableView){
        NSString *type = _keHuXingZhiArr[indexPath.row];
        cell.textLabel.text = type;
        return cell;
    }else if(tableView == self.jibietableView){
        NSString *jibie = _genZongJiBeiArr[indexPath.row];
        cell.textLabel.text = jibie;
        return cell;
    }else if(tableView == self.YorNTableView){
        NSString *teamwork = _YNArray[indexPath.row];
        cell.textLabel.text = teamwork;
        return cell;
    }else if(tableView == self.YorNTableView2){
        NSString *private = _YNArray[indexPath.row];
        cell.textLabel.text = private;
        return cell;
    }else if(tableView == self.provincetableView){
        ProvinceModel *model = self.shengArr[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else if(tableView == self.citytableView){
        ProvinceModel *model = self.shiArr[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else if(tableView == self.countytableView){
        ProvinceModel *model = self.xianArr[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }else if(tableView == self.salerTableView){
        CommonModel *model = _salerDataArray[indexPath.row];
        cell.textLabel.text = model.name;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.m_keHuPopView removeFromSuperview];

    if(tableView == self.classtableView){
        NSString *class = _hangyefenleiArr[indexPath.row];
        [_classButton setTitle:class forState:UIControlStateNormal];
        _classid = _hangyefenleiIdArr[indexPath.row];
        
    }else if(tableView == self.typetableView){
        NSString *type = _keHuXingZhiArr[indexPath.row];
        [_typeButton setTitle:type forState:UIControlStateNormal];
        _typeid = _keHuXingZhiIDArr[indexPath.row];
        
    }else if(tableView == self.jibietableView){
        NSString *jibie = _genZongJiBeiArr[indexPath.row];
        [_custStatusBtn setTitle:jibie forState:UIControlStateNormal];
        _tracelevelid = _genZongJiBeiIdArr[indexPath.row];
        
    }else if(tableView == self.YorNTableView){
        NSString *teamwork = _YNArray[indexPath.row];
        [_teamWork setTitle:teamwork forState:UIControlStateNormal];
        
    }else if(tableView == self.YorNTableView2){
        NSString *main = _YNArray[indexPath.row];
        UIButton *btn = [_zhuyaoLXRArray objectAtIndex:_flag1 - 1];
        [btn setTitle:main forState:UIControlStateNormal];
        
    }else if(tableView == self.provincetableView){
        ProvinceModel *model = self.shengArr[indexPath.row];
        [_province setTitle:model.name forState:UIControlStateNormal];
        _provinceId = [NSString stringWithFormat:@"%@",model.placeid];
        _province.userInteractionEnabled = YES;
    }else if(tableView == self.citytableView){
        ProvinceModel *model = self.shiArr[indexPath.row];
        [_city setTitle:model.name forState:UIControlStateNormal];
        _cityId = [NSString stringWithFormat:@"%@",model.placeid];
        _city.userInteractionEnabled = YES;
    }else if(tableView == self.countytableView){
        ProvinceModel *model = self.xianArr[indexPath.row];
        [_county setTitle:model.name forState:UIControlStateNormal];
        _countyId =  [NSString stringWithFormat:@"%@",model.placeid];
        _county.userInteractionEnabled = YES;
    
    }else if (tableView == self.salerTableView) {
        CommonModel *model = _salerDataArray[indexPath.row];
        UIButton *saler = _salerArray[_salerFlag - 1];
        UILabel *salerId = _salerIdArray[_salerFlag - 1];
        [saler setTitle:model.name forState:UIControlStateNormal];
        salerId.text = model.Id;
        
    }
 


 
}


- (void)seeLocation:(UITapGestureRecognizer *)tap
{
    SeeLocationViewController *location = [[SeeLocationViewController alloc] init];
    if (_logtitude.length > 4 && _latitude.length > 4) {
        location.longtitude = _logtitude;
        location.latitude = _latitude;
       [self.navigationController pushViewController:location animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该客户暂无位置信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)gotoThere:(UITapGestureRecognizer *)tap
{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //指定导航类型
    para.naviType = BMK_NAVI_TYPE_NATIVE;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    CLLocationCoordinate2D coor;
    coor.latitude = [_latitude floatValue];
    coor.longitude = [_logtitude floatValue];
    end.pt = coor;
    //指定终点名称
    end.name = @"客户";
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView ==self.classtableView||tableView == self.typetableView || tableView == self.jibietableView||tableView == self.YorNTableView ||tableView == self.YorNTableView2 ||tableView == self.YorNTableView1||tableView == self.provincetableView||tableView == self.citytableView||tableView == self.countytableView||tableView == self.salerTableView){
        return 45;
    }
    
    return 837;
}
#pragma mark - 修改按钮的点击方法
- (void)xiugaiKehu
{
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 20);
    [AddButton setTitle:@"确定" forState:UIControlStateNormal];
    [AddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(tijiaoXiugai) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;
    
    
    //资料
    _backView.userInteractionEnabled = YES;
    //业务员
    _linkerView.userInteractionEnabled = YES;
    [self requestdata];
    [self kehujibieRequest];
    //[self kehuxingzhiRequest];
    [self hangyefenleiRequest];
    [self suozaishengRequest ];
    //[self salerRequest];
    
}
#pragma mark - 修改信息上传方法
- (void)changeUpData{
    NSString *cellID = _model.Id;
    //资料
    NSString *privateStr = _private.titleLabel.text;
    if ([privateStr isEqualToString:@"是"]) {
        _isprivate = @"1";
    } else {
        _isprivate = @"0";
    }
    NSString *teamWorkStr = _teamWork.titleLabel.text;
    if ([teamWorkStr isEqualToString:@"是"]) {
        _isteamwork = @"1";
    }else{
        _isteamwork = @"0";
    }
    NSString *name = _cust.text;
    NSString *recelveAdd= _receiverAdress.text;
    recelveAdd = [self convertNull:recelveAdd];
    NSString *receiveCell = _receiverTel.text;
    receiveCell = [self convertNull:receiveCell];
    NSString *receiveName = _receiverName.text;
    receiveName = [self convertNull:receiveName];
    NSString *class = _classButton.titleLabel.text;
    class = [self convertNull:class];
    NSString *tracelevel = _custStatusBtn.titleLabel.text;
    tracelevel = [self convertNull:tracelevel];
    NSString *helpNo = _companyName.text;
    helpNo = [self convertNull:helpNo];
    NSString *note = _note.text;
    note = [self convertNull:note];
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"action=update&mobile=true&table＝khxx&data={\"helpno\":\"%@\",\"note\":\"%@\",\"estabtime\":\"\",\"id\":\"%@\",\"name\":\"%@\",\"tracelevel\":\"%@\",\"receiveaddr\":\"%@\",\"classid\":\"%@\",\"receivername\":\"%@\",\"classname\":\"%@\",\"receivercell\":\"%@\",\"businesstime\":\"\",\"table\":\"khxx\",\"tracelevelid\":\"%@\",\"province\":\"%@\",\"city\":\"%@\",\"county\":\"%@\",}",helpNo,note,cellID,name,tracelevel,recelveAdd,_classid,receiveName,class,receiveCell,_tracelevelid,_provinceId,_cityId,_countyId];
    //拼接联系人字符串
    
    NSMutableString *linkStr = [NSMutableString stringWithFormat:@"\"linkerList\":[],"];
    for (int i = 0; i < _flag1; i++) {
        
        UITextField *lianxiren = [_lianxirenArray objectAtIndex:i];
        UITextField *QQ = [_QQarray objectAtIndex:i];
        UITextField *shouji = [_shoujiArray objectAtIndex:i];
        UITextField *zuoji = [_zuojiArray objectAtIndex:i];
        UITextField *youxiang = [_youxiangArray objectAtIndex:i];
        UIButton *zhuyaoLXR = [_zhuyaoLXRArray objectAtIndex:i];
        UITextField *address = [_kehudizhiArray objectAtIndex:i];
        
        NSString *str = zhuyaoLXR.titleLabel.text;
        NSString *ismain;
        if (str.length == 0) {
            ismain =   [self deFault:str];
        }else if(str.length != 0){
            if ([str isEqualToString:@"是"]) {
                ismain = @"1";
            }else if([str isEqualToString:@"否"]){
                ismain = @"0";
            }
            
        }
        
        
        
        [linkStr insertString:[NSString stringWithFormat:@"{\"linker\":\"%@\",\"birthday\":\"\",\"fax\":\"1\",\"native\":\"1\",\"email\":\"%@\",\"duty\":\"1\",\"ismain\":\"%@\",\"telno\":\"%@\",\"hobby\":\"1\",\"table\":\"khlxr\",\"micromsg\":\"1\",\"qq\":\"%@\",\"cellno\":\"%@\",\"address\":\"%@\"},",lianxiren.text,youxiang.text,ismain,zuoji.text,QQ.text,shouji.text,address.text] atIndex:linkStr.length - 2];
    }
    [linkStr deleteCharactersInRange:NSMakeRange(linkStr.length - 3, 1)];
    [str insertString:[NSString stringWithFormat:@"%@",linkStr] atIndex:str.length-1];
    //拼接业务员
    
    NSMutableString *salerStr = [NSMutableString stringWithFormat:@"\"salerList\":[]"];
    for (int i = 0; i < _salerFlag; i++) {
        
        UIButton *salerButton = [_salerArray objectAtIndex:i];
        NSString *saler = salerButton.titleLabel.text;
        saler = [self convertNull:saler];
        UILabel *label = [_salerIdArray objectAtIndex:i];
        NSString *salerId = label.text;
        salerId = [self convertNull:salerId];
        
        UIButton *ismainButton = [_isMain objectAtIndex:i];
        NSString *ismain = ismainButton.titleLabel.text;
        ismain = [self convertNull:ismain];
        NSString *mainStr;
        if ([ismain isEqualToString:@"是"]) {
            mainStr = @"1";
        }else if ([ismain isEqualToString:@"否"]){
            mainStr = @"0";
            
        }
        
        
        
        [salerStr insertString:[NSString stringWithFormat:@"{\"account\":\"%@\",\"accountid\":\"%@\",\"ismain\":\"%@\",\"table\":\"khfzr\"},",saler,salerId,mainStr] atIndex:salerStr.length - 1];
    }
    [salerStr deleteCharactersInRange:NSMakeRange(salerStr.length - 2, 1)];
    
    [str insertString:[NSString stringWithFormat:@"%@",salerStr] atIndex:str.length-1];
    
    
    
    NSLog(@"修改字符串:%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"客户修改返回:%@",str1);
    if (str1.length != 0) {
        
        NSRange range = {1,str1.length-2};
        NSString *reallystr = [str1 substringWithRange:range];
        if ([reallystr isEqualToString:@"true"]) {
            [self showAlert:@"客户信息修改成功!"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newCust" object:self];
            
        } else {
            
            [self showAlert:@"客户信息修改失败!"];
        }
    }

}


- (void)tijiaoXiugai
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定修改?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    
    alert.tag = 103;
    [alert show];
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
// 默认为1
-(NSString*)deFault:(id)object{
    
    // 转换空为1
    
    if ([object isEqual:[NSNull null]]) {
        return @"1";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"1";
    }
    else if (object==nil){
        return @"1";
    }
    return object;
    
}

@end
