//
//  KeHuViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "KeHuViewController.h"
#import "MainViewController.h"
#import "KeHuGuanLiCell.h"
#import "KeHuManagerCell.h"
#import "AddKeHuVC.h"
#import "KeHuXinXiVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "BaiFangShangBaoVC.h"
#import "MBProgressHUD.h"
//#import "BMapKit.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "ZhaoPianShangChuanVC.h"
#import "KHmanageModel.h"
#import "KHnameModel.h"
#import "YeWuYuanModel.h"
#import "ProvinceModel.h"
#import "Reachability.h"
#import "DataPost.h"
#import "UIViewExt.h"
#import "CommonModel.h"
#import "KeHuSearchVC.h"
@interface KeHuViewController ()<BMKLocationServiceDelegate,UIAlertViewDelegate,UITextFieldDelegate>

{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl3;
    MBProgressHUD *_HUD;
    BMKLocationService *_locService;
    NSMutableArray *_dataArray;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSInteger _page;
    NSInteger _page1;
    NSInteger _page2;
    NSString *_KHid;
    MBProgressHUD *_hud;
    UIView *_searchView;
    UIView *_backView;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    
    UIButton *_custButton;
    UIButton *_salerButton;
    UIButton *_areaButton;
    UIButton *_typeButton;
    UIButton *_classButton;
    UIButton *_tracelevelButton;
    UIButton *_province;//省
    UIButton *_city;//市
    UIButton *_county;//县
    NSString *_provinceId;
    NSString *_cityId;
    NSString *_countyId;

    UITextField *_custField;
    UITextField *_salerField;
    NSMutableArray *_areaArray;
    NSMutableArray *_statusArray;
    NSString *_custId;
    NSString *_accountId;
    NSString *_classId;
    NSString *_tracelevelId;
    NSMutableDictionary * _saveDic;
    
    NSIndexPath *_selectRow;
    UIButton* _barHideBtn;
    UIButton *_hide_keHuPopViewBut;
    NSInteger _custpage;
    NSInteger _salerpage;
}

@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UITableView *areaTableView;
@property(nonatomic,retain)UITableView *typeTableView;
@property(nonatomic,retain)UITableView *classTableView;
@property(nonatomic,retain)UITableView *tracelevelTableView;
@property (strong, nonatomic) UITableView * provincetableView;
@property (strong, nonatomic) UITableView * citytableView;
@property (strong, nonatomic) UITableView * countytableView;
@property(nonatomic,retain)NSMutableArray *keHuFenLeiArr;

@property(nonatomic,retain)NSMutableArray *keHuXingZhiArr;



@end

@implementation KeHuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _page = 1;
    _page1 = 1;
    _page2 = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _custpage = 1;
    _salerpage = 1;
    //标题
    self.title = @"客户管理";
    
    [self showBarWithName:@"添加" addBarWithName:@"搜索"];
    [self initTableView];
//    [self searchView];
    [self locate];
    [self DataRequest];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"newCust" object:nil];

}
#pragma mark - 页面设置
- (void)initTableView{

    self.keHuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64) style:UITableViewStyleGrouped];
    self.keHuTableView.delegate = self;
    self.keHuTableView.dataSource = self;
    self.keHuTableView.tag = 10;
    self.keHuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.keHuTableView addSubview:_refreshControl];
    [self.view addSubview:self.keHuTableView];
    //     下拉刷新
    self.keHuTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [self.keHuTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.keHuTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.keHuTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [self.keHuTableView.mj_footer endRefreshing];
    }];

}
- (void)searchAction{

    [_searchDateArray removeAllObjects];
    KeHuSearchVC * vc = [[KeHuSearchVC alloc]init];
    [vc setBlock:^(NSString *custid, NSString *accountId, NSString *classId, NSString *tracelevelId, NSString *provinceId, NSString *cityId, NSString *countyId) {
        [self searchDataWithcustId:custid accountId:accountId classId:classId tracelevelId:tracelevelId provinceId:provinceId cityId:cityId countyId:countyId];
    }];
    [self.navigationController pushViewController:vc animated:YES];


}



#pragma mark - 搜索数据的方法
- (void)search{
//    [self searchData];
}
//_custId,_accountId,_classId,_tracelevelId,_provinceId,_cityId,_countyId
- (void)searchDataWithcustId:(NSString *)custId accountId:(NSString *)accountId classId:(NSString *)classId tracelevelId:(NSString *)tracelevelId provinceId:(NSString *)provinceId cityId:(NSString *)cityId countyId:(NSString *)countyId
{
    /*
     action:"getBeans"
     table:"khxx"
     page:"1"
     rows:"20"
     http://192.168.1.138:8080/jyx/servlet//customer?action=getBeans&table=khxx&page=1&rows=20
     params:{"table":"khxx","custidEQ":"2283","principalLIKE":"263","classidEQ":"21","tracelevelidEQ":"119"}
     */
    
    custId = [self convertNull:custId];
    classId = [self convertNull:classId];
    accountId = [self convertNull:accountId];
    tracelevelId = [self convertNull:tracelevelId];
    provinceId = [self convertNull:provinceId];
    cityId = [self convertNull:cityId];
    countyId = [self convertNull:countyId];
    _saveDic = [[NSMutableDictionary alloc]init];
    [_saveDic setObject:custId forKey:@"custId"];
    [_saveDic setObject:classId forKey:@"classId"];
    [_saveDic setObject:accountId forKey:@"accountId"];
    [_saveDic setObject:tracelevelId forKey:@"tracelevelId"];
    [_saveDic setObject:provinceId forKey:@"provinceId"];
    [_saveDic setObject:cityId forKey:@"cityId"];
    [_saveDic setObject:countyId forKey:@"countyId"];
    
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    if ([_custButton.titleLabel.text isEqualToString:@"请选择客户"]&&[_salerButton.titleLabel.text isEqualToString:@"请选择负责人"]&&[_typeButton.titleLabel.text isEqualToString:@"请选择客户分类"]&&[_tracelevelButton.titleLabel.text isEqualToString:@"请选择客户状态"]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer?action=getBeans"];
    NSDictionary *params = @{@"action":@"getBeans",@"table":@"khxx",@"mobile":@"true",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"params":[NSString stringWithFormat:@"{\"table\":\"khxx\",\"idEQ\":\"%@\",\"principalLIKE\":\"%@\",\"classidEQ\":\"%@\",\"tracelevelidEQ\":\"%@\",\"provinceEQ\":\"%@\",\"cityEQ\":\"%@\",\"countyEQ\":\"%@\"}",custId,accountId,classId,tracelevelId,provinceId,cityId,countyId]};
    NSLog(@"%@",urlStr);

    NSLog(@"%@",params);
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic1 =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            //   NSLog(@"搜索上传字典%@",params);
            NSLog(@"搜索列表数据:%@",dic1);
            NSArray *array = dic1[@"rows"];
            for (NSDictionary *dic in array) {
                KHmanageModel *model = [[KHmanageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_searchDateArray addObject:model];
            }
            [self.keHuTableView reloadData];
        }
//        _searchView.hidden = YES;
//        _backView.hidden = YES;
//        _barHideBtn.hidden = YES;
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        if (errorCode == 3840 ) {
            [self selfLogin];
        }else{
            [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
        NSLog(@"请求失败");
    }];
}





#pragma mark - 页面数据请求
- (void)DataRequest
{
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.labelText = @"正在加载中...";
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD show:YES];

    //客户管理的接口

    /*customer
     action:"getBeans"
     table:"khxx"
     page:"1"
     rows:"20"
     params:"{"table":"khxx","nameLIKE":"","principalLIKE":"","departnameLIKE":"","linkerLIKE":"","isteamworkEQ":"","typenameLIKE":"","classnameLIKE":"","placeidEQ":"","cityEQ":"","countyEQ":"","tracelevelLIKE":"","telnoLIKE":"","isvalidEQ":"1","helpnoLIKE":""}"
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/customer?action=getBeans&table=khxx"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"getBeans",@"table":@"khxx",@"isvalidEQ":@"1"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"客户管理:%@",dic);
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            KHmanageModel *model = [[KHmanageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.typeName = dic[@"typename"];
            model.Id = dic[@"id"];
            model.typeId = dic[@"typeid"];
            [_dataArray addObject:model];
        }
        [self.keHuTableView reloadData];
        }
        [_HUD hide:YES afterDelay:1];
        [_HUD removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        if (errorCode == 3840 ) {
            [self selfLogin];
        }else{
            [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }
       
        NSLog(@"请求失败");

    }];
    
}

- (void)refreshData
{
    //开始刷新
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown) userInfo:nil repeats:NO];
}

- (void)refreshDown
{
    if (_searchFlag == 1) {
        [_searchDateArray removeAllObjects];
        _searchPage = 1;
        [self searchDataWithcustId:[_saveDic objectForKey:@"custId"] accountId:[_saveDic objectForKey:@"accountId"] classId:[_saveDic objectForKey:@"classId"] tracelevelId:[_saveDic objectForKey:@"tracelevelId"] provinceId:[_saveDic objectForKey:@"provinceId"] cityId:[_saveDic objectForKey:@"cityId"] countyId:[_saveDic objectForKey:@"countyId"]];
        [_refreshControl endRefreshing];
    }else{
        [_dataArray removeAllObjects];
        _page = 1;
        [self DataRequest];
        [_refreshControl endRefreshing];
    }
}

- (void)upRefresh
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
        [self searchDataWithcustId:[_saveDic objectForKey:@"custId"] accountId:[_saveDic objectForKey:@"accountId"] classId:[_saveDic objectForKey:@"classId"] tracelevelId:[_saveDic objectForKey:@"tracelevelId"] provinceId:[_saveDic objectForKey:@"provinceId"] cityId:[_saveDic objectForKey:@"cityId"] countyId:[_saveDic objectForKey:@"countyId"]];
    }else{
        [_HUD show:YES];
        _page++;
        [self DataRequest];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh];
        }
    }else if(scrollView.tag == 30){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh3];
        }
    }
}


#pragma mark UITableViewDelegataAndDataSource协议方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.keHuTableView){
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _dataArray.count;
        }
    }else if(tableView == self.custTableView){
        return _dataArray1.count;
    }else if(tableView == self.salerTableView){
        return _dataArray2.count;
    }else if(tableView == self.areaTableView){
        return _areaArray.count;
    }else if(tableView == self.typeTableView){
        return _keHuFenLeiArr.count;
    }else if(tableView == self.classTableView){
        return _keHuXingZhiArr.count;
    }else if(tableView == self.tracelevelTableView){
        return _statusArray.count;
    }else if(tableView == self.provincetableView){
        return self.shengArr.count;
    }else if(tableView == self.citytableView){
        return self.shiArr.count;
    }else if(tableView == self.countytableView){
        return self.xianArr.count;
    }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   static NSString *iden = @"KeHuManagerCell";
    
    KeHuManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell =(KeHuManagerCell *)[[[NSBundle mainBundle]loadNibNamed:@"KeHuManagerCell" owner:self options:nil]firstObject];
//        cell.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;
    }
//    cell.kehuName.layer.cornerRadius = 10.f;
//
//    cell.kehuName.layer.masksToBounds = YES;
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
    }
    if (tableView == self.keHuTableView) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count!=0) {
                cell.model = _searchDateArray[indexPath.section];
            }
        }else{
            if (_dataArray.count != 0) {
                cell.model = _dataArray[indexPath.section];
            }
        }
        [cell setMoreBtnBlock:^{
            [self moreContentWithIndex:indexPath];
        }];
        return cell;
    }else if(tableView == self.custTableView){
        if (_dataArray1.count!=0) {
            KHnameModel *model = _dataArray1[indexPath.section];
            cell1.textLabel.text = model.name;
        }
        return cell1;
    }else if(tableView == self.salerTableView){
        if (_dataArray2.count!=0) {
            YeWuYuanModel *model = _dataArray2[indexPath.section];
            cell1.textLabel.text = model.name;
        }
        return cell1;
    }else if(tableView == self.areaTableView){
        CommonModel *model = _areaArray[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }else if(tableView == self.typeTableView){
        CommonModel *model = _keHuFenLeiArr[indexPath.section];
        cell1.textLabel.text = model.text;
        return cell1;
    }else if(tableView == self.classTableView){
        NSString *class = _keHuXingZhiArr[indexPath.section];
        cell1.textLabel.text = class;
        return cell1;
    }else if(tableView == self.tracelevelTableView){
        CommonModel *model = _statusArray[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }else if(tableView == self.provincetableView){
        ProvinceModel *model = self.shengArr[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }else if(tableView == self.citytableView){
        ProvinceModel *model = self.shiArr[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }else if(tableView == self.countytableView){
        ProvinceModel *model = self.xianArr[indexPath.section];
        cell1.textLabel.text = model.name;
        return cell1;
    }

    return cell;
}
-(void)moreContentWithIndex:(NSIndexPath *)index{
    _selectRow = index;
    UIAlertView *helpAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请选择操作"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"拍照",@"定位",@"拜访",@"拜访签到",@"拜访签退",@"打电话", nil];
    helpAlert.tag = 10010;
    [helpAlert show];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了%zi",indexPath.row);
    
}


//- (void)btnTap:(UIButton *)button{
//  
//    NSLog(@"点击了");
//
//}

//点击事件 点击进入客户信息页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.keHuTableView){
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        KeHuXinXiVC *keHuXinXiVC = [[KeHuXinXiVC alloc] init];
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                KHmanageModel *model = [_searchDateArray objectAtIndex:indexPath.section];
                keHuXinXiVC.model = model;
            }
        }else{
            if (_dataArray.count != 0) {
                KHmanageModel *model = [_dataArray objectAtIndex:indexPath.section];
                keHuXinXiVC.model = model;
            }
        }
        [self.navigationController pushViewController:keHuXinXiVC animated:YES];
        
    }else if (tableView == self.custTableView){
        if (_dataArray1.count!=0) {
            KHnameModel *model = _dataArray1[indexPath.section];
            [_custButton setTitle:model.name forState:UIControlStateNormal];
            _custButton.userInteractionEnabled = YES;
            _custId = model.Id;
        }
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.salerTableView){
        if (_dataArray2.count!=0) {
            YeWuYuanModel *model = _dataArray2[indexPath.section];
            [_salerButton setTitle:model.name forState:UIControlStateNormal];
            _salerButton.userInteractionEnabled = YES;
            _accountId = model.Id;
        }
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.areaTableView){
        CommonModel *model = _areaArray[indexPath.section];
        [_areaButton setTitle:model.name forState:UIControlStateNormal];
        _areaButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.typeTableView){
        CommonModel *model = _keHuFenLeiArr[indexPath.section];
        [_typeButton setTitle:model.text forState:UIControlStateNormal];
        _typeButton.userInteractionEnabled = YES;
        _classId = model.Id;
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.classTableView){
        NSString *class = _keHuXingZhiArr[indexPath.section];
        [_classButton setTitle:class forState:UIControlStateNormal];
        _classButton.userInteractionEnabled = YES;
      
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.tracelevelTableView){
        CommonModel *model = _statusArray[indexPath.section];
        [_tracelevelButton setTitle:model.name forState:UIControlStateNormal];
        _tracelevelButton.userInteractionEnabled = YES;
        _tracelevelId = model.Id;
        [self.m_keHuPopView removeFromSuperview];
    }else if(tableView == self.provincetableView){
        ProvinceModel *model = self.shengArr[indexPath.section];
        [_province setTitle:model.name forState:UIControlStateNormal];
        _provinceId = [NSString stringWithFormat:@"%@",model.placeid];
        _city.userInteractionEnabled = YES;
        
        [_city setTitle:@"" forState:UIControlStateNormal];
        _cityId = @"";
        
        [_county setTitle:@"" forState:UIControlStateNormal];
        _countyId =  @"";
        [self.m_keHuPopView removeFromSuperview];

    }else if(tableView == self.citytableView){
        ProvinceModel *model = self.shiArr[indexPath.section];
        [_city setTitle:model.name forState:UIControlStateNormal];
        _cityId = [NSString stringWithFormat:@"%@",model.placeid];
        _county.userInteractionEnabled = YES;
        
        [_county setTitle:@"" forState:UIControlStateNormal];
        _countyId =  @"";
        [self.m_keHuPopView removeFromSuperview];

    }else if(tableView == self.countytableView){
        ProvinceModel *model = self.xianArr[indexPath.section];
        [_county setTitle:model.name forState:UIControlStateNormal];
        _countyId =  [NSString stringWithFormat:@"%@",model.placeid];
        [self.m_keHuPopView removeFromSuperview];

    }

    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.keHuTableView){
        return 180;

    }else{
        return 45;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10010) {
        if (buttonIndex == 1) {
            //拍照
            [self paizhaoAction];
        }else if (buttonIndex == 2){
            //定位
            [self setLoc];
        }else if (buttonIndex == 3){
            //拜访
            [self baifang];
        }else if (buttonIndex == 4){
            //签到
            NSLog(@"拜访签到");
             [self vistSignin];
        }else if (buttonIndex == 5){
            //签退
            NSLog(@"拜访签退");
             [self vistSignout];
        }else if (buttonIndex == 6){
            //打电话
            [self callAction];
        }
        
    }else if (alertView.tag == 10011){
        if (buttonIndex == 1) {
            [self upLocation];
        }
        
    }else if (alertView.tag == 10012){
        if (buttonIndex == 1) {
            //拜访签到
            [self signinUpLocation];
        }
        
    }else if (alertView.tag == 10013){
        if (buttonIndex == 1) {
            //拜访签退
            [self signoutUpLocation];
        }
        
    }
    
    
}
#pragma mark -电话点击方法
- (void)callAction{
    
     KHmanageModel *model = _dataArray[_selectRow.row];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",model.receivercell]]];

}


#pragma mark -cell的拜访点击事件
- (void)baifang
{
    BaiFangShangBaoVC *bc = [[BaiFangShangBaoVC alloc] init];
    KHmanageModel *model = _dataArray[_selectRow.row];
    bc.model = model;
    [self.navigationController pushViewController:bc animated:YES];
}

#pragma mark -cell的拍照点击事件
- (void)paizhaoAction{
    
    ZhaoPianShangChuanVC *zhaoPianVC = [[ZhaoPianShangChuanVC alloc] init];
    KHmanageModel *model = _dataArray[_selectRow.row];
   // NSLog(@"行数%zi",_selectRow.row);
    zhaoPianVC.mingChen2.text = model.name;
    [self.navigationController pushViewController:zhaoPianVC animated:YES];
}
#pragma mark -cell的定位点击事件
- (void)setLoc{
    
    UIAlertView *tan =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要将现在的位置设置为该客户的位置？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    tan.tag = 10011;
    [tan show];
    KHmanageModel *model = _dataArray[_selectRow.row];
    _KHid = model.Id;
    
}
//拜访签到
- (void)vistSignin{
    
    UIAlertView *tan =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否签到？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    tan.tag = 10012;
    [tan show];
    KHmanageModel *model = _dataArray[_selectRow.row];
    _KHid = model.Id;
    
}
//拜访签退
- (void)vistSignout{
    
    UIAlertView *tan =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否签退？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    tan.tag = 10013;
    [tan show];
    KHmanageModel *model = _dataArray[_selectRow.row];
    _KHid = model.Id;
    
}

//
- (void)addNext{
    AddKeHuVC *addVC = [[AddKeHuVC alloc] init];
    
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - 地图定位

- (void)locate
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

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //上传经纬度获取
    self.lblLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.lblLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    
    NSString *addressStr = [NSString stringWithFormat:@"%@,%@",self.lblLongitude,self.lblLatitude];
    NSLog(@"经纬度返回:%@",addressStr);
    //获取经纬度转换地址
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *str = [placemark.addressDictionary[@"FormattedAddressLines"][0] substringFromIndex:2];
        NSLog(@"详细位置信息:%@",str);
        _shoWstr = [NSString stringWithFormat:@"%@%@%@",placemark.administrativeArea,placemark.addressDictionary[@"City"],placemark.addressDictionary[@"SubLocality"]];
        NSLog(@"显示位置:%@",_shoWstr);
    }];
    
    
    [_locService stopUserLocationService];
}
#pragma mark - 客户位置定位上传方法
//上传定位的经纬度
- (void)upLocation
{
    [_locService startUserLocationService];
    double lon = [self.lblLongitude doubleValue];
    double la = [self.lblLatitude doubleValue];
    if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
        
        NSLog(@"位置信息异常!");
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/location"];
        NSDictionary *params = @{@"action":@"updateCustLoc",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"longitudeafter\":\"%@\",\"latitudeafter\":\"%@\",\"id\":\"%@\"}",self.lblLongitude,self.lblLatitude,_KHid]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str1 = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"客户位置定位返回%@",str1);
            
            if (str1.length != 0) {
                NSRange range = {1,str1.length-2};
                NSString *reallystr = [str1 substringWithRange:range];
                if ([reallystr isEqualToString:@"true"]) {
                    [self showAlert:@"客户位置设置成功"];
                } else {
                    [self showAlert:@"客户位置设置失败"];
                }
            }
            
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSInteger errorCode = error.code;
            [_HUD hide:YES];
            [_HUD removeFromSuperview];
            if (errorCode == 3840 ) {
                [self selfLogin];
            }else{
                //[self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
            }
            
            NSLog(@"请求失败");
        }];

    }

    
    
   
}

#pragma mark - 拜访签到签退方法

//拜访签到方法
- (void)signinUpLocation{
    
    [_locService startUserLocationService];
    if (self.lblLongitude.length == 0 || self.lblLatitude.length == 0) {
        UIAlertView *warn = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"当前位置定位失败,请尝试重新点击"
                                                      delegate:self
                                             cancelButtonTitle:@""
                                             otherButtonTitles:@"确定", nil];
        [warn show];
        
    }else {
        
        double lon = [self.lblLongitude doubleValue];
        double la = [self.lblLatitude doubleValue];
        if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
            
            NSLog(@"位置信息异常!");
        }else{
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/location"];
            NSDictionary *params = @{@"action":@"setUserSignLoction",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"longitude\":\"%@\",\"latitude\":\"%@\",\"custid\":\"%@\",\"signStatus\":\"1\"}",self.lblLongitude,self.lblLatitude,_KHid]};
            [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                NSString *status = dic[@"status"];
                NSString *msg = dic[@"msg"];
                NSLog(@"拜访签到返回%@",dic);
                if ([status isEqualToString:@"true"]) {
                    [self showAlert:msg];
                } else if([status isEqualToString:@"false"]) {
                    [self showAlert:msg];
                }
                
                
            } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
                NSInteger errorCode = error.code;
                [_HUD hide:YES];
                [_HUD removeFromSuperview];
                if (errorCode == 3840 ) {
                    [self selfLogin];
                }else{
                    // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
                }
                NSLog(@"错误信息:%@",error);
                NSLog(@"请求失败");
            }];
            
        }
    }

        
        
}

//拜访签退方法
- (void)signoutUpLocation{
    
    [_locService startUserLocationService];
    if (self.lblLongitude.length == 0 || self.lblLatitude.length == 0) {
        UIAlertView *warn = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"当前位置定位失败,请尝试重新点击"
                                                      delegate:self
                                             cancelButtonTitle:@""
                                             otherButtonTitles:@"确定", nil];
        [warn show];
        
    }else{
        
        double lon = [self.lblLongitude doubleValue];
        double la = [self.lblLatitude doubleValue];
        if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
            
            NSLog(@"位置信息异常!");
        }else{
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/location"];
            NSDictionary *params = @{@"action":@"setUserSignLoction",@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"longitude\":\"%@\",\"latitude\":\"%@\",\"custid\":\"%@\",\"signStatus\":\"2\"}",self.lblLongitude,self.lblLatitude,_KHid]};
            [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                NSString *status = dic[@"status"];
                NSString *msg = dic[@"msg"];
                NSLog(@"拜访签退返回%@",dic);
                if ([status isEqualToString:@"true"]) {
                    [self showAlert:msg];
                } else if([status isEqualToString:@"false"]) {
                    [self showAlert:msg];
                }
                
            } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
                NSInteger errorCode = error.code;
                [_HUD hide:YES];
                [_HUD removeFromSuperview];
                if (errorCode == 3840 ) {
                    [self selfLogin];
                }else{
                    // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
                }
                NSLog(@"错误信息:%@",error);
                NSLog(@"请求失败");
            }];

            
        }
    }
}


@end
