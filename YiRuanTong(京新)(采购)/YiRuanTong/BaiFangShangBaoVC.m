//
//  BaiFangShangBaoVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/10.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaiFangShangBaoVC.h"
#import "KeHuBFViewController.h"
#import "MBProgressHUD.h"
#import "KHnameModel.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"
#import "DataPost.h"
#import "CustCell.h"
#define lineColor  COLOR(240, 240, 240, 1);
@interface BaiFangShangBaoVC ()
{
    MBProgressHUD *_hud;
    UIView *_timeView;
    NSMutableArray *_dataArray;
    NSMutableArray *_genZongJiBieIdArr;
    NSInteger _page;
    MBProgressHUD *_HUD;
    UIButton* _hide_keHuPopViewBut;
    
    UILabel *_lianXiRen1;
    UILabel *_lianXiShouJi1;
    UILabel *_lianXiDianHua1;
    UILabel *_lianXiYouXiang1;
    UILabel *_keHuDiZhi1;
    UILabel *_quYuSheng1;
    UILabel *_quYuShi1;
    UILabel *_quYuXian1;
    NSString *_currentDateStr;// 取得当前时间
    NSString *_custId;
    NSString *_tracelevelId;
    
    UITextField *_custField;//客户名称搜索输入
}

@property (strong,nonatomic) NSMutableArray * genZongJiBieArr;
@property(nonatomic,retain)UITableView *nameTableView;
@property(nonatomic,retain)UITableView *genZongJiBieTableView;

@property (nonatomic) int ISCLICKWHERE;

@end
 
@implementation BaiFangShangBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _genZongJiBieIdArr = [NSMutableArray array];
    _page = 1;
    self.title = @"拜访上报";
    
    //添加按钮
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [AddButton setTitle:@"提交" forState:UIControlStateNormal];
    [AddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(baifangShangbao) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
     [self initView];
    [self genZongJiBieRequest];
    [self nameRequest];
    

    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    [self.m_baiFangTimeButton setTitle:_currentDateStr forState:UIControlStateNormal];
}
#pragma mark - 客户联系人

- (void)getLinker{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSDictionary *params = @{@"action":@"getLinker",@"table":@"khlxr",@"data":[NSString stringWithFormat:@"{\"custidEQ\":\"%@\"}",_custId]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"联系人%@",array);
        if (array.count > 0) {
            self.m_lianXiRen = array[0][@"linker"];
            self.m_lianXiShouJi = array[0][@"cellno"];
            self.m_lianXiDianHua = array[0][@"telno"];
            self.m_lianXiYouXiang = array[0][@"email"];
        }
        _lianXiRen1.text = [NSString stringWithFormat:@"%@ | %@ | %@",self.m_lianXiRen,self.m_lianXiShouJi,self.m_lianXiDianHua];
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

- (void)getCustInfo{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSDictionary *params = @{@"action":@"getCustInfo",@"table":@"khlxr",@"data":[NSString stringWithFormat:@"{\"custidEQ\":\"%@\"}",_custId]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户详情%@",array);
        if (array.count != 0) {
            NSString *tracelevel = array[0][@"tracelevel"];
            NSString *tracelevelId = array[0][@"tracelevelid"];
            [self.m_genZongJiBieButton setTitle:tracelevel forState:UIControlStateNormal];
            _tracelevelId = tracelevelId;
        }
        

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else if(errorCode == -1004){
            
            [self showAlert:@"未检测到网络，请检查网络连接!"];
        }else{
        
        }

    }];



}

#pragma mark --------------------------------页面----------------------------------------
- (void)initView
{
    self.bf_ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 46)];
    self.bf_ScrollView.contentSize = CGSizeMake(KscreenWidth, 540);
    self.bf_ScrollView.bounces= NO;
    self.bf_ScrollView.backgroundColor =[UIColor clearColor];
    self.bf_ScrollView.delegate = self;
    [self.view addSubview:self.bf_ScrollView];
    //页面设置
    UILabel * keHuNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 45)];
    keHuNameLabel.text = @"客户名称*";
    keHuNameLabel.font =[UIFont systemFontOfSize:13];
    UIView *keHuNameView =[[UIView alloc]initWithFrame:CGRectMake(0, keHuNameLabel.bottom, KscreenWidth, 1)];
    keHuNameView.backgroundColor = lineColor
    [self.bf_ScrollView addSubview:keHuNameView];
    [self.bf_ScrollView addSubview:keHuNameLabel];
    
    self.m_keHuNameButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 0, KscreenWidth - 100, 45)];
    self.m_keHuNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.m_keHuNameButton setTitle:_model.name forState:UIControlStateNormal];
    [self.m_keHuNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.m_keHuNameButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.m_keHuNameButton addTarget:self action:@selector(m_keHuNameButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.bf_ScrollView addSubview:self.m_keHuNameButton];
    if (_setModel.custname.length  == 0) {
        [self.m_keHuNameButton setTitle:@"请选择客户" forState:UIControlStateNormal];

    }else{
         [self.m_keHuNameButton setTitle:_setModel.custname forState:UIControlStateNormal];
        _custId = _setModel.custid;
    }
    
    
    UILabel * lianXiRenLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, keHuNameLabel.bottom + 1, 80, 45)];
    lianXiRenLabel.text = @"联系人";
    lianXiRenLabel.font =[UIFont systemFontOfSize:13];
    UIView *lianXiRenView =[[UIView alloc]initWithFrame:CGRectMake(0, lianXiRenLabel.bottom, KscreenWidth, 1)];
    lianXiRenView.backgroundColor = lineColor;
    _lianXiRen1 =[[UILabel alloc]initWithFrame:CGRectMake(90, keHuNameLabel.bottom + 1, KscreenWidth - 100, 45)];
    _lianXiRen1.font =[UIFont systemFontOfSize:13];
    _lianXiRen1.textColor = [UIColor grayColor];
    _lianXiRen1.textAlignment = NSTextAlignmentLeft;
    [self.bf_ScrollView addSubview:_lianXiRen1];
    [self.bf_ScrollView addSubview:lianXiRenView];
    [self.bf_ScrollView addSubview:lianXiRenLabel];
   
    if (_setModel.linker.length  != 0) {
        _lianXiRen1.text = [NSString stringWithFormat:@"%@ | %@",_setModel.linker,_setModel.cellno];
    }
//    UILabel * lianXiShouJiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, lianXiRenLabel.bottom + 1, 80, 45)];
//    lianXiShouJiLabel.text = @"联系手机";
//    lianXiShouJiLabel.font =[UIFont systemFontOfSize:13];
//    UIView *lianXiShouJiView =[[UIView alloc]initWithFrame:CGRectMake(0, lianXiShouJiLabel.bottom, KscreenWidth, 1)];
//    lianXiShouJiView.backgroundColor = lineColor;
//    _lianXiShouJi1 =[[UILabel alloc]initWithFrame:CGRectMake(90, lianXiRenLabel.bottom + 1, KscreenWidth - 100, 45)];
//    _lianXiShouJi1.font =[UIFont systemFontOfSize:13];
//    [self.bf_ScrollView addSubview:_lianXiShouJi1];
//    [self.bf_ScrollView addSubview:lianXiShouJiView];
//    [self.bf_ScrollView addSubview:lianXiShouJiLabel];
//    
//    //
//    UILabel * lianXiDianHuaLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, lianXiShouJiLabel.bottom + 1, 80, 45)];
//    lianXiDianHuaLabel.text = @"联系电话";
//    lianXiDianHuaLabel.font =[UIFont systemFontOfSize:13];
//    UIView *lianXiDianHuaView =[[UIView alloc]initWithFrame:CGRectMake(0, lianXiDianHuaLabel.bottom, KscreenWidth, 1)];
//    lianXiDianHuaView.backgroundColor = lineColor;
//    _lianXiDianHua1 =[[UILabel alloc]initWithFrame:CGRectMake(90, lianXiShouJiLabel.bottom + 1, KscreenWidth - 100, 45)];
//    _lianXiDianHua1.font =[UIFont systemFontOfSize:13];
//    
//    [self.bf_ScrollView addSubview:_lianXiDianHua1];
//
//    [self.bf_ScrollView addSubview:lianXiDianHuaView];
//    [self.bf_ScrollView addSubview:lianXiDianHuaLabel];
    
    
//    UILabel * lianXiYouXiangLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, lianXiDianHuaLabel.bottom + 1, 80, 45)];
//    lianXiYouXiangLabel.text = @"联系邮箱";
//    lianXiYouXiangLabel.font =[UIFont systemFontOfSize:13];
//    UIView *lianXiYouXiangView =[[UIView alloc]initWithFrame:CGRectMake(0, lianXiYouXiangLabel.bottom, KscreenWidth, 1)];
//    lianXiYouXiangView.backgroundColor = lineColor;
//    _lianXiYouXiang1 =[[UILabel alloc]initWithFrame:CGRectMake(90, lianXiDianHuaLabel.bottom + 1, KscreenWidth - 100, 45)];
//    _lianXiYouXiang1.font =[UIFont systemFontOfSize:13];
//    [self.bf_ScrollView addSubview:_lianXiYouXiang1];
//    [self.bf_ScrollView addSubview:lianXiYouXiangView];
//    [self.bf_ScrollView addSubview:lianXiYouXiangLabel];
    
    
    UILabel * keHuDiZhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, lianXiRenLabel.bottom + 1, 80, 45)];
    keHuDiZhiLabel.text = @"客户地址";
    keHuDiZhiLabel.font =[UIFont systemFontOfSize:13];
    UIView *keHuDiZhiView =[[UIView alloc]initWithFrame:CGRectMake(0, keHuDiZhiLabel.bottom, KscreenWidth, 1)];
    keHuDiZhiView.backgroundColor = lineColor;
    _keHuDiZhi1 =[[UILabel alloc]initWithFrame:CGRectMake(90, lianXiRenLabel.bottom + 1, KscreenWidth - 100, 45)];
    _keHuDiZhi1.font = [UIFont systemFontOfSize:13];
    _keHuDiZhi1.textColor = [UIColor grayColor];
    _keHuDiZhi1.textAlignment = NSTextAlignmentLeft;
    [self.bf_ScrollView addSubview:_keHuDiZhi1];
    [self.bf_ScrollView addSubview:keHuDiZhiView];
    [self.bf_ScrollView addSubview:keHuDiZhiLabel];
    if (_setModel.address.length   != 0) {
        _keHuDiZhi1.text = _setModel.address;
    }
    
    
    UILabel * baiFangTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, keHuDiZhiLabel.bottom + 1, 80, 45)];
    baiFangTimeLabel.text = @"拜访日期";
    baiFangTimeLabel.font =[UIFont systemFontOfSize:13];
    UIView *baiFangTimeView =[[UIView alloc]initWithFrame:CGRectMake(0, baiFangTimeLabel.bottom, KscreenWidth, 1)];
    baiFangTimeView.backgroundColor = lineColor;
    [self.bf_ScrollView addSubview:baiFangTimeView];
    [self.bf_ScrollView addSubview:baiFangTimeLabel];
    
    self.m_baiFangTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(90, keHuDiZhiLabel.bottom + 1, KscreenWidth - 100, 45)];
    self.m_baiFangTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.m_baiFangTimeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.m_baiFangTimeButton.titleLabel  setFont:[UIFont systemFontOfSize:13]];
    [self.m_baiFangTimeButton setTitle:_currentDateStr forState:UIControlStateNormal];
    [self.m_baiFangTimeButton addTarget:self action:@selector(baiFangTimeButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.bf_ScrollView addSubview:self.m_baiFangTimeButton];
    
    //
    UILabel * genZongJiBieLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, baiFangTimeLabel.bottom + 1, 80, 45)];
    genZongJiBieLabel.text = @"客户状态";
    genZongJiBieLabel.font =[UIFont systemFontOfSize:13];
    UIView *genZongJiBieView=[[UIView alloc]initWithFrame:CGRectMake(0, genZongJiBieLabel.bottom, KscreenWidth, 1)];
    genZongJiBieView.backgroundColor = lineColor;
    [self.bf_ScrollView addSubview:genZongJiBieView];
    [self.bf_ScrollView addSubview:genZongJiBieLabel];
    
    self.m_genZongJiBieButton = [[UIButton alloc]initWithFrame:CGRectMake(90, baiFangTimeLabel.bottom + 1, KscreenWidth - 100, 45)];
    self.m_genZongJiBieButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.m_genZongJiBieButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.m_genZongJiBieButton setTitle:_model.tracelevel forState:UIControlStateNormal];
    [self.m_genZongJiBieButton.titleLabel  setFont:[UIFont systemFontOfSize:13]];
    [self.m_genZongJiBieButton addTarget:self action:@selector(m_genZongJiBieButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.bf_ScrollView addSubview:self.m_genZongJiBieButton];
    if (_setModel.tracelevel.length  != 0) {
        [self.m_genZongJiBieButton setTitle:_setModel.tracelevel forState:UIControlStateNormal];
        _tracelevelId = _setModel.tracelevelid;
    }
    //
    UILabel * yuQiMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, genZongJiBieLabel.bottom + 1, 90, 45)];
    yuQiMoneyLabel.text = @"预期成交金额*";
    yuQiMoneyLabel.font = [UIFont systemFontOfSize:13];
    UIView *yuQiMoneyView = [[UIView alloc]initWithFrame:CGRectMake(0, yuQiMoneyLabel.bottom, KscreenWidth, 1)];
    yuQiMoneyView.backgroundColor = lineColor;
    [self.bf_ScrollView addSubview:yuQiMoneyView];
    [self.bf_ScrollView addSubview:yuQiMoneyLabel];
    self.m_yuqiMoney =[[UITextField alloc]initWithFrame:CGRectMake(90, genZongJiBieLabel.bottom + 1, KscreenWidth - 130, 45)];
    self.m_yuqiMoney.font =[UIFont systemFontOfSize:13];
    self.m_yuqiMoney.textAlignment = NSTextAlignmentLeft;
    self.m_yuqiMoney.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.m_yuqiMoney.textColor = [UIColor grayColor];
    self.m_yuqiMoney.placeholder = @"请输入金额（必填）";
    
    [self.bf_ScrollView  addSubview:self.m_yuqiMoney];
    UILabel *danWeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth - 25, genZongJiBieLabel.bottom + 1, 20, 45)];
    danWeiLabel.text = @"万";
    danWeiLabel.font = [UIFont systemFontOfSize:13];
    [self.bf_ScrollView addSubview:danWeiLabel];
    
    UILabel * baiFangMuDiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, yuQiMoneyLabel.bottom + 1, 80, 45)];
    baiFangMuDiLabel.text = @"拜访目的*";
    baiFangMuDiLabel.font =[UIFont systemFontOfSize:13];
    UIView *baiFangMuDiView =[[UIView alloc]initWithFrame:CGRectMake(0, baiFangMuDiLabel.bottom, KscreenWidth, 1)];
    baiFangMuDiView.backgroundColor = lineColor;
    [self.bf_ScrollView addSubview:baiFangMuDiView];
    [self.bf_ScrollView addSubview:baiFangMuDiLabel];
    self.m_baiFangMuDi =[[UITextField alloc]initWithFrame:CGRectMake(90, yuQiMoneyLabel.bottom + 1, KscreenWidth - 100, 45)];
    self.m_baiFangMuDi.font =[UIFont systemFontOfSize:13];
    self.m_baiFangMuDi.textAlignment = NSTextAlignmentLeft;
    self.m_baiFangMuDi.textColor = [UIColor grayColor];
    self.m_baiFangMuDi.placeholder = @"请输入目的（必填）";
    [self.bf_ScrollView addSubview:self.m_baiFangMuDi];
    
    UILabel * qiaTanShuoMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, baiFangMuDiLabel.bottom + 1, 90, 45)];
    qiaTanShuoMingLabel.text = @"洽谈情况说明*";
    qiaTanShuoMingLabel.font =[UIFont systemFontOfSize:13];
    UIView *qiaTanShuoMingView =[[UIView alloc]initWithFrame:CGRectMake(0, qiaTanShuoMingLabel.bottom, KscreenWidth, 1)];
    qiaTanShuoMingView.backgroundColor = lineColor;
    [self.bf_ScrollView addSubview:qiaTanShuoMingView];
    [self.bf_ScrollView addSubview:qiaTanShuoMingLabel];
    self.m_qiaTanShuoMing =[[UITextField alloc]initWithFrame:CGRectMake(90, baiFangMuDiLabel.bottom + 1, KscreenWidth - 100, 45)];
    self.m_qiaTanShuoMing.font =[UIFont systemFontOfSize:13];
    self.m_qiaTanShuoMing.textColor = [UIColor grayColor];
    self.m_qiaTanShuoMing.textAlignment = NSTextAlignmentLeft;
    self.m_qiaTanShuoMing.placeholder = @"请输入情况（必填）";
    [self.bf_ScrollView  addSubview:self.m_qiaTanShuoMing];
    
    UILabel * xiaCiBaiFangTime = [[UILabel alloc]initWithFrame:CGRectMake(5, qiaTanShuoMingLabel.bottom + 1, 80, 45)];
    xiaCiBaiFangTime.text = @"下次拜访时间";
    xiaCiBaiFangTime.font =[UIFont systemFontOfSize:13];
    UIView *xiaCiBaiFangTimeView=[[UIView alloc]initWithFrame:CGRectMake(0, xiaCiBaiFangTime.bottom, KscreenWidth, 1)];
    xiaCiBaiFangTimeView.backgroundColor = lineColor;
    [self.bf_ScrollView addSubview:xiaCiBaiFangTimeView];
    [self.bf_ScrollView addSubview:xiaCiBaiFangTime];
    
    self.m_xiaCiBaiFangTimeButton= [[UIButton alloc]initWithFrame:CGRectMake(90, qiaTanShuoMingLabel.bottom + 1, KscreenWidth - 100, 45)];
    [self.m_xiaCiBaiFangTimeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.m_xiaCiBaiFangTimeButton.titleLabel  setFont:[UIFont systemFontOfSize:13]];
    self.m_xiaCiBaiFangTimeButton.backgroundColor = [UIColor whiteColor];
    [self.m_xiaCiBaiFangTimeButton setTitle:@" " forState:UIControlStateNormal];
    self.m_xiaCiBaiFangTimeButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [self.m_xiaCiBaiFangTimeButton addTarget:self action:@selector(xiaCiBaiFangTimeButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.bf_ScrollView addSubview:self.m_xiaCiBaiFangTimeButton];
    
    UILabel * xiaCiBaiFangMuDi = [[UILabel alloc]initWithFrame:CGRectMake(5, xiaCiBaiFangTime.bottom + 1, 80, 45)];
    xiaCiBaiFangMuDi.text = @"下次拜访目的";
    xiaCiBaiFangMuDi.font = [UIFont systemFontOfSize:13];
    UIView *xiaCiBaiFangMuDiView = [[UIView alloc]initWithFrame:CGRectMake(0, xiaCiBaiFangMuDi.bottom, KscreenWidth, 1)];
    xiaCiBaiFangMuDiView.backgroundColor = lineColor;
    [self.bf_ScrollView addSubview:xiaCiBaiFangMuDiView];
    [self.bf_ScrollView addSubview:xiaCiBaiFangMuDi];
    self.m_xiaCiBaiFangMuDi =[[UITextField alloc]initWithFrame:CGRectMake(90, xiaCiBaiFangTime.bottom + 1, KscreenWidth - 100, 45)];
    self.m_xiaCiBaiFangMuDi.textColor = [UIColor grayColor];
    self.m_xiaCiBaiFangMuDi.textAlignment = NSTextAlignmentLeft;
    self.m_xiaCiBaiFangMuDi.font = [UIFont systemFontOfSize:13];
    [self.bf_ScrollView addSubview:self.m_xiaCiBaiFangMuDi];
    
    
    UILabel * beiZhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, xiaCiBaiFangMuDi.bottom + 1, 80, 45)];
    beiZhuLabel.text = @"备注";
    beiZhuLabel.font =[UIFont systemFontOfSize:13];
    UIView *beiZhuView =[[UIView alloc]initWithFrame:CGRectMake(0, beiZhuLabel.bottom, KscreenWidth, 1)];
    beiZhuView.backgroundColor = lineColor;
    [self.bf_ScrollView addSubview:beiZhuView];
    [self.bf_ScrollView addSubview:beiZhuLabel];
    self.m_beiZhu =[[UITextField alloc]initWithFrame:CGRectMake(90, xiaCiBaiFangMuDi.bottom + 1, KscreenWidth - 100,45)];
    self.m_beiZhu.font =[UIFont systemFontOfSize:13];
    self.m_beiZhu.textColor = [UIColor grayColor];
    self.m_beiZhu.textAlignment = NSTextAlignmentLeft;
    [self.bf_ScrollView addSubview:self.m_beiZhu];
   
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return [self validateNumber:string];
//}
//- (BOOL)validateNumber:(NSString*)number {
//    BOOL res = YES;
//    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    int i = 0;
//    while (i < number.length) {
//        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
//        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
//        if (range.length == 0) {
//            res = NO;
//            break;
//        }
//        i++;
//    }
//    return res;
//}
#pragma mark -  客户状态的点击方法
- (void)m_genZongJiBieButtonClickMethod
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
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    if (self.genZongJiBieTableView == nil) {
        self.genZongJiBieTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.genZongJiBieTableView.backgroundColor = [UIColor whiteColor];
    }
    self.genZongJiBieTableView.dataSource = self;
    self.genZongJiBieTableView.delegate = self;
    self.genZongJiBieTableView.rowHeight = 45;
    
    [bgView addSubview:self.genZongJiBieTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.genZongJiBieTableView reloadData];
    
    if (self.genZongJiBieArr.count == 0) {
        [self genZongJiBieRequest];
    }
    
}
#pragma mark - 客户状态请求方法
- (void)genZongJiBieRequest{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase"];
    NSDictionary *params = @{@"action":@"getSelectType",@"type":@"manageclass"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        self.genZongJiBieArr = [NSMutableArray array];
        _genZongJiBieIdArr = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            NSString * str = dic[@"name"];
            NSString *str1= dic[@"id"];
            [self.genZongJiBieArr addObject:str];
            [_genZongJiBieIdArr addObject:str1];
        }
        [self.genZongJiBieTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"客户状态加载失败");
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
#pragma mark -  名字按钮点击方法
- (void)m_keHuNameButtonClickMethod
{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    //
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, KscreenWidth - 40, KscreenHeight - 160)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.m_keHuPopView addSubview:bgView];
    //
    //    _custField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _custField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _custField.backgroundColor = [UIColor whiteColor];
    _custField.delegate = self;
    _custField.tag =  101;
    _custField.placeholder = @"名称关键字";
    //    _custField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_custField.height-1,_custField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_custField addSubview:line2];
    _custField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_custField];
    [bgView addSubview:_custField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_custField.right, _custField.top, 60, _custField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(getBFName) forControlEvents:UIControlEventTouchUpInside];//getName
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.nameTableView == nil) {
        self.nameTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _custField.bottom+5,bgView.width-40, bgView.height - _custField.bottom - 5) style:UITableViewStylePlain];
        self.nameTableView.backgroundColor = [UIColor whiteColor];
    }
    self.nameTableView.dataSource = self;
    self.nameTableView.delegate = self;
    self.nameTableView.tag = 10;
    self.nameTableView.rowHeight = 50;
    [bgView addSubview:self.nameTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
}

- (void)getBFName{
    NSString *custName = _custField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户数据数据%@",array);
        [_dataArray removeAllObjects];
        if(array.count != 0){
            for (NSDictionary *dic in array) {
                KHmanageModel *model = [[KHmanageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.nameTableView reloadData];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [self showAlert:@"搜索客户名称加载失败"];
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

#pragma mark -客户名称
- (void)nameRequest
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer"];
    NSDictionary *params = @{@"action":@"getSelectName",@"table":@"khxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户名字:%@",dic);
        NSArray *array = dic[@"rows"];
        
        for (NSDictionary *dic in array) {
            KHmanageModel *model = [[KHmanageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.tableView reloadData];
        [_HUD removeFromSuperview];
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

- (void)closePop
{
    self.m_keHuNameButton.userInteractionEnabled = YES;
    [self.m_keHuPopView removeFromSuperview];
    [self.tableView removeFromSuperview];
}

- (void)upRefresh
{
    _page++;
    [self nameRequest];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
            [self upRefresh];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.nameTableView) {
        return _dataArray.count;
    }else if(tableView == self.genZongJiBieTableView){
        return self.genZongJiBieArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    CustCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = (CustCell *)[[[NSBundle mainBundle]loadNibNamed:@"CustCell" owner:self options:nil]lastObject];
        cell2.backgroundColor = [UIColor whiteColor];
    }
    
    if (tableView == self.nameTableView) {
        
        cell2.model = _dataArray[indexPath.row];
        return cell2;
    } else if(tableView == self.genZongJiBieTableView){
        cell.textLabel.text = self.genZongJiBieArr[indexPath.row];
        return cell;
    }
    return cell;
}
//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.nameTableView) {

        KHmanageModel *model = _dataArray[indexPath.row];
        self.name = model.name;
        _custId = model.Id;
        [self.m_keHuPopView removeFromSuperview];
         self.m_keHuNameButton.userInteractionEnabled = YES;
        [self.m_keHuNameButton setTitle:model.name forState:UIControlStateNormal];
        _keHuDiZhi1.text = model.receiveaddr;
        
        [self getLinker];
        [self getCustInfo];
        
        
    } else if(tableView == self.genZongJiBieTableView)
    {
        NSString *str = _genZongJiBieArr[indexPath.row];
        NSString *Id = _genZongJiBieIdArr[indexPath.row];
        _tracelevelId = Id;
        [self.m_genZongJiBieButton setTitle:str forState:UIControlStateNormal];
        [self.m_keHuPopView removeFromSuperview];
    }
    
}
#pragma mark - 上报按钮点击方法
- (void)baifangShangbao
{
    /*上报
     http://182.92.96.58:8005/yrt/servlet/custVisit
     action	addVisit
     
     
     data:"{"table":"khbf","custid":"1661","custname":"这是测试客户","linkertel":"18311111111","linker":"这是测试客户","visitedate":"2015-07-22","tracelevelid":"214","tracelevel":"C级客户","forecastmoney":"22233","purpose":"测试+","visitecontent":"测试说明","nextvisitetime":"2015-07-23","nextvisitepurpose":"下次测试","note":"测试备注"}"
     */
    NSString *custName = _m_keHuNameButton.titleLabel.text;
    if ([custName isEqualToString:@"请选择客户"]) {
        
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择客户" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    }else{
    
        NSString *yuQiJinE = _m_yuqiMoney.text;
        NSString *baiFangMuDi = _m_baiFangMuDi.text;
        NSString *qiaTanQingKuang = _m_qiaTanShuoMing.text;
        
        if (yuQiJinE.length == 0||baiFangMuDi.length == 0||qiaTanQingKuang == 0) {
            UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"必输字段不可为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [tan show];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否上报当前拜访?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1000;
            [alert show];

            
        }
    
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            //上报方法
            [self UpAction];
        }
    }

}


- (void)UpAction{
    
    //容错转NULl
    _custId = [self convertNull:_custId];
    _tracelevelId = [self convertNull:_tracelevelId];;
    _m_lianXiRen = [self convertNull:_m_lianXiRen];;
    _m_lianXiDianHua = [self convertNull:_m_lianXiDianHua];
    _tracelevelId = [self convertNull:_tracelevelId];
    NSString *visiteTime =  self.m_baiFangTimeButton.titleLabel.text;
    visiteTime = [self convertNull:visiteTime];
    NSString *visitecontent =  self.m_qiaTanShuoMing.text;
    visitecontent = [self convertNull:visitecontent];
    NSString *purpose =  self.m_baiFangMuDi.text;
    purpose = [self convertNull:purpose];
    NSString *nextTime =  self.m_xiaCiBaiFangTimeButton.titleLabel.text;
    nextTime = [self convertNull:nextTime];
    NSString *nextPurpose =  self.m_xiaCiBaiFangMuDi.text;
    nextPurpose = [self convertNull:nextPurpose];
    NSString *forecastmoney = self.m_yuqiMoney.text;
    forecastmoney = [self convertNull:forecastmoney];
    NSString *custStatus =  self.m_genZongJiBieButton.titleLabel.text;
    custStatus = [self convertNull:custStatus];
    NSString *note =  self.m_beiZhu.text;
    note = [self convertNull:note];
    NSString *cust =  self.m_keHuNameButton.titleLabel.text;
    cust = [self convertNull:cust];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSDictionary *params = @{@"action":@"addVisit",@"data":[NSString stringWithFormat:@"{\"linker\":\"%@\",\"linkertel\":\"%@\",\"visitedate\":\"%@\",\"visitecontent\":\"%@\",\"purpose\":\"%@\",\"table\":\"khbf\",\"nextvisitetime\":\"%@\",\"nextvisitepurpose\":\"%@\",\"forecastmoney\":\"%@\",\"tracelevelid\":\"%@\",\"tracelevel\":\"%@\",\"note\":\"%@\",\"custname\":\"%@\",\"custid\":\"%@\"}",_m_lianXiRen,_m_lianXiDianHua,visiteTime,visitecontent,purpose,nextTime,nextPurpose,forecastmoney,_tracelevelId,custStatus,note,cust,_custId]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *str1 =[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"拜访上报信息%@",params);
        NSLog(@"拜访上报返回%@",str1);
        if (str1.length != 0) {
            NSString *reallystr = [self replaceOthers:str1];
            if ([reallystr isEqualToString:@"true"]) {
                [self showAlert:@"客户拜访添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newVisit" object:self];
                
            }else {
                
                [self showAlert:@"客户拜访添加失败"];
            }
        }
        
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

//时间点击事件
- (void) baiFangTimeButtonClickMethod
{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0,0, KscreenWidth,KscreenHeight)];
//    _timeView.backgroundColor = [UIColor grayColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight - 270, KscreenWidth, 270)];
    bgView.backgroundColor = UIColorFromRGB(0x3cbaff);
    [_timeView addSubview:bgView];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40, KscreenWidth, 230)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-60, 0, 60, 40)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
//    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
    [self.m_baiFangTimeButton setTitle:_currentDateStr forState:UIControlStateNormal];
}

- (void)closetime
{
    [_timeView removeFromSuperview];
}

//监听datePicker值发生变化
- (void)dateChange:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [self.m_baiFangTimeButton setTitle:dateString forState:UIControlStateNormal];
}
//时间点击事件
- (void)xiaCiBaiFangTimeButtonClickMethod
{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
//    _timeView.backgroundColor = [UIColor grayColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KscreenHeight - 62 - 270, KscreenWidth, 270)];
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
//    [self.bf_ScrollView addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}

//监听datePicker值发生变化
- (void)dateChange1:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [datePicker addSubview:button];
    
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [self.m_xiaCiBaiFangTimeButton setTitle:dateString forState:UIControlStateNormal];
}

@end
