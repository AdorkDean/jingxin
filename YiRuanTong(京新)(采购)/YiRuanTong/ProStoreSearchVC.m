//
//  ProStoreSearchVC.m
//  YiRuanTong
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProStoreSearchVC.h"
#import "MainViewController.h"
#import "KuCunCell.h"
#import "KuCunDetailView.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "KCcheckModel.h"
#import "THCpInfoCell.h"
#import "ProMaterialModel.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "CommonModel.h"

@interface ProStoreSearchVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_HUD;
    UITextField* _exField;//出库单
    UIButton *_bomName;   //BOMname
    UIButton *_proplanName;       //生产计划单号
    UIButton *_prostatusBtn; //生成状态
    UIButton *_proNameBtn; //产品名称
    UIButton *_creatorBtn;//创建人
    
    UITextField *_stoField;
    NSMutableArray *_stoArray;
    UITextField *_planField;
    NSMutableArray *_planArray;
    UITextField *_proField;
    NSMutableArray *_proArray;
    NSArray* _statusArray;
    UITextField* _creatorField;
    NSMutableArray* _creatorArray;
    
    
    UIButton* _hide_keHuPopViewBut;
    NSInteger _stopage;
    NSInteger _propage;
    NSInteger _planpage;
    NSInteger _creatorPage;
    NSString* _proid;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *stoTableView;
@property(nonatomic,retain)UITableView *planTableView;
@property(nonatomic,retain)UITableView *creatTableView;

@end

@implementation ProStoreSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查询条件";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = nil;
    _proArray = [[NSMutableArray alloc]init];
    _stoArray = [[NSMutableArray alloc]init];
    _planArray = [[NSMutableArray alloc]init];
    _creatorArray = [[NSMutableArray alloc]init];
    _statusArray = @[@"否",@"是"];
    _stopage = 1;
    _propage = 1;
    _planpage = 1;
    _creatorPage = 1;
    [self createUIview];
}
- (void)closePop{
    if ([self keyboardDid]) {
        [_proField resignFirstResponder];
        [_stoField resignFirstResponder];
        
    }else{
        
        [self.m_keHuPopView removeFromSuperview];
    }
}

- (void)createUIview{
    UILabel* exLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
    exLabel.text = @"出库单号";
    exLabel.textColor = UIColorFromRGB(0x333333);
    exLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    exLabel.font = [UIFont systemFontOfSize:15.0];
    exLabel.textAlignment = NSTextAlignmentCenter;
    _exField = [[UITextField alloc]initWithFrame:CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH)];
    _exField.textColor = UIColorFromRGB(0x9999999);
    _exField.font = [UIFont systemFontOfSize:15];
    _exField.textAlignment = NSTextAlignmentCenter;
    _exField.placeholder = @"请输入出库单号";
    UIView* exView = [[UIView alloc]initWithFrame:CGRectMake(0, exLabel.bottom, KscreenWidth, 1)];
    exView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:exLabel];
    [self.view addSubview:_exField];
    [self.view addSubview:exView];
    
    UILabel *selectProLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, exLabel.bottom+1, KscreenWidth/3, 50*MYWIDTH)];
    selectProLabel.text = @"BOM单号";
    selectProLabel.textColor = UIColorFromRGB(0x333333);
    selectProLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    selectProLabel.font = [UIFont systemFontOfSize:15.0];
    selectProLabel.textAlignment = NSTextAlignmentCenter;
    _bomName = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _bomName.frame = CGRectMake(KscreenWidth/3, exLabel.bottom+1, KscreenWidth/3*2, 50*MYWIDTH);
    [_bomName setTitle:@"请选择BOM单号" forState:UIControlStateNormal];
    [_bomName setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_bomName addTarget:self action:@selector(stoAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, selectProLabel.bottom, KscreenWidth, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:selectProLabel];
    [self.view addSubview:_bomName];
    [self.view addSubview:typeView];
    
    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, selectProLabel.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label4.text = @"生产计划单号";
    Label4.backgroundColor = UIColorFromRGB(0xf3f3f3);
    Label4.font = [UIFont systemFontOfSize:15.0];
    Label4.textAlignment = NSTextAlignmentCenter;
    
    _proplanName = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _proplanName.frame = CGRectMake(KscreenWidth/3, selectProLabel.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_proplanName addTarget:self action:@selector(proPlanAction) forControlEvents:UIControlEventTouchUpInside];
    [_proplanName setTintColor:UIColorFromRGB(0x999999)];
    [_proplanName setTitle:@"请选择生产计划单号" forState:UIControlStateNormal];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, Label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label4];
    [self.view addSubview:_proplanName];
    [self.view addSubview:view4];
    
    UILabel* creatLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Label4.bottom+1, KscreenWidth/3, 50*MYWIDTH)];
    creatLabel.text = @"创建人";
    creatLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    creatLabel.font = [UIFont systemFontOfSize:15.0];
    creatLabel.textAlignment = NSTextAlignmentCenter;
    _creatorBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _creatorBtn.frame = CGRectMake(KscreenWidth/3, Label4.bottom+1, KscreenWidth/3*2, 50*MYWIDTH);
    [_creatorBtn setTitle:@"请选择创建人" forState:UIControlStateNormal];
    [_creatorBtn addTarget:self action:@selector(creatAction) forControlEvents:UIControlEventTouchUpInside];
    [_creatorBtn setTintColor:UIColorFromRGB(0x999999)];
    UIView* creatView = [[UIView alloc]initWithFrame:CGRectMake(0, creatLabel.bottom, KscreenWidth, 1)];
    creatView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:creatLabel];
    [self.view addSubview:_creatorBtn];
    [self.view addSubview:creatView];
    
    UILabel *picilabel = [[UILabel alloc] initWithFrame:CGRectMake(0, creatLabel.bottom +1, KscreenWidth/3, 50*MYWIDTH)];
    picilabel.text = @"是否出库";
    picilabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    picilabel.font = [UIFont systemFontOfSize:15.0];
    picilabel.textAlignment = NSTextAlignmentCenter;
    _prostatusBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _prostatusBtn.frame = CGRectMake(KscreenWidth/3, creatLabel.bottom +1, KscreenWidth*2/3, 50*MYWIDTH);
    [_prostatusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_prostatusBtn setTitle:@"请选择是否出库" forState:UIControlStateNormal];
    [_prostatusBtn addTarget:self action:@selector(statusAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, picilabel.bottom, KscreenWidth, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:picilabel];
    [self.view addSubview:_prostatusBtn];
    [self.view addSubview:nameView];
    
    UILabel *wupinNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, picilabel.bottom +1, KscreenWidth/3, 50*MYWIDTH)];
    wupinNumber.text = @"产品名称";
    
    wupinNumber.backgroundColor = UIColorFromRGB(0xf3f3f3);
    wupinNumber.font = [UIFont systemFontOfSize:15.0];
    wupinNumber.textAlignment = NSTextAlignmentCenter;
    _proNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _proNameBtn.frame = CGRectMake(KscreenWidth/3, picilabel.bottom +1, KscreenWidth*2/3, 50*MYWIDTH);
    [_proNameBtn setTitle:@"请选择产品名称" forState:UIControlStateNormal];
    [_proNameBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_proNameBtn addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *picilabelView = [[UIView alloc] initWithFrame:CGRectMake(0, wupinNumber.bottom, KscreenWidth, 1)];
    picilabelView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:wupinNumber];
    [self.view addSubview:_proNameBtn];
    [self.view addSubview:picilabelView];
    
    UIView *endline = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, wupinNumber.bottom)];
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:16.0];
    chongZhi.frame = CGRectMake((KscreenWidth-200*MYWIDTH)/3, endline.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    chongZhi.layer.cornerRadius = 5;
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(chongZhi.right+(KscreenWidth-200*MYWIDTH)/3, endline.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    searchBtn.layer.cornerRadius = 5;
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:searchBtn];
    [self.view addSubview:chongZhi];
}
- (void)search{
    NSString* ex = _exField.text;
    if ([ex isEqualToString:@"请输入出库单号"]) {
        ex = @"";
    }
    NSString *bomname = _bomName.titleLabel.text;
    if ([bomname isEqualToString:@"请选择BOM单号"]||[bomname isEqualToString:@" "]) {
        bomname = @"";
    }
    NSString *planname = _proplanName.titleLabel.text;
    if ([planname isEqualToString:@"请选择生产计划单号"]||[planname isEqualToString:@" "]) {
        planname = @"";
    }
    NSString *status = _prostatusBtn.titleLabel.text;
    if ([status isEqualToString:@"请选择是否出库"]||[status isEqualToString:@" "]) {
        status = @"";
    }else if ([status isEqualToString:_statusArray[0]]){
        status = @"0";
    }else if ([status isEqualToString:_statusArray[1]]){
        status = @"1";
    }
    NSString* name = _proNameBtn.titleLabel.text;
    NSString* nameid = _proid;
    if ([name isEqualToString:@"请选择产品名称"]||[name isEqualToString:@" "]) {
        name = @"";
        nameid = @"";
    }
    NSString* creat = _creatorBtn.titleLabel.text;
    if ([creat isEqualToString:@"请选择创建人"]||[creat isEqualToString:@" "]) {
        creat = @"";
    }
    if (_block) {
        self.block( bomname,ex, planname, status, name, creat);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)stoAction{
    
    _bomName.userInteractionEnabled = YES;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    //
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
    //    _stoField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _stoField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _stoField.backgroundColor = [UIColor whiteColor];
    _stoField.delegate = self;
    _stoField.placeholder = @"名称关键字";
    //    _stoField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_stoField.height-1,_stoField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_stoField addSubview:line2];
    _stoField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_stoField];
    [bgView addSubview:_stoField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_stoField.right, _stoField.top, 60, _stoField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchsto) forControlEvents:UIControlEventTouchUpInside];//getPro
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.stoTableView == nil) {
        //        self.stoTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.stoTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, _stoField.bottom+5,bgView.width-40, bgView.height - _stoField.bottom - 5) style:UITableViewStylePlain];
        self.stoTableView.backgroundColor = [UIColor whiteColor];
    }
    self.stoTableView.dataSource = self;
    self.stoTableView.delegate = self;
    self.stoTableView.rowHeight = 45;
    [bgView addSubview:self.stoTableView];
    //    [self.m_keHuPopView addSubview:self.stoTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //     下拉刷新
    self.stoTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _stopage = 1;
        [self searchsto];
        // 结束刷新
        [self.stoTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.stoTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.stoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _stopage ++ ;
        [self searchsto];
        [self.stoTableView.mj_footer endRefreshing];
        
    }];
    _stopage = 1;
    [self searchsto];
}

- (void)searchsto{
    /*
     /production?action=getPickingList
     params:"{"nameLIKE":"成"}"
     */
    NSString *stoName = _stoField.text;
    stoName = [self convertNull:stoName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/production?action=getPickingList"];
    NSDictionary *params = @{@"action":@"getPickingList",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_stopage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",stoName]};
    if (_stopage == 1) {
        [_stoArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
        {
            NSArray *array = dic[@"rows"];
            if (array.count!=0) {
                NSLog(@"仓库名称%@",array);
                for (NSDictionary *dic in array) {
                    CommonModel *model = [[CommonModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_stoArray addObject:model];
                }
            }
            [self.stoTableView reloadData];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
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


- (void)proAction{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    //
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
    //    _proField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _proField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _proField.backgroundColor = [UIColor whiteColor];
    _proField.delegate = self;
    _proField.placeholder = @"名称关键字";
    //    _proField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_proField.height-1,_proField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_proField addSubview:line2];
    _proField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_proField];
    [bgView addSubview:_proField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_proField.right, _proField.top, 60, _proField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchpro) forControlEvents:UIControlEventTouchUpInside];//getPro
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.proTableView == nil) {
        //        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 80,KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _proField.bottom+5,bgView.width-40, bgView.height - _proField.bottom - 5) style:UITableViewStylePlain];
        self.proTableView.backgroundColor = [UIColor whiteColor];
    }
    self.proTableView.dataSource = self;
    self.proTableView.delegate = self;
    self.proTableView.tag = 102;
    self.proTableView.rowHeight = 80;
    [bgView addSubview:self.proTableView];
    //    [self.m_keHuPopView addSubview:self.proTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //     下拉刷新
    self.proTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _propage = 1;
        [self searchpro];
        // 结束刷新
        [self.proTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.proTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.proTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _propage ++ ;
        [self searchpro];
        [self.proTableView.mj_footer endRefreshing];
        
    }];
    _propage = 1;
    [self searchpro];
}

- (void)searchpro{
    /*
     接口url：production?action=getProName
     模糊查询参数：nameLIKE ？
     */
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *proName = _proField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/production?action=getProName"];
    NSDictionary *params = @{@"action":@"getProName",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",proName]};
    if (_propage == 1) {
        [_proArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                for (NSDictionary *dic in array) {
                    ProMaterialModel *model = [[ProMaterialModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_proArray addObject:model];
                }
            }
            [self.proTableView reloadData];
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
}

- (void)statusAction{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否出库：" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:_statusArray[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_prostatusBtn setTitle:_statusArray[0] forState:UIControlStateNormal];
    }];
    [alertController addAction:okAction];
    UIAlertAction * okAction1 = [UIAlertAction actionWithTitle:_statusArray[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_prostatusBtn setTitle:_statusArray[1] forState:UIControlStateNormal];
    }];
    [alertController addAction:okAction1];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void)proPlanAction{
    _proNameBtn.userInteractionEnabled = YES;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    //
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
    //    _stoField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40,KscreenWidth - 180 , 40)];
    _planField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _planField.backgroundColor = [UIColor whiteColor];
    _planField.delegate = self;
    _planField.placeholder = @"名称关键字";
    //    _stoField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_planField.height-1,_planField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_planField addSubview:line2];
    _planField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_stoField];
    [bgView addSubview:_planField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_planField.right, _planField.top, 60, _planField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchplan) forControlEvents:UIControlEventTouchUpInside];//getPro
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.planTableView == nil) {
        self.planTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, _planField.bottom+5,bgView.width-40, bgView.height - _planField.bottom - 5) style:UITableViewStylePlain];
        self.planTableView.backgroundColor = [UIColor whiteColor];
    }
    self.planTableView.dataSource = self;
    self.planTableView.delegate = self;
    self.planTableView.rowHeight = 45;
    [bgView addSubview:self.planTableView];
    //    [self.m_keHuPopView addSubview:self.stoTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //     下拉刷新
    self.planTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _planpage = 1;
        [self searchplan];
        // 结束刷新
        [self.planTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.planTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.planTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _planpage ++ ;
        [self searchplan];
        [self.planTableView.mj_footer endRefreshing];
        
    }];
    _planpage = 1;
    [self searchplan];
}

- (void)searchplan{
    /*
     /production?action=getPlanList
     params:"{"nameLIKE":"成"}"
     */
    NSString *stoName = _planField.text;
    stoName = [self convertNull:stoName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/production?action=getPlanList"];
    NSDictionary *params = @{@"action":@"getPlanList",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_planpage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",stoName]};
    if (_planpage == 1) {
        [_planArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
        {
            NSArray *array = dic[@"rows"];
            if (array.count!=0) {
                NSLog(@"仓库名称%@",array);
                for (NSDictionary *dic in array) {
                    CommonModel *model = [[CommonModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_planArray addObject:model];
                }
            }
            [self.planTableView reloadData];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
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

- (void)creatAction{
    _creatorBtn.userInteractionEnabled = YES;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
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

    _creatorField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _creatorField.backgroundColor = [UIColor whiteColor];
    _creatorField.delegate = self;
    _creatorField.placeholder = @"名称关键字";
    //    _stoField.borderStyle = UITextBorderStyleRoundedRect;
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,_creatorField.height-1,_creatorField.width, 1)];
    line2.backgroundColor=[UIColor lightGrayColor];
    [_creatorField addSubview:line2];
    _creatorField.font = [UIFont systemFontOfSize:13];
    //    [self.m_keHuPopView addSubview:_stoField];
    [bgView addSubview:_creatorField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_creatorField.right, _creatorField.top, 60, _creatorField.height);
    [btn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:0.5]; //边框宽度
    [btn addTarget:self action:@selector(searchCreat) forControlEvents:UIControlEventTouchUpInside];//getPro
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.creatTableView == nil) {
        self.creatTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, _creatorField.bottom+5,bgView.width-40, bgView.height - _creatorField.bottom - 5) style:UITableViewStylePlain];
        self.creatTableView.backgroundColor = [UIColor whiteColor];
    }
    self.creatTableView.dataSource = self;
    self.creatTableView.delegate = self;
    self.creatTableView.rowHeight = 45;
    [bgView addSubview:self.creatTableView];
    //    [self.m_keHuPopView addSubview:self.stoTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //     下拉刷新
    self.creatTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _creatorPage = 1;
        [self searchCreat];
        // 结束刷新
        [self.creatTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.creatTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.creatTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _creatorPage ++ ;
        [self searchCreat];
        [self.creatTableView.mj_footer endRefreshing];
        
    }];
    _creatorPage = 1;
    [self searchCreat];
}
- (void)searchCreat{
    /*
     /production?action=getPlanList
     params:"{"nameLIKE":"成"}"
     */
    NSString *stoName = _creatorField.text;
    stoName = [self convertNull:stoName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/shipments?action=getSalerComBox"];
    NSDictionary *params = @{@"action":@"getSalerComBox",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_creatorPage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",stoName]};
    if (_creatorPage == 1) {
        [_creatorArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
        {
            NSArray *array = dic[@"rows"];
            if (array.count!=0) {
                NSLog(@"仓库名称%@",array);
                for (NSDictionary *dic in array) {
                    CommonModel *model = [[CommonModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_creatorArray addObject:model];
                }
            }
            [self.creatTableView reloadData];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
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

- (void)chongZhi{
    _exField.text = @"";
    [_proplanName setTitle:@" " forState:UIControlStateNormal];
    [_bomName setTitle:@" " forState:UIControlStateNormal ];
    [_prostatusBtn setTitle:@" " forState:UIControlStateNormal];
    [_proNameBtn setTitle:@" " forState:UIControlStateNormal];
    [_creatorBtn setTitle:@" " forState:UIControlStateNormal];
}
#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.proTableView) {
        return _proArray.count;
    }else if(tableView == self.stoTableView){
        return _stoArray.count;
    }else if (tableView == self.planTableView){
        return _planArray.count;
    }else if (tableView == self.creatTableView){
        return _creatorArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *iden = @"cell_1";
    KuCunCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = (KuCunCell *)[[[NSBundle mainBundle]loadNibNamed:@"KuCunCell" owner:self options:nil]firstObject];
    }
    THCpInfoCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil ) {
        cell1 = (THCpInfoCell *)[[[NSBundle mainBundle]loadNibNamed:@"THCpInfoCell" owner:self options:nil]firstObject];
    }
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell2 == nil) {
        cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    
    if (tableView == self.proTableView) {
        if (_proArray.count != 0) {
            ProMaterialModel* model = [[ProMaterialModel alloc]init];
            model = _proArray[indexPath.row];
            cell2.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
        }
        return cell2;
    }else if(tableView == self.stoTableView){
        if (_stoArray.count != 0) {
            CommonModel *model = _stoArray[indexPath.row];
            cell2.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
            return cell2;
        }
    }else if(tableView == self.planTableView){
        if (_planArray.count != 0) {
            CommonModel *model = _planArray[indexPath.row];
            cell2.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
            return cell2;
        }
    }else if (tableView == self.creatTableView){
        if (_creatorArray.count != 0) {
            CommonModel *model = _creatorArray[indexPath.row];
            cell2.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
            return cell2;
        }
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.proTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_proArray.count!=0) {
            ProMaterialModel *model = _proArray[indexPath.row];
            _proid = [NSString stringWithFormat:@"%@",model.Id];
            [_proNameBtn setTitle:model.name forState:UIControlStateNormal];
        }
        _proplanName.userInteractionEnabled = YES;
        
    }else if(tableView == self.stoTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_stoArray.count!=0) {
            CommonModel *model = _stoArray[indexPath.row];
            [_bomName setTitle:model.name forState:UIControlStateNormal];
            _bomName.userInteractionEnabled = YES;
        }
    }else if(tableView == self.planTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_planArray.count!=0) {
            CommonModel *model = _planArray[indexPath.row];
            [_proplanName setTitle:model.name forState:UIControlStateNormal];
            _proplanName.userInteractionEnabled = YES;
        }
    }else if(tableView == self.creatTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_creatorArray.count!=0) {
            CommonModel *model = _creatorArray[indexPath.row];
            [_creatorBtn setTitle:model.name forState:UIControlStateNormal];
            _creatorBtn.userInteractionEnabled = YES;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  45;
    
}



@end
