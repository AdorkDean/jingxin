//
//  ProductMaterialViewController.m
//  YiRuanTong
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "ProductMaterialViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProMaterialModel.h"
#import "ProMaterialListCell.h"
#import "DataPost.h"
#import "ProductMateriaDetailVC.h"
#import "UIViewExt.h"
#import "ProductMaterialSearchVC.h"
#import "ProductingDetailVC.h"
#import "ProduckFinishVC.h"
#import "ProFinishModel.h"
@interface ProductMaterialViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray;
    NSInteger _page;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    NSMutableArray*_resultData;
    
    NSString* _bomno;
    NSString* _planno;
    NSString* _status;
    NSString* _proname;
}
@property (strong, nonatomic)  UITableView *kuCunTableView;
@end

@implementation ProductMaterialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"生产领料管理";
    _dataArray = [[NSMutableArray alloc] init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _resultData = [[NSMutableArray alloc]init];
    _searchPage = 1;
    _searchFlag = 0;
    _page = 1;
    self.navigationItem.rightBarButtonItem = nil;
    [self showBarWithName:@"搜索" addBarWithName:nil];
    [self initTableView];
    [self DataRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRefresh) name:@"newprofinish" object:nil];
    
}

#pragma mark - 页面设置
- (void)initTableView{
    
    self.kuCunTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    self.kuCunTableView.delegate = self;
    self.kuCunTableView.dataSource = self;
    self.kuCunTableView.rowHeight = 90;
    self.kuCunTableView.tag = 10;
    [self.view addSubview:_kuCunTableView];
    //     下拉刷新
    _kuCunTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_kuCunTableView.mj_header endRefreshing];
        
    }];
    NSString * roleid = [[NSUserDefaults standardUserDefaults]objectForKey:@"roleid"];
    if ([roleid integerValue] == 140) {
        
    }else{
        // 上拉刷新
        _kuCunTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
            [self upRefresh];
            [_kuCunTableView.mj_footer endRefreshing];
        }];
    }
    //隐藏多余cell
    _kuCunTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _kuCunTableView.mj_header.automaticallyChangeAlpha = YES;
    
    //    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
    //    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.kuCunTableView addGestureRecognizer:swipe];
    
}

- (void)searchDataWithProName
{
    NSString *bomno;
    bomno = [self convertNull:_bomno];
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    if ([_bomno isEqualToString:@""]&&[_planno isEqualToString:@""]&&[_status isEqualToString:@""]&&[_proname isEqualToString:@""]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist?action=getBeans"];
    NSString* datastr = [NSString stringWithFormat:@"{\"bomnoLIKE\":\"%@\",\"plannoLIKE\":\"%@\",\"isstockoutEQ\":\"%@\",\"proidEQ\":\"%@\"}",_bomno,_planno,_status,_proname];
    NSDictionary *params = @{@"action":@"getBeans",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_searchPage],@"params":datastr};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"rows"];
            for (NSDictionary *dic in array) {
                ProMaterialModel *model = [[ProMaterialModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_searchDateArray addObject:model];
            }
            [self.kuCunTableView reloadData];
        }
        [_HUD hide:YES];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD removeFromSuperview];
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
#pragma mark - 浏览数据
- (void)DataRequest
{
    
    //HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText =  @"网络不给力,正在加载中...";
    [_HUD show:YES];
    //数据接口拼接
    /*
     params={"bomnoLIKE":"","plannoLIKE":"","isstockoutEQ":"0","proidEQ":""}
     url=http://192.168.1.199:8080/jingxin/servlet/pickinglist?action=getBeans
     分页
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist?action=getBeans"];
    NSDictionary *params = @{@"action":@"getBeans",@"rows":@"20",@"page":[NSString stringWithFormat:@"%li",(long)_page],@"params":@"{\"bomnoLIKE\":\"\",\"plannoLIKE\":\"\",\"isstockout\":\"0\",\"proidEQ\":\"\"}"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        if (_page == 1) {
            [_dataArray removeAllObjects];
        }
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"rows"];
            
            NSLog(@"物料浏览列表:%@",array);
            for (NSDictionary *dic in array) {
                ProMaterialModel *model = [[ProMaterialModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
                
            }
            [self.kuCunTableView reloadData];
        }
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
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
- (void)newRefresh{
    [self refreshDown];
}
- (void)refreshDown
{
    if (_searchFlag == 1) {
        [_searchDateArray removeAllObjects];
        _searchPage = 1;
        [self searchDataWithProName];
    }else{
        [_dataArray removeAllObjects];
        _page = 1;
        [self DataRequest];
    }
}

- (void)upRefresh
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
        [self searchDataWithProName];
    }else{
        [_HUD show:YES];
        _page++;
        [self DataRequest];
    }
}
#pragma mark UITableViewDelegateAndDataSource

//返回每个section上cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.kuCunTableView){
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _dataArray.count;
        }
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"ProMaterialListCellID";
    ProMaterialListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = (ProMaterialListCell *)[[[NSBundle mainBundle]loadNibNamed:@"ProMaterialListCell" owner:self options:nil]firstObject];
    }
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    
    if (tableView == self.kuCunTableView) {
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                ProMaterialModel * model = [[ProMaterialModel alloc]init];
                model = [_searchDateArray objectAtIndex:indexPath.row];
                cell.model = model;
                return cell;
            }
        }else{
            if (_dataArray.count != 0) {
                ProMaterialModel *model = [[ProMaterialModel alloc]init];
                model = [_dataArray objectAtIndex:indexPath.row];
                cell.model = model;
                return cell;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_searchFlag == 1) {
        
    }else{
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.kuCunTableView ){
        if (_searchFlag == 1) {
            ProMaterialModel *model= _searchDateArray[indexPath.row];
            if ([model.flag integerValue] == 1&&[model.isstockout integerValue] == 0) {
                //未生产 /pickinglist?action=getDetailByzj 参数：idEQ
                [self getDetailByzjDataRequestWithModel:model];
                
            }
            if ([model.flag integerValue] == 1&&[model.isstockout integerValue] == 1) {
                //部分生产 有产品展示 和仓库选择等(可修改)  调用一个接口判断该单子是否审批url：/pickinglist?action=isSpstatus  参数：bomno  如果返回的数据count等于0，加载物料信息的接口url为：/pickinglist?action=getDetailByMTid 参数：idEQ。否则：加载物料信息的接口url为：/pickinglist?action=getPartByMtId 参数：idEQ":"' '","bomnoEQ":"'   '","plancountEQ":"'  '"
                [self requestIsSpstatus:model];
            }
            if ([model.flag integerValue] == 1&&[model.isstockout integerValue] == 2) {
                //全部生产 纯展示、不可点击(不可修改) 加载物料信息的url：/pickinglist?action=getSODetailBeans 参数：bomnoEQ
                ProduckFinishVC *detail = [[ProduckFinishVC alloc] init];
                detail.model = model;
                [self.navigationController pushViewController:detail animated:YES];
            }
            if ([model.flag integerValue] != 1&&[model.isstockout integerValue] == 0) {
                //未生产 /pickinglist?action=getDetailByMTid 参数：idEQ
                 [self getDetailByMTidDataRequestWithModel:model];
            }
            if ([model.flag integerValue] != 1&&[model.isstockout integerValue] == 1) {
                //部分生产 有产品展示 和仓库选择等(可修改)
                [self requestIsSpstatus:model];
            }
            if ([model.flag integerValue] != 1&&[model.isstockout integerValue] == 2) {
                //全部生产 纯展示、不可点击(不可修改)
                ProduckFinishVC *detail = [[ProduckFinishVC alloc] init];
                detail.model = model;
                [self.navigationController pushViewController:detail animated:YES];
            }
        }else{
            ProMaterialModel *model= _dataArray[indexPath.row];
            if ([model.flag integerValue] == 1&&[model.isstockout integerValue] == 0) {
                [self getDetailByMTidDataRequestWithModel:model];
            }
            if ([model.flag integerValue] == 1&&[model.isstockout integerValue] == 1) {
                //部分生产 有产品展示 和仓库选择等(可修改)  调用一个接口判断该单子是否审批url：/pickinglist?action=isSpstatus  参数：bomno  如果返回的数据count等于0，加载物料信息的接口url为：/pickinglist?action=getDetailByMTid 参数：idEQ。否则：加载物料信息的接口url为：/pickinglist?action=getPartByMtId 参数：idEQ":"' '","bomnoEQ":"'   '","plancountEQ":"'  '"
               [self requestIsSpstatus:model];
                
            }
            if ([model.flag integerValue] == 1&&[model.isstockout integerValue] == 2) {
                //全部生产 纯展示、不可点击(不可修改) 加载物料信息的url：/pickinglist?action=getSODetailBeans 参数：bomnoEQ
                ProduckFinishVC *detail = [[ProduckFinishVC alloc] init];
                detail.model = model;
                [self.navigationController pushViewController:detail animated:YES];
            }
            if ([model.flag integerValue] != 1&&[model.isstockout integerValue] == 0) {
                //未生产 /pickinglist?action=getDetailByMTid 参数：idEQ
                [self getDetailByMTidDataRequestWithModel:model];

            }
            if ([model.flag integerValue] != 1&&[model.isstockout integerValue] == 1) {
                //部分生产 有产品展示 和仓库选择等(可修改)
                [self requestIsSpstatus:model];
            }
            if ([model.flag integerValue] != 1&&[model.isstockout integerValue] == 2) {
                //全部生产 纯展示、不可点击(不可修改)
                ProduckFinishVC *detail = [[ProduckFinishVC alloc] init];
                detail.model = model;
                [self.navigationController pushViewController:detail animated:YES];
            }
           
        }
    }
    
}
-(void)getDetailByzjDataRequestWithModel:(ProMaterialModel *)model{
    [_resultData removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getDetailByzj ",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\"}",model.Id]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (arr.count == 0) {
            ProductMateriaDetailVC *detail = [[ProductMateriaDetailVC alloc] init];
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            for (NSDictionary *dic in  arr) {
                ProFinishModel *model = [[ProFinishModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_resultData addObject:model];
            }
            ProductingDetailVC *detail = [[ProductingDetailVC alloc] init];
            detail.resultArr = _resultData;
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
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
//
-(void)getDetailByMTidDataRequestWithModel:(ProMaterialModel *)model{
    [_resultData removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getDetailByMTid ",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\"}",model.Id]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (arr.count == 0) {
            ProductMateriaDetailVC *detail = [[ProductMateriaDetailVC alloc] init];
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            for (NSDictionary *dic in  arr) {
                ProFinishModel *model = [[ProFinishModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_resultData addObject:model];
            }
            ProductingDetailVC *detail = [[ProductingDetailVC alloc] init];
            detail.resultArr = _resultData;
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
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
-(void)requestIsSpstatus:(ProMaterialModel*)model{
    //调用一个接口判断该单子是否审批url：/pickinglist?action=isSpstatus  参数：bomno  如果返回的数据count等于0，加载物料信息的接口url为：/pickinglist?action=getDetailByMTid 参数：idEQ。否则：加载物料信息的接口url为：/pickinglist?action=getPartByMtId 参数：idEQ":"' '","bomnoEQ":"'   '","plancountEQ":"'  '"
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"isSpstatus",@"data":[NSString stringWithFormat:@"{\"bomnoEQ\":\"%@\"}",model.bomno]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * resultData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dic = [resultData objectAtIndex:0];
        NSString * count = dic[@"count"];
        if ([count integerValue] == 0) {
            [self dataCountIsEqual0Request:model];
        }else{
            [self dataCountIsNotEqual0Request:model];
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
-(void)dataCountIsEqual0Request:(ProMaterialModel*)model{
    [_resultData removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getDetailByMTid",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\"}",model.Id]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (arr.count == 0) {
            ProductMateriaDetailVC *detail = [[ProductMateriaDetailVC alloc] init];
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            for (NSDictionary *dic in  arr) {
                ProFinishModel *model = [[ProFinishModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_resultData addObject:model];
            }
            ProductingDetailVC *detail = [[ProductingDetailVC alloc] init];
            detail.resultArr = _resultData;
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
        }
//        [self initBottomView];
//        [_tbView reloadData];
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
-(void)dataCountIsNotEqual0Request:(ProMaterialModel*)model{
    [_resultData removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/pickinglist"];
    NSDictionary *params = @{@"action":@"getPartByMtId",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\",\"bomnoEQ\":\"%@\",\"plancountEQ\":\"%@\"}",model.Id,model.bomno,model.plancount]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (arr.count == 0) {
            ProductMateriaDetailVC *detail = [[ProductMateriaDetailVC alloc] init];
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            for (NSDictionary *dic in  arr) {
                ProFinishModel *model = [[ProFinishModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_resultData addObject:model];
            }
            ProductingDetailVC *detail = [[ProductingDetailVC alloc] init];
            detail.resultArr = _resultData;
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
        }
//        [self initBottomView];
//        [_tbView reloadData];
        
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
- (void)searchAction{
    NSLog(@"11");
    
}

- (void)addNext{
    [_searchDateArray removeAllObjects];
    ProductMaterialSearchVC * vc = [[ProductMaterialSearchVC alloc]init];
    [vc setBlock:^(NSString *bomno,NSString *planno,NSString *status,NSString *proname) {
        _bomno = bomno;
        _planno = planno;
        _status = status;
        _proname = proname;
        [self searchDataWithProName];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
