//
//  WLXXSearchVC.m
//  YiRuanTong
//
//  Created by apple on 2018/7/4.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "WLXXSearchVC.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "WLXXinfomodel.h"
#import "WLXXTableViewCell.h"
@interface WLXXSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *salerTableView;

@end

@implementation WLXXSearchVC
{
    UIButton *_salerButton;
    UIButton* _hide_keHuPopViewBut;
    NSString *_currentDateStr;
    NSString * _pastDateStr;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray1;
    UITextField *_proField;
    NSInteger _propage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查询条件";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray1 = [[NSMutableArray alloc]init];
    [self getDateStr];
    [self createUIview];
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
    selectProLabel.text = @"物料名称";
    selectProLabel.textColor = UIColorFromRGB(0x333333);
    selectProLabel.backgroundColor = UIColorFromRGB(0xf3f3f3);
    selectProLabel.font = [UIFont systemFontOfSize:15.0];
    selectProLabel.textAlignment = NSTextAlignmentCenter;
    _salerButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _salerButton.frame = CGRectMake(KscreenWidth/3, 0, KscreenWidth/3*2, 50*MYWIDTH);
    [_salerButton setTitle:@"请选择物料" forState:UIControlStateNormal];
    [_salerButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [_salerButton addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, selectProLabel.bottom, KscreenWidth, 1)];
    typeView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:selectProLabel];
    [self.view addSubview:_salerButton];
    [self.view addSubview:typeView];
    
    UIView *fenGeXian = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth/3, 0, 1, selectProLabel.bottom)];
    fenGeXian.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self.view addSubview:fenGeXian];
    
    //
    UIButton *chongZhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongZhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongZhi setBackgroundColor:UIColorFromRGB(0x3cbaff)];
    [chongZhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongZhi.titleLabel.font = [UIFont systemFontOfSize:16.0];
    chongZhi.frame = CGRectMake((KscreenWidth-200*MYWIDTH)/3, fenGeXian.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    chongZhi.layer.cornerRadius = 5;
    [chongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(chongZhi.right+(KscreenWidth-200*MYWIDTH)/3, fenGeXian.bottom+50, 100*MYWIDTH, 38*MYWIDTH);
    searchBtn.layer.cornerRadius = 5;
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [self.view addSubview:chongZhi];
}
- (void)proAction
{
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    //        self.m_keHuPopView.backgroundColor = [UIColor grayColor];
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
    //    _proField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40,KscreenWidth - 80 , 40)];
    _proField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10,bgView.width - 40 - 60 , 40)];
    _proField.backgroundColor = [UIColor whiteColor];
    _proField.delegate = self;
    _proField.placeholder = @"名称关键字";
    //    _proField.borderStyle = UITextBorderStyleBezel;
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
    [btn.layer setBorderWidth:0.5]; //边框宽度
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(searchpro) forControlEvents:UIControlEventTouchUpInside];//getPro
    //    [self.m_keHuPopView addSubview:btn];
    [bgView addSubview:btn];
    
    if (self.salerTableView == nil) {
        //        self.proTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 80,KscreenWidth-20, KscreenHeight-174) style:UITableViewStylePlain];
        self.salerTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _proField.bottom+5,bgView.width-40, bgView.height - _proField.bottom - 5) style:UITableViewStylePlain];
        self.salerTableView.backgroundColor = [UIColor whiteColor];
    }
    self.salerTableView.dataSource = self;
    self.salerTableView.delegate = self;
    self.salerTableView.tag = 50;
    self.salerTableView.rowHeight = 80;
    [bgView addSubview:self.salerTableView];
    //隐藏多余cell
    self.salerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [self.m_keHuPopView addSubview:self.proTableView];
    //        [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    //        if (_dataArray1.count == 0) {
    //            [self getCPInfo];
    //        }
    //     下拉刷新
    self.salerTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _propage = 1;
        [self searchpro];
        // 结束刷新
        [self.salerTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.salerTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.salerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _propage ++ ;
        [self searchpro];
        [self.salerTableView.mj_footer endRefreshing];
        
    }];
    _propage = 1;
    [self searchpro];
    
    
}
- (void)searchpro{
    /*
     加载物料名称接口url：/purchaseManage?action=getMaterials模糊查询参数：params={"nameLIKE":""}
     */
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:_m_keHuPopView animated:YES];
    NSString *proName = _proField.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/purchaseManage?action=getMaterials"];
    NSDictionary *params = @{@"action":@"getMaterials",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_propage],@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",proName]};
    if (_propage == 1) {
        [_dataArray1 removeAllObjects];
    }
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if([[dic allKeys] containsObject:@"rows"])
            
        {
            NSArray *array = dic[@"rows"];
            NSLog(@"新的产品接口%@",array);
            if (array.count!=0) {
                for (NSDictionary *dic in array) {
                    WLXXinfomodel *model = [[WLXXinfomodel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray1 addObject:model];
                }
                [self.salerTableView reloadData];
            }
            
        }
        [hud hide:YES];
        [hud removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"加载失败");
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
    
}

- (void)closePop{
    if ([self keyboardDid]) {
        [_proField resignFirstResponder];
        
    }else{
        [self.salerTableView removeFromSuperview];
        [self.m_keHuPopView removeFromSuperview];
    }
    
}
- (void)search{
    
    if (_block) {
        self.block(@"", _salerButton.titleLabel.text, @"", @"");
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)chongZhi
{
    [_salerButton setTitle:@" " forState:UIControlStateNormal];
}

#pragma mark-UITableViewDelegateAndDataSource协议方法

//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    WLXXTableViewCell *cell2 =  [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = (WLXXTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"WLXXTableViewCell" owner:self options:nil]firstObject];
        cell2.backgroundColor = [UIColor whiteColor];
        if (_dataArray1.count != 0) {
            WLXXinfomodel* model = [[WLXXinfomodel alloc]init];
            model = _dataArray1[indexPath.row];
            cell2.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
            cell2.guigeLabel.text = [NSString stringWithFormat:@"%@",model.size];
            cell2.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
        }
    }
    return cell2;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataArray1.count!=0) {
        WLXXinfomodel *model = _dataArray1[indexPath.row];
        [_salerButton setTitle:model.name forState:UIControlStateNormal];
    }
    [self.m_keHuPopView removeFromSuperview];
}



@end
