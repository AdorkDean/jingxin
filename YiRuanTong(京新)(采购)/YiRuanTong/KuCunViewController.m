//
//  KuCunViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "KuCunViewController.h"
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
#import "QLKucunSearchVC.h"
@interface KuCunViewController ()<UITextFieldDelegate>
{
    UIRefreshControl *_refreshControl;
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
    
    UIButton *_storageName;   //仓库名称
    UIButton *_proName;       //产品名称
    UITextField *_probatchField; //批次名称
    UITextField *_specificationField; //规格
    
    UILabel *_label1;   //总数量
    UILabel *_label2;   //总数量
    UILabel *_label3;   //总金额
    UITextField *_proField;
    NSMutableArray *_proArray;
    UITextField *_stoField;
    NSMutableArray *_stoArray;
    
    UIButton* _hide_keHuPopViewBut;
    NSInteger _stopage;
    NSInteger _propage;
}

@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *proTableView;
@property(nonatomic,retain)UITableView *stoTableView;

@end

@implementation KuCunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"库存查询";
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
    self.navigationItem.rightBarButtonItem = nil;
    [self showBarWithName:@"搜索" addBarWithName:@""];
    [self initTableView];
//    [self searchView];
    //进度HUD
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    [self DataRequest];
    [self getTotalSto];
}

- (void)initTableView{
    UIImageView *biaoTiView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 40)];
    biaoTiView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:biaoTiView];
    _label1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, KscreenWidth/3-1, 40)];
//    _label1.text = [NSString stringWithFormat:@"总数量:"];
    _label1.textColor =[UIColor blackColor];
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.numberOfLines = 2;
    _label1.backgroundColor =[UIColor clearColor];
    _label1.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:_label1];
    
    UIView * linev1 = [[UIView alloc]initWithFrame:CGRectMake(KscreenWidth/3, 5, 1, 40)];
    linev1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:linev1];
    
    _label2 =[[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/3 + 1,5, KscreenWidth/3, 40)];
    _label2.textColor =[UIColor blackColor];
//    _label2.text = [NSString stringWithFormat:@"总金额:"];
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.numberOfLines = 2;
    _label2.backgroundColor =[UIColor clearColor];
    _label2.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:_label2];
    UIView * linev2 = [[UIView alloc]initWithFrame:CGRectMake(KscreenWidth*2/3, 5, 1, 40)];
    linev2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:linev2];
    
    _label3 =[[UILabel alloc]initWithFrame:CGRectMake(linev2.right,5, KscreenWidth/3-1, 40)];
    _label3.textColor =[UIColor blackColor];
    //    _label2.text = [NSString stringWithFormat:@"总金额:"];
    _label3.textAlignment = NSTextAlignmentCenter;
    _label3.backgroundColor =[UIColor clearColor];
    _label3.numberOfLines = 2;
    _label3.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:_label3];
    UIView * linev3 = [[UIView alloc]initWithFrame:CGRectMake(0, _label3.bottom, KscreenWidth, 1)];
    linev3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:linev3];
    
    ////
    self.kuCunTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight - 64 - 49) style:UITableViewStylePlain];
    self.kuCunTableView.delegate = self;
    self.kuCunTableView.dataSource = self;
    self.kuCunTableView.rowHeight = 65;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.kuCunTableView addSubview:_refreshControl];
    [self.view addSubview:_kuCunTableView];
    //     下拉刷新
    _kuCunTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [_kuCunTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _kuCunTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _kuCunTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        [_kuCunTableView.mj_footer endRefreshing];
    }];

}
#pragma mark - 搜索页面点击方法
- (void)singleTapAction{
    _barHideBtn.hidden = YES;
    _backView.hidden = YES;
    _searchView.hidden = YES;
}
- (void)search{
//    [self getAllSto];
//    [self searchData];
}

- (void)searchDataWithStoName:(NSString *)stoname Proname:(NSString *)proname
{
    /*
     http://182.92.96.58:8005/yrt/servlet/stock
     action:"queryAllStock"
     page:"1"
     rows:"20"
     table:"kcxx"
     //圣地宝
     params:"{"table":"kcxx","storagenameLIKE":"成品库","pronameLIKE":"卵福康","probatchLIKE":"pici","helpnoLIKE":"","pronoLIKE":"","specificationLIKE":"guige","providerLIKE":"","producedateGE":"","producedateLE":"","validtimeGE":"","validtimeLE":""}"
     */
//    NSString *storagename = _storageName.titleLabel.text;
//    storagename = [self convertNull:storagename];
//    NSString  *proname = _proName.titleLabel.text;
    proname = [self convertNull:proname];
    stoname = [self convertNull:stoname];
    NSString *proNO = _probatchField.text;
    proNO = [self convertNull:proNO];
    NSString *specification = _specificationField.text;
    specification = [self convertNull:specification];
    
    if ([stoname isEqualToString:@" "]&&[proname isEqualToString:@" "]) {
        _searchFlag = 0;
    }else{
        _searchFlag = 1;
    }
    
    if (_searchPage == 1) {
        [_searchDateArray removeAllObjects];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/stock"];
    NSDictionary *params= @{@"action":@"queryAllStock",@"table":@"kcxx",@"page":[NSString stringWithFormat:@"%ld",(long)_searchPage],@"rows":@"20",@"params":[NSString stringWithFormat:@"{\"table\":\"kcxx\",\"storagenameLIKE\":\"%@\",\"pronameEQ\":\"%@\",\"probatchLIKE\":\"\",\"protypeidEQ\":\"\",\"pronoLIKE\":\"%@\",\"specificationLIKE\":\"%@\",\"providerLIKE\":\"\",\"producedateGE\":\"\",\"producedateLE\":\"\",\"validtimeGE\":\"\",\"validtimeLE\":\"\"}",stoname,proname,proNO,specification]};
    NSLog(@"搜索条件%@",params);
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"搜索列表:%@",array);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                KCcheckModel *model = [[KCcheckModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_searchDateArray addObject:model];
            }
        }
        [self.kuCunTableView reloadData];
        [_HUD hide:YES];
        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"搜索失败");
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

- (void)getAllStoWithStoName:(NSString *)stoname Proname:(NSString *)proname{
    
    /*params:"{"table":"kcxx","storagenameLIKE":"","pronameEQ":"口服液","probatchLIKE":"","protypeidEQ":"","pronoLIKE":"","specificationLIKE":"","providerLIKE":"","producedateGE":"","producedateLE":"","validtimeGE":"","validtimeLE":""}"*/
    
//    NSString *storagename = _storageName.titleLabel.text;
//    storagename = [self convertNull:storagename];
//    NSString  *proname = _proName.titleLabel.text;
    proname = [self convertNull:proname];
    stoname = [self convertNull:stoname];
    NSString *probatch = _probatchField.text;
    probatch = [self convertNull:probatch];
    NSString *specification = _specificationField.text;
    specification = [self convertNull:specification];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/stock?action=getStockAllCount"];
    NSDictionary *params= @{@"action":@"getStockAllCount",@"table":@"kcxx",@"params":[NSString stringWithFormat:@"{\"table\":\"kcxx\",\"storagenameLIKE\":\"%@\",\"pronameEQ\":\"%@\",\"probatchLIKE\":\"%@\",\"pronoLIKE\":\"\",\"specificationLIKE\":\"%@\",\"providerLIKE\":\"\",\"producedateGE\":\"\",\"producedateLE\":\"\",\"validtimeGE\":\"\",\"validtimeLE\":\"\"}",stoname,proname,probatch,specification]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"库存查询总计:%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            _label1.text = [NSString stringWithFormat:@"主总数量:%@",dic[@"zhu"]];
            _label2.text = [NSString stringWithFormat:@"副总数量:%@",dic[@"fu"]];
            _label3.text = [NSString stringWithFormat:@"总金额:%@",dic[@"zong"]];
          
        }

        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"搜索失败");
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
#pragma mark - 浏览数据
- (void)DataRequest
{
    //库存查询的接口
    /*
     /stock
     @"action":@"queryAllStock"
     */
    //数据接口拼接
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/stock"];
    NSDictionary *params = @{@"rows":@"20",@"mobile":@"true",@"page":[NSString stringWithFormat:@"%zi",_page],@"action":@"queryAllStock",@"table":@"kcxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        //NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"rows"];
        NSLog(@"库存查询列表:%@",array);
        for (NSDictionary *dic in array) {
            KCcheckModel *model = [[KCcheckModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.kuCunTableView reloadData];
        }
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"请求失败");
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        NSInteger errorCode = error.code;
        
        if (errorCode == 3840|| errorCode == 1001) {
            [self selfLogin];
        }else{
            UIAlertView *tan =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [tan show];
            
        }
        
    }];
    
}
- (void)getTotalSto{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/stock?action=getStockAllCount"];
    NSDictionary *params= @{@"action":@"getStockAllCount",@"table":@"kcxx"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"库存总计:%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            _label1.text = [NSString stringWithFormat:@"库存主数量:%@",dic[@"zhu"]];
            _label2.text = [NSString stringWithFormat:@"库存副数量:%@",dic[@"fu"]];
            _label3.text = [NSString stringWithFormat:@"库存总金额:%@",dic[@"zong"]];
        }
        
        _searchView.hidden = YES;
        _backView.hidden = YES;
        _barHideBtn.hidden = YES;
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"搜索失败");
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
//        [self searchData];
        [_refreshControl endRefreshing];
    }else{
        [_dataArray removeAllObjects];
        _page = 1;
        [self DataRequest];
        
        [self getTotalSto];
        [_refreshControl endRefreshing];
    }
}

- (void)upRefresh
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
//        [self searchData];
    }else{
        [_HUD show:YES];
        _page++;
        [self DataRequest];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 10) {
//        [self upRefresh];
    }
}

#pragma mark UITableViewDelegateAndDataSource

//返回每个section上cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.proTableView) {
        return _proArray.count;
    }else if (tableView ==self.stoTableView){
        return _stoArray.count;
    }else{
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _dataArray.count;
        }
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
        cell1.model = _proArray[indexPath.row];
        }
        return cell1;
    }else if (tableView == self.kuCunTableView){
        if (_searchFlag == 1) {
            if (_searchDateArray.count!=0) {
                cell.model = _searchDateArray[indexPath.row];
            }
        }else{
            if (_dataArray.count != 0) {
                cell.model = _dataArray[indexPath.row];
            }
        }
        return cell;

    }else if(tableView == self.stoTableView){
        if (_stoArray.count != 0) {
            CommonModel *model = _stoArray[indexPath.row];
            cell2.textLabel.text = model.name;
            return cell2;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.kuCunTableView) {
        KuCunDetailView *kuCunMessage=[[KuCunDetailView alloc] init];
        if (_searchFlag == 1) {
            KCcheckModel *model = [_searchDateArray objectAtIndex:indexPath.row];
            kuCunMessage.model = model;
        }else{
            KCcheckModel *model = [_dataArray objectAtIndex:indexPath.row];
            kuCunMessage.model = model;
        }
        [self.navigationController pushViewController:kuCunMessage animated:YES];
    }else if (tableView == self.proTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_proArray.count!=0) {
            THCPModel *model = _proArray[indexPath.row];
            [_proName setTitle:model.proname forState:UIControlStateNormal];
            _probatchField.text = [NSString stringWithFormat:@"%@",model.prono];
            _specificationField.text = model.specification;
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
- (void)searchAction{
    
}
- (void)addNext{
    [_searchDateArray removeAllObjects];
    QLKucunSearchVC * vc = [[QLKucunSearchVC alloc]init];
    [vc setBlock:^(NSString *stoname,NSString *proaname) {
        [self searchDataWithStoName:stoname Proname:proaname];
        [self getAllStoWithStoName:stoname Proname:proaname];
    }];
    [self.navigationController pushViewController:vc animated:YES];
//    if ([_searchView isHidden]) {
//        _searchView.hidden = NO;
//        _backView.hidden = NO;
//        _barHideBtn.hidden = NO;
//    }
//    else if (![_searchView isHidden])
//    {
//        _searchView.hidden = YES;
//        _backView.hidden = YES;
//        _barHideBtn.hidden = YES;
//    }

}

@end
