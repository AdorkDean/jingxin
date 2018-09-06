//
//  KucunManagerSearchVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/3.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "KucunManagerSearchVC.h"
#import "MainViewController.h"
#import "KuCunCell.h"
#import "KuCunDetailView.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "KCcheckModel.h"
#import "THCpInfoCell.h"
#import "THCPModel.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "CommonModel.h"
@interface KucunManagerSearchVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIRefreshControl *_refreshControl;
    UIButton *_salerButton;
    UIButton *_startButton;
    UIButton *_endButton;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray;
    NSInteger _page;
    NSInteger _page1;
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    UIView *_timeView;
    
    UIButton *_storageName;   //仓库名称
    UIButton *_proName;       //产品名称
    UITextField *_probatchField; //批次名称
    UITextField *_proNoField; //物品编码
    
    UILabel *_label1;   //总数量
    UILabel *_label2;   //总数量
    UILabel *_label3;   //总金额
    UITextField *_proField;
    NSMutableArray *_proArray;
    UITextField *_stoField;
    NSMutableArray *_stoArray;
    NSString *_currentDateStr;
    NSString * _pastDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _stopage;
    NSInteger _propage;
}
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *stoTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@end

@implementation KucunManagerSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查询条件";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [[NSMutableArray alloc] init];
    _proArray = [[NSMutableArray alloc]init];
    _stoArray = [[NSMutableArray alloc]init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _page = 1;
    _page1 = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _stopage = 1;
    _propage = 1;
    [self getDateStr];
    [self createUIview];
}
- (void)closePop{
    if ([self keyboardDid]) {
        [_proField resignFirstResponder];
        [_probatchField resignFirstResponder];
//        [_specificationField resignFirstResponder];
        [_stoField resignFirstResponder];
        
    }else{
        
        [self.m_keHuPopView removeFromSuperview];
    }
}
- (void)getDateStr{
    //得到当前的时间
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"---当前的时间的字符串 =%@",currentDateStr);
    _currentDateStr = currentDateStr;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:-1];
    
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate = [dateFormatter stringFromDate:newdate];
    NSLog(@"---前一个月 =%@",beforDate);
    _pastDateStr = beforDate;
}
- (void)createUIview{
    
    UILabel *selectProLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/3, 50*MYWIDTH)];
    selectProLabel.text = @"仓库名称";
    selectProLabel.textColor = UIColorFromRGB(0x333333);
    selectProLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    selectProLabel.font = [UIFont systemFontOfSize:15.0];
    selectProLabel.textAlignment = NSTextAlignmentCenter;
    _storageName = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _storageName.frame = CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH);
    [_storageName setTitle:@"请选择仓库" forState:UIControlStateNormal];
    [_storageName setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_storageName addTarget:self action:@selector(stoAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, selectProLabel.bottom, KscreenWidth, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:selectProLabel];
    [self.view addSubview:_storageName];
    [self.view addSubview:typeView];
    
    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, selectProLabel.bottom + 1, KscreenWidth/3, 50*MYWIDTH)];
    Label4.text = @"物料名称";
    Label4.backgroundColor = UIColorFromRGB(0xf3f3f3);
    Label4.font = [UIFont systemFontOfSize:15.0];
    Label4.textAlignment = NSTextAlignmentCenter;
    
    _proName = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _proName.frame = CGRectMake(KscreenWidth/3, selectProLabel.bottom + 1, KscreenWidth/3*2, 50*MYWIDTH);
    [_proName addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
    [_proName setTintColor:UIColorFromRGB(0x999999)];
    [_proName setTitle:@"请选择物料" forState:UIControlStateNormal];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, Label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:Label4];
    [self.view addSubview:_proName];
    [self.view addSubview:view4];
    
//    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, view4.bottom)];
//    fenGeXian.backgroundColor = UIColorFromRGB(0xdcdcdc);
//    [self.view addSubview:fenGeXian];
    
    UILabel *picilabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Label4.bottom +1, KscreenWidth/3, 50*MYWIDTH)];
    picilabel.text = @"批次";
    picilabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    picilabel.font = [UIFont systemFontOfSize:15.0];
    picilabel.textAlignment = NSTextAlignmentCenter;
    _probatchField = [[UITextField alloc] initWithFrame:CGRectMake(KscreenWidth/3, Label4.bottom +1, KscreenWidth*2/3, 50*MYWIDTH)];
    _probatchField.textAlignment = NSTextAlignmentCenter;
    _probatchField.textColor = UIColorFromRGB(0x999999);
    _probatchField.placeholder = @"请输入批次";
    _probatchField.font = [UIFont systemFontOfSize:15.0];
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, picilabel.bottom, KscreenWidth, 1)];
    nameView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:picilabel];
    [self.view addSubview:_probatchField];
    [self.view addSubview:nameView];
    
    UILabel *wupinNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, picilabel.bottom +1, KscreenWidth/3, 50*MYWIDTH)];
    wupinNumber.text = @"物品编号";
    
    wupinNumber.backgroundColor = UIColorFromRGB(0xf3f3f3);
    wupinNumber.font = [UIFont systemFontOfSize:15.0];
    wupinNumber.textAlignment = NSTextAlignmentCenter;
    _proNoField = [[UITextField alloc] initWithFrame:CGRectMake(KscreenWidth/3, picilabel.bottom +1, KscreenWidth*2/3, 50*MYWIDTH)];
    _proNoField.textAlignment = NSTextAlignmentCenter;
    _proNoField.textColor = UIColorFromRGB(0x999999);
    _proNoField.placeholder = @"请输入编号";
    _proNoField.font = [UIFont systemFontOfSize:15.0];
    UIView *picilabelView = [[UIView alloc] initWithFrame:CGRectMake(0, wupinNumber.bottom, KscreenWidth, 1)];
    picilabelView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:wupinNumber];
    [self.view addSubview:_proNoField];
    [self.view addSubview:picilabelView];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, picilabelView.bottom, KscreenWidth/3, 50*MYWIDTH)];
    startLabel.text = @"开始时间";
    startLabel.textColor = UIColorFromRGB(0x333333);
    startLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    startLabel.font = [UIFont systemFontOfSize:15.0];
    startLabel.textAlignment = NSTextAlignmentCenter;
    _startButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _startButton.frame = CGRectMake(KscreenWidth/3, picilabelView.bottom, KscreenWidth/3*2, 50*MYWIDTH);
    [_startButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setTitle:_pastDateStr forState:UIControlStateNormal];
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, startLabel.bottom, KscreenWidth, 1)];
    startView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:startLabel];
    [self.view addSubview:_startButton];
    [self.view addSubview:startView];
    
    //
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startView.bottom, KscreenWidth/3, 50*MYWIDTH)];
    endLabel.text = @"结束时间";
    endLabel.textColor = UIColorFromRGB(0x333333);
    endLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    endLabel.font = [UIFont systemFontOfSize:15.0];
    endLabel.textAlignment = NSTextAlignmentCenter;
    _endButton= [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _endButton.frame = CGRectMake(KscreenWidth/3, startView.bottom, KscreenWidth/3*2, 50*MYWIDTH);
    [_endButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    [_endButton addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0, endLabel.bottom, KscreenWidth, 1)];
    endView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:endLabel];
    [self.view addSubview:_endButton];
    [self.view addSubview:endView];
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    
    UIView *endline = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, endView.bottom)];
//    fenGeXian.backgroundColor = UIColorFromRGB(0xdcdcdc);
//    [self.view addSubview:fenGeXian];
    //
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
    NSString *stoname = _storageName.titleLabel.text;
    if ([stoname isEqualToString:@"请选择仓库"]) {
        stoname = @"";
    }
    NSString *proname = _proName.titleLabel.text;
    if ([proname isEqualToString:@"请选择物料"]) {
        proname = @"";
    }
    if (_block) {
        self.block(stoname, proname, @"", @"",_startButton.titleLabel.text, _endButton.titleLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)stoAction{
    
    _storageName.userInteractionEnabled = YES;
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
    //    [self stoRequest];
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
- (void)getStog{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn?action=getShipments"];
    NSDictionary *params = @{@"action":@"getShipments",@"rows":@"100",@"page":[NSString stringWithFormat:@"%zi",_page1],@"table":@"fhxx",};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        //NSArray *array = dic[@"rows"];
        NSLog(@"仓库搜索%@",array);
        [_stoArray removeAllObjects];
        for (NSDictionary *dic in array) {
            CommonModel *model = [[CommonModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_stoArray addObject:model];
        }
        [self.stoTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
    
}

- (void)stoRequest{
    /*
     storage
     action:"getAllStorages"
     table:"ckxx"
     params:"{"nameLIKE":"成"}"
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/storage?action=getpurchaseStorages"];
    NSDictionary *params = @{@"action":@"getpurchaseStorages",@"table":@"ckxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        // NSArray *array = dic[@"rows"];
        NSLog(@"仓库名称%@",array);
        _stoArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CommonModel *model = [[CommonModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_stoArray addObject:model];
        }
        [self.stoTableView reloadData];
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

- (void)searchsto{
    /*
     storage
     action:"getAllStorages"
     table:"ckxx"
     params:"{"nameLIKE":"成"}"
     */
    NSString *stoName = _stoField.text;
    stoName = [self convertNull:stoName];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/storage?action=getpurchaseStorages"];
    NSDictionary *params = @{@"action":@"getpurchaseStorages",@"table":@"ckxx",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_stopage],@"mobile":@"true",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",stoName]};
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
    //    [self proRequest];
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

- (void)getPro{
    
    NSString *proName = _proField.text;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn?action=getShipments"];
    NSDictionary *params = @{@"action":@"getShipments",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",proName]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"产品信息搜索返回:%@",dic);
        [_proArray removeAllObjects];
        for (NSDictionary *dic1 in dic) {
            THCPModel *model = [[THCPModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            [_proArray addObject:model];
        }
        [self.proTableView reloadData];
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
- (void)proRequest{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn?action=getShipments"];
    NSDictionary *params = @{@"action":@"getShipments",@"rows":@"100",@"page":[NSString stringWithFormat:@"%zi",_page1],@"table":@"fhxx",};
    if (_page1 == 1) {
        [_proArray removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"退货的产品名称%@",array);
        
        for (NSDictionary *dic in array) {
            THCPModel *model = [[THCPModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_proArray addObject:model];
        }
        [self.proTableView reloadData];
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

- (void)searchpro{
    /*
     物料名称接口：加载物料名称接口url：/purchaseManage?action=getMaterials模糊查询参数：nameLIKE ？
     */
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *proName = _proField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/stock"];
    NSDictionary *params = @{@"action":@"getWlSelect",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_propage],@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\",\"storageid\":\"\"}",proName]};
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
                    THCPModel *model = [[THCPModel alloc] init];
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
//开始时间
- (void)startAction{
    
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth,KscreenHeight)];
    //    _timeView.backgroundColor = [UIColor whiteColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
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
    [_startButton setTitle:_currentDateStr forState:UIControlStateNormal];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
}
//结束时间
- (void)endAction{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    _timeView.backgroundColor = [UIColor whiteColor];
    _timeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
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
    [_endButton setTitle:_currentDateStr forState:UIControlStateNormal];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange1:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_datePicker];
    //    [self.view addSubview:_timeView];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeView];
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
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_startButton setTitle:dateString forState:UIControlStateNormal];
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
    [_endButton setTitle:dateString forState:UIControlStateNormal];
}
- (void)chongZhi{
    [_proName setTitle:@" " forState:UIControlStateNormal];
    [_storageName setTitle:@" " forState:UIControlStateNormal ];
    [_startButton setTitle:@" "forState:UIControlStateNormal];
    _startButton.titleLabel.text = @" ";
    [_endButton setTitle:@" "forState:UIControlStateNormal];
    _endButton.titleLabel.text = @" ";
}
#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.proTableView) {
        return _proArray.count;
    }else{
        return _stoArray.count;
    }
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
            THCPModel* model = [[THCPModel alloc]init];
            model = _proArray[indexPath.row];
            cell2.textLabel.text = [NSString stringWithFormat:@"%@",model.proname];
        }
        return cell2;
    }else{
        if (_stoArray.count != 0) {
            CommonModel *model = _stoArray[indexPath.row];
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
            THCPModel *model = _proArray[indexPath.row];
            [_proName setTitle:model.proname forState:UIControlStateNormal];
//            _probatchField.text = [NSString stringWithFormat:@"%@",model.prono];
//            _specificationField.text = model.specification;
        }
        _proName.userInteractionEnabled = YES;
        
    }else if(tableView == self.stoTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_stoArray.count!=0) {
            CommonModel *model = _stoArray[indexPath.row];
            [_storageName setTitle:model.name forState:UIControlStateNormal];
            _storageName.userInteractionEnabled = YES;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView==self.proTableView) {
//        return 75;
//    }
    return  45;
    
}

@end
