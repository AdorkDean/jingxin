//
//  ZhangKuanViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZhangKuanViewController.h"
#import "MainViewController.h"
#import "ZhangKuanSearchVC.h"
#import "KeHuHKCell.h"
#import "YingShouKuanCell.h"
#import "FuKuanDetailView.h"
#import "DataPost.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "KHfukuanModel.h"
#import "YingShouKuanModel.h"
#import "KHnameModel.h"
#import "UIViewExt.h"
#import "CustModel.h"
#import "CustCell.h"
#import "QLKeHuYSCell.h"
@interface ZhangKuanViewController ()<UITextFieldDelegate>

{
    UIRefreshControl *_refreshControl;
    UIRefreshControl *_refreshControl2;
    UIRefreshControl *_refreshControl3;
    UIRefreshControl *_refreshControl4;
    UIView *_searchView;
    UIView *_backView;
    UIButton* _barHideBtn;
    
    UITextField *_searchContent;
    MBProgressHUD *_HUD;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    NSMutableArray *_dataArray3;
    NSMutableArray *_salerArray;
    NSMutableArray *_custSalerArray;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    NSInteger _page;
    NSInteger _page4;
    NSInteger _page6;
    NSInteger _searchPage;
    NSInteger _searchFlag;
    NSMutableArray* _searchDateArray;
    NSInteger _searchPage1;
    NSMutableArray* _searchDateArray1;
    
    
    UIButton *_keHuYSKbutton;
    UIButton *_yeWuYuanHuYSKbutton;
    
    UIButton *_currentBtn;
    NSMutableArray *_btnArray;
    NSMutableArray *_dataArray;
    UIButton *_custButton;
    UIButton *_salerButton;
    
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UILabel *_label4;
   
    UILabel *_label11;
    UILabel *_label21;
    UILabel *_label31;
    UILabel *_label41;
    
    
    UITextField *_custField;
    NSString *_custId;
    UITextField *_salerField;
    NSString *_salerId;
    UIButton *_custSalerButton;
    NSString *_custSalerId;
    UITextField *_custSalerField;
    
    UIButton *_startButton;
    UIButton *_endButton;
    UIView *_timeView;
   
    
    NSString *_currentDateStr;
    NSString *_pastDateStr;
    UIButton* _hide_keHuPopViewBut;
    NSInteger _custpage;
    NSInteger _salerpage;
}

@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *custTableView;
@property(nonatomic,retain)UITableView *salerTableView;
@property(nonatomic,retain)UIDatePicker *datePicker;
@property(nonatomic,retain)UITableView *custSalerTableView;

@end

@implementation ZhangKuanViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"销售账务";
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    _dataArray3 = [[NSMutableArray alloc] init];
    _dataArray = [NSMutableArray array];
    _btnArray = [[NSMutableArray alloc] init];
    _custSalerArray = [[NSMutableArray alloc]init];
    _searchDateArray = [[NSMutableArray alloc]init];
    _searchDateArray1 = [[NSMutableArray alloc]init];
    _searchPage1 = 1;
    _searchPage = 1;
    _searchFlag = 0;
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    _page = 1;
    _page4 = 1;
    _page6 = 1;
    _custpage = 1;
    _salerpage = 1;
    self.navigationItem.rightBarButtonItem  = nil;

    [self PageViewDidLoad];
    [self getDateStr];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
   
    [self getDateStr];
    [self DataRequest];
    [self dataRequest];
    [self DataRequest1];
    [self dataRequest2];

    [_HUD hide:YES afterDelay:.5];
    
   
    
}


#pragma mark -搜索页面方法
- (void)singleTapAction{
    _barHideBtn.hidden = YES;
    _backView.hidden = YES;
    _searchView.hidden = YES;
}

- (void)getName{
    
    NSString *custName = _custField.text;
    custName = [self convertNull:custName];
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
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
    
}

- (void)souSuoButtonClickMethod
{
    
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
    
    [_searchDateArray removeAllObjects];
    if (_currentBtn.tag == 0) {
        ZhangKuanSearchVC * vc = [[ZhangKuanSearchVC alloc]init];
        vc.flag = @"0";
        [vc setBlock:^(NSString *custid, NSString *saleid, NSString *start, NSString *end) {
            [self searchDataWithCustid:custid CustSalerid:saleid andStart:start end:end];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZhangKuanSearchVC * vc = [[ZhangKuanSearchVC alloc]init];
        vc.flag = @"1";
        [vc setBlock:^(NSString *custid, NSString *saleid, NSString *start, NSString *end) {
            [self searchDataWithCustid:custid CustSalerid:saleid andStart:start end:end];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)getCustSaler{
    
    NSString *custSaler = _custSalerField.text;
    custSaler = [self  convertNull:custSaler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",custSaler]};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"业务员数据%@",array);
        _custSalerArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CustModel *model = [[CustModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_custSalerArray addObject:model];
        }
        [self.custSalerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员名称加载失败");
    }];


}

- (void)custSalerRequest{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh"};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"业务员数据%@",array);
        _custSalerArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CustModel *model = [[CustModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_custSalerArray addObject:model];
        }
        [self.custSalerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员名称加载失败");
    }];
    
}





- (void)getSalerName{
    
    NSString *saler = _salerField.text;
    saler = [self convertNull:saler];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"yhzh",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"业务员数据%@",array);
        _salerArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CustModel *model = [[CustModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_salerArray addObject:model];
        }
        [self.salerTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员名称加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];

    

}



#pragma mark - 搜索点击方法
- (void)search
{
    
}

- (void)searchDataWithCustid:(NSString *)custid CustSalerid:(NSString *)custsalerid andStart:(NSString *)start end:(NSString *)end
{
    /*
     */
    _searchView.hidden = YES;
    _backView.hidden = YES;
    _barHideBtn.hidden = YES;
    if(_currentBtn.tag == 0){
        [_HUD show:YES];
        custid = [self convertNull:custid];
        _pastDateStr  =  start;
        start = [self convertNull:start];
        _currentDateStr  =  end;
        end = [self convertNull:end];
        custsalerid = [self convertNull:custsalerid];
        if (_searchPage == 1) {
            [_searchDateArray removeAllObjects];
        }
        if ([start isEqualToString:@""]&&[custsalerid isEqualToString:@""]&&[start isEqualToString:@" "]&&[end isEqualToString:@""]) {
            _searchFlag = 0;
        }else{
            _searchFlag = 1;
        }
        [self getcustSearchWithCustSalerid:custsalerid Custid:custid Start:start End:end];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing"];
        NSDictionary *params = @{@"action":@"customerYingShouMingxiModel",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage],@"params":[NSString stringWithFormat:@"{\"table\":\"hkjz\",\"custidEQ\":\"%@\",\"saleridEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\",\"type\":\"3\"}",custid,custsalerid,start,end]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"返回字符串%@",realStr);
            if ([realStr isEqualToString:@"sessionoutofdate"]) {
                [self selfLogin];
            }else{
                
                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"搜索应收款数据%@",dic);
                NSArray *array = dic[@"rows"];
                for (NSDictionary *dic in array) {
                    KHfukuanModel *model = [[KHfukuanModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray addObject:model];
                }
                
                [self.keHuYFKTableView reloadData];
                [_HUD hide:YES];
            }
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            [_HUD hide:YES];
            NSInteger errorCode = error.code;
            NSLog(@"错误信息%@",error);
            if (errorCode == 3840 ) {
                NSLog(@"自动登录");
                [self selfLogin];
            }else{
                // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
            }
        }];
    } else if(_currentBtn.tag == 1){
        /*
         */
        [_HUD show:YES];
        custsalerid = [self convertNull:custsalerid];
        _pastDateStr  =  start;
        start = [self convertNull:start];
        _currentDateStr  =  end;
        end = [self convertNull:end];
        
        if (_searchPage1 == 1) {
            [_searchDateArray1 removeAllObjects];
        }
        if ([custid isEqualToString:@""]&&[custsalerid isEqualToString:@""]&&[start isEqualToString:@""]&&[end isEqualToString:@""]) {
            _searchFlag = 0;
        }else{
            _searchFlag = 1;
        }
        [self getSearchWithCustSalerid:custsalerid Custid:custid Start:start End:end];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing"];
        NSDictionary *params = @{@"action":@"yewuyuanyingshoumingxichaxun",@"table":@"hkjz",@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_searchPage1],@"params":[NSString stringWithFormat:@"{\"table\":\"hkjz\",\"saleridEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",custsalerid,start,end]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"返回字符串%@",realStr);
            if ([realStr isEqualToString:@"sessionoutofdate"]) {
                [self selfLogin];
            }else{
                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                NSArray *array = dic[@"rows"];
                NSLog(@"搜索数据:%@",array);
                for (NSDictionary *dic in array) {
                    YingShouKuanModel *model = [[YingShouKuanModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_searchDateArray1  addObject:model];
                }
                
                [self.yeWuYuanYFKTableView reloadData];
                [_HUD hide:YES];
            }
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            [_HUD hide:YES];
            NSInteger errorCode = error.code;
            NSLog(@"错误信息%@",error);
            if (errorCode == 3840 ) {
                NSLog(@"自动登录");
                [self selfLogin];
            }else{
                // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
            }
        }];
    }

}

- (void)getcustSearchWithCustSalerid:(NSString *)custsalerid Custid:(NSString *)custid Start:(NSString *)start End:(NSString *)end{
    
    _pastDateStr  =  start;
    start = [self convertNull:start];
    _currentDateStr  =  end;
    end = [self convertNull:end];
    custsalerid = [self convertNull: custsalerid];
    custid = [self convertNull: custid];
    //客户回款总计
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing?action=custyingshouzongji"];
    NSDictionary *params = @{@"action":@"custyingshouzongji",@"params":[NSString stringWithFormat:@"{\"table\":\"hkjz\",\"custidEQ\":\"%@\",\"saleridEQ\":\"%@\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\",\"type\":\"3\"}",custid,custsalerid,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户总数据%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            
            _label11.text = [NSString stringWithFormat:@" 期初:%@",dic[@"qichu"]];
            _label21.text = [NSString stringWithFormat:@" 本期应收:%@",dic[@"totalyingfashengjine"]];
            _label41.text = [NSString stringWithFormat:@" 本期收回:%@",dic[@"totalfashengjine"]];
            _label31.text = [NSString stringWithFormat:@" 余额:%@",dic[@"yue"]];

            
        }
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员总计加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];
    
    


}
- (void)getSearchWithCustSalerid:(NSString *)custsalerid Custid:(NSString *)custid Start:(NSString *)start End:(NSString *)end{
    //业务员汇款总计
    custsalerid = [self convertNull:custsalerid];
    _pastDateStr  =  start;
    start = [self convertNull:start];
    _currentDateStr  =  end;
    end = [self convertNull:end];
    custid = [self convertNull:custid];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing?action=salerTotal"];
    NSDictionary *params = @{@"action":@"salerTotal",@"params":[NSString stringWithFormat:@"{\"table\":\"hkjz\",\"custnameLIKE\":\"\",\"saleridEQ\":\"%@\",\"shipnoLIKE\":\"\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",custsalerid,start,end]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"应收款数据%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            _label1.text = [NSString stringWithFormat:@" 期初:%@",dic[@"totalqichujine1"]];
            _label2.text = [NSString stringWithFormat:@" 本期应收:%@",dic[@"totalyingfashengjine1"]];
            _label4.text = [NSString stringWithFormat:@" 余额:%@",dic[@"totalyue1"]];
            _label3.text = [NSString stringWithFormat:@" 本期收回:%@",dic[@"totalfashengjine1"]];

        }
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员总计加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];

}

//- (void)chongZhi
//{
//    [_custButton setTitle:@" " forState:UIControlStateNormal];
//    [_custSalerButton setTitle:@" " forState:UIControlStateNormal];
//    [_startButton setTitle:@" " forState:UIControlStateNormal];
//    [_endButton setTitle:@" " forState:UIControlStateNormal];
//}

#pragma mark - 客户
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



- (void)DataRequest
{
    /*
     financing
     action=customerBenQIYingShou
     params	{"custidEQ":"","danjuhaoEQ":"","createtimeGE":"","createtimeLE":""}
     请求方式	Post
     返回值	{"total":34,"page_number":1,"rows":[{"id":114,"danjuhao":"TH201508270001","zhaiyao":"退货单","custname":"济南大智","custid":2078,"saler":"杨震","salerid":153,"qichujine":-5534,"fashengjine":0,"yue":-5546,"kehudizhi":"","createtime":"2015-09-06 15:58:44","yingfashengjine":12,"bizhong":"人民币"}]}

     
     */
   //客户应收款
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing?action=customerYingShouMingxiModel"];
    NSDictionary *params = @{@"page":[NSString stringWithFormat:@"%zi",_page1],@"rows":@"20",@"action":@"customerYingShouMingxiModel",@"params":[NSString stringWithFormat:@"{\"table\":\"hkjz\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\",\"type\":\"3\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
       // NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
            [self selfLogin];
        }else{
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"应收款小计%@",dic);
            NSArray *array = dic[@"rows"];
            for (NSDictionary *dic in array) {
                KHfukuanModel *model = [[KHfukuanModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray1 addObject:model];
            }
            
            [self.keHuYFKTableView reloadData];
        
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"应收款加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];


}
- (void)dataRequest{

    //客户回款总计
    /*
     action:"custyingshouzongji"
     params:"{"custidEQ":"","danjuhaoEQ":"","createtimeGE":"","createtimeLE":""}"
     
      返回
     totalyingfashengjine:26471
     totalfashengjine:-23673
     qichu:4285
     
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing?action=custyingshouzongji"];
    NSDictionary *params = @{@"action":@"custyingshouzongji",@"params":[NSString stringWithFormat:@"{\"table\":\"hkjz\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\",\"type\":\"3\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
       // NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"sessionoutofdate"]||[realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else{
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"客户总数据%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            
            _label11.text = [NSString stringWithFormat:@" 期初:%@",dic[@"qichu"]];
            _label21.text = [NSString stringWithFormat:@" 本期应收:%@",dic[@"totalyingfashengjine"]];
            _label41.text = [NSString stringWithFormat:@" 本期收回:%@",dic[@"totalfashengjine"]];
            _label31.text = [NSString stringWithFormat:@" 余额:%@",dic[@"yue"]];
        
            }
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        if (errorCode == 3840|| errorCode == 1001) {
            [self selfLogin];
        }else if(errorCode == -1004){
            
            [self showAlert:@"未检测到网络，请检查网络连接!"];
        }else{
            
        }


        NSLog(@"业务员总计加载失败");
    }];




}

#pragma mark - 业务员
- (void)DataRequest1
{
    /*financing
     action=yewuyuanyingshoumingxichaxun
     
     params	{"saleridEQ":"","createtimeGE":"","createtimeLE":""}
     请求方式	Post
     */
    //业务员应收款的接口
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing?action=yewuyuanyingshoumingxichaxun"];
     NSDictionary *parameters = @{@"rows":@"20",@"page":[NSString stringWithFormat:@"%zi",_page2],@"action":@"yewuyuanyingshoumingxichaxun",@"params":[NSString stringWithFormat:@"{\"table\":\"hkjz\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\",\"type\":\"3\"}",_pastDateStr,_currentDateStr]};
    
    [DataPost requestAFWithUrl:urlStr params:parameters finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
       // NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"业务员应收款数据%@",dic);
        NSArray *array = dic[@"rows"];
        for (NSDictionary *dic in array) {
            YingShouKuanModel *model = [[YingShouKuanModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray2 addObject:model];
        }
        [self.yeWuYuanYFKTableView reloadData];
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSInteger errorCode = error.code;
        [_HUD hide:YES];
        [_HUD removeFromSuperview];
        if (errorCode == 3840|| errorCode == 1001) {
            [self selfLogin];
        }else if(errorCode == -1004){
            
            [self showAlert:@"未检测到网络，请检查网络连接!"];
        }else{
            
        }

    }];
    
}
- (void)dataRequest2{
    //业务员回款总计
     NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/financing?action=salerTotal"];
    NSDictionary *params = @{@"action":@"salerTotal",@"params":[NSString stringWithFormat:@"{\"table\":\"hkjz\",\"createtimeGE\":\"%@\",\"createtimeLE\":\"%@\"}",_pastDateStr,_currentDateStr]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""]) {
            [self selfLogin];
        }else if ([realStr isEqualToString:@"sessionoutofdate"]){
             [self selfLogin];
        }else{
        
        NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"业务员总计数据%@",array);
        if (array.count != 0) {
            NSDictionary *dic = array[0];
            
            _label1.text = [NSString stringWithFormat:@" 期初:%@",dic[@"totalqichujine1"]];
            _label2.text = [NSString stringWithFormat:@" 本期应收:%@",dic[@"totalyingfashengjine1"]];
            _label3.text = [NSString stringWithFormat:@" 余额:%@",dic[@"totalyue1"]];
            _label4.text = [NSString stringWithFormat:@" 本期收回:%@",dic[@"totalfashengjine1"]];

        
        }
        }

    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"业务员总计加载失败");
        NSInteger errorCode = error.code;
        NSLog(@"错误信息%@",error);
        if (errorCode == 3840 ) {
            NSLog(@"自动登录");
            [self selfLogin];
        }else{
            
            // [self showAlert:[NSString stringWithFormat:@"连接服务器失败,错误码%zi",errorCode]];
        }

    }];


}


#pragma  mark  -View
- (void)PageViewDidLoad
{
    //标题下方的3个按钮和view;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 49)];
    [self.view addSubview:buttonView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(souSuoButtonClickMethod)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(souSuoButtonClickMethod)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    //3个按钮的设置
    _keHuYSKbutton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth/2, 49)];
    [_keHuYSKbutton setTitle:@"客户应收款" forState:UIControlStateNormal];
    _keHuYSKbutton.tag = 0;
    [_keHuYSKbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_keHuYSKbutton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _keHuYSKbutton.backgroundColor = [UIColor whiteColor];
    _currentBtn = _keHuYSKbutton;
    _currentBtn.selected = YES;
    
    [_keHuYSKbutton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _keHuYSKbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonView addSubview:_keHuYSKbutton];
    
    [_btnArray addObject:_keHuYSKbutton];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(_keHuYSKbutton.right, 10, 1, _keHuYSKbutton.height-20)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    _yeWuYuanHuYSKbutton =[[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth/2+1, 0, KscreenWidth/2, 49)];
    [_yeWuYuanHuYSKbutton setTitle:@"业务员应收款" forState:UIControlStateNormal];
    _yeWuYuanHuYSKbutton.tag = 1;
    UILabel *boline = [[UILabel alloc] initWithFrame:CGRectMake(0, _yeWuYuanHuYSKbutton.bottom-3, KscreenWidth, 1)];
    boline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:boline];
    [_yeWuYuanHuYSKbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_yeWuYuanHuYSKbutton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
   // _yeWuYuanHuYSKbutton.backgroundColor = [UIColor lightGrayColor];
    
    [_yeWuYuanHuYSKbutton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _yeWuYuanHuYSKbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonView addSubview:_yeWuYuanHuYSKbutton];
    [_btnArray addObject:_yeWuYuanHuYSKbutton];
    
    
    
    //标题下方View的设置;
    //UIScrollerView
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50,KscreenWidth, KscreenHeight-114)];
    self.mainScrollView.contentSize = CGSizeMake(KscreenWidth *2, KscreenHeight-114);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    //scrollView上面的三个tableview实例化 并且添加到scrollView上去
    // 客户
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 40)];
//    backView1.backgroundColor = COLOR(230, 230, 230, 1);
    backView1.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:backView1];
    _label11 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth/2, 20)];
    _label11.font = [UIFont systemFontOfSize:14];
    _label11.textColor = [UIColor lightGrayColor];
    _label11.font = [UIFont systemFontOfSize:14];
    _label11.textAlignment = NSTextAlignmentCenter;
    _label21 = [[UILabel alloc] initWithFrame:CGRectMake( KscreenWidth/2, 0, KscreenWidth/2, 20)];
    _label21.font = [UIFont systemFontOfSize:14];
    _label21.textColor = [UIColor lightGrayColor];
    _label21.textAlignment = NSTextAlignmentCenter;
    _label31 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, KscreenWidth/2, 20)];
    _label31.font = [UIFont systemFontOfSize:14];
    _label31.textColor = [UIColor lightGrayColor];
    _label31.textAlignment = NSTextAlignmentCenter;
    _label41 = [[UILabel alloc] initWithFrame:CGRectMake( KscreenWidth/2, 20, KscreenWidth/2, 20)];
    _label41.font = [UIFont systemFontOfSize:14];
    _label41.textColor = [UIColor lightGrayColor];
    _label41.textAlignment = NSTextAlignmentCenter;
    [self.mainScrollView addSubview:_label11];
    [self.mainScrollView addSubview:_label21];
    [self.mainScrollView addSubview:_label31];
    [self.mainScrollView addSubview:_label41];
    
    self.keHuYFKTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight- 64 - 50 - 45) style:UITableViewStyleGrouped];
    self.keHuYFKTableView.delegate = self;
    self.keHuYFKTableView.dataSource = self;
    self.keHuYFKTableView.tag = 10;
    self.keHuYFKTableView.rowHeight = 100;
//    _refreshControl = [[UIRefreshControl alloc] init];
//    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
//    [self.keHuYFKTableView addSubview:_refreshControl];
    [self.mainScrollView addSubview:self.keHuYFKTableView];
    //     下拉刷新
    self.keHuYFKTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown];
        // 结束刷新
        [self.keHuYFKTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.keHuYFKTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.keHuYFKTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh1];
        [self.keHuYFKTableView.mj_footer endRefreshing];
    }];
    //业务员
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth, 40)];
//    backView.backgroundColor = COLOR(230, 230, 230, 1);
    backView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:backView];
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth, 0, KscreenWidth/2, 20)];
    _label1.font = [UIFont systemFontOfSize:14];
    _label1.textColor = [UIColor lightGrayColor];
     _label1.textAlignment = NSTextAlignmentCenter;
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth + KscreenWidth/2, 0, KscreenWidth/2, 20)];
    _label2.font = [UIFont systemFontOfSize:14];
    _label2.textColor = [UIColor lightGrayColor];
    _label2.textAlignment = NSTextAlignmentCenter;
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth, 20, KscreenWidth/2, 20)];
    _label3.font = [UIFont systemFontOfSize:14];
    _label3.textColor = [UIColor lightGrayColor];
    _label3.textAlignment = NSTextAlignmentCenter;
    _label4 = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth + KscreenWidth/2, 20, KscreenWidth/2, 20)];
    _label4.font = [UIFont systemFontOfSize:14];
    _label4.textColor = [UIColor lightGrayColor];
    _label4.textAlignment = NSTextAlignmentCenter;
    [self.mainScrollView addSubview:_label1];
    [self.mainScrollView addSubview:_label2];
    [self.mainScrollView addSubview:_label3];
    [self.mainScrollView addSubview:_label4];
    
   

    
    self.yeWuYuanYFKTableView = [[UITableView alloc] initWithFrame:CGRectMake(KscreenWidth, 50, KscreenWidth, KscreenHeight- 114 - 45) style:UITableViewStyleGrouped];
    self.yeWuYuanYFKTableView.delegate=self;
    self.yeWuYuanYFKTableView.dataSource =self;
    self.yeWuYuanYFKTableView.tag = 20;
    self.yeWuYuanYFKTableView.rowHeight = 100;
//    _refreshControl2 = [[UIRefreshControl alloc] init];
//    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"开始刷新..."];
//    [_refreshControl2 addTarget:self action:@selector(refreshData2) forControlEvents:UIControlEventValueChanged];
//    [self.yeWuYuanYFKTableView addSubview:_refreshControl2];
    [self.mainScrollView addSubview:self.yeWuYuanYFKTableView];
    //     下拉刷新
    self.yeWuYuanYFKTableView.mj_header= [HTRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshDown2];
        // 结束刷新
        [self.yeWuYuanYFKTableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.yeWuYuanYFKTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.yeWuYuanYFKTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        [self upRefresh2];
        [self.yeWuYuanYFKTableView.mj_footer endRefreshing];
    }];
        
    //搜索按钮的设置
    self.souSuoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.souSuoButton.frame =CGRectMake(8, 15, 25, 25);
    [self.souSuoButton setBackgroundImage:[UIImage imageNamed:@"souSuo.png"] forState:UIControlStateNormal];
    [self.souSuoButton setBackgroundImage:[UIImage imageNamed:@"menu_return"] forState:UIControlStateHighlighted];
    [buttonView addSubview:self.souSuoButton];
    [self.souSuoButton addTarget:self action:@selector(souSuoButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectBtn:(UIButton *)btn
{
    if (btn != _currentBtn)
    {
        _currentBtn.selected = NO;
      //  _currentBtn.backgroundColor = [UIColor lightGrayColor];
        _currentBtn = btn;
    }
    _currentBtn.selected = YES;
    _currentBtn.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView setContentOffset:CGPointMake(btn.tag * KscreenWidth, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //随着整页滑动的相关栏目的变色及移动  对应起来好看！
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    } else {
        int i = scrollView.contentOffset.x/KscreenWidth;
        for (int j = 0; j < _btnArray.count; j++) {
            if (j == i) {
                if (_btnArray[i] != _currentBtn) {
                    _currentBtn.selected = NO;
           //         _currentBtn.backgroundColor = [UIColor lightGrayColor];
                    _currentBtn = _btnArray[i];
                }
                _currentBtn.selected = YES;
                _currentBtn.backgroundColor = [UIColor whiteColor];
            }
        }
    }
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
        [_dataArray1 removeAllObjects];
        _page1 = 1;
        [self DataRequest];
        [self dataRequest];
        [_refreshControl endRefreshing];
    }
}

- (void)refreshData2
{
    //开始刷新
    _refreshControl2.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    [_refreshControl2 beginRefreshing];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDown2) userInfo:nil repeats:NO];
}

- (void)refreshDown2
{
    if (_searchFlag == 1) {
        [_searchDateArray1 removeAllObjects];
        _searchPage1 = 1;
//        [self searchData];
        [_refreshControl2 endRefreshing];
    }else{
        [_dataArray2 removeAllObjects];
        _page2 = 1;
        [self DataRequest1];
        [self dataRequest2];
        [_refreshControl2 endRefreshing];
    }
}





- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag == 10) {
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh1];
        }
        
    } else if (scrollView.tag == 20){
        if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//            [self upRefresh2];
        }
    } else  if (scrollView.tag == 40){
            if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
//                [self upRefresh4];
            }
   
    }

}

- (void)upRefresh1
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage++;
//        [self searchData];
    }else{
        [_HUD show:YES];
        _page1++;
        [self DataRequest];
    }
}

- (void)upRefresh2
{
    if (_searchFlag == 1) {
        [_HUD show:YES];
        _searchPage1++;
//        [self searchData];
    }else{
        [_HUD show:YES];
        _page2++;
        [self DataRequest1];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDelegateAndDataSource协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.keHuYFKTableView) {
        if (_searchFlag == 1) {
            return _searchDateArray.count;
        }else{
            return _dataArray1.count;
        }
    }else if (tableView == self.yeWuYuanYFKTableView){
        if (_searchFlag == 1) {
            return _searchDateArray1.count;
        }else{
            return _dataArray2.count;
        }
    }else if (tableView == self.custTableView){
        return _dataArray.count;
    }else if (tableView == self.salerTableView){
        return _salerArray.count;
    }else if (tableView == self.custSalerTableView){
        return _custSalerArray.count;
    }
    return 0;
}
//返回section的cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 1;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"QLKeHuYSCell";
    QLKeHuYSCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell =(QLKeHuYSCell *) [[[NSBundle mainBundle] loadNibNamed:@"QLKeHuYSCell" owner:self options:nil]firstObject];
    }
    YingShouKuanCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 =(YingShouKuanCell*)[[[NSBundle mainBundle] loadNibNamed:@"YingShouKuanCell" owner:self options:nil]firstObject];
    }
    
    CustCell *cell2  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell2 == nil) {
        cell2 = (CustCell *)[[[NSBundle mainBundle] loadNibNamed:@"CustCell" owner:self options:nil]firstObject];
        cell2.backgroundColor = [UIColor whiteColor];
    }

    UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell3 == nil) {
        cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell3.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    if (tableView == self.keHuYFKTableView){
        if (_searchFlag == 1) {
            if (_searchDateArray.count!= 0) {
                cell.model = _searchDateArray[indexPath.section];
            }
        }else{
            if (_dataArray1.count != 0) {
                cell.model = _dataArray1[indexPath.section];
            }
        }
        return cell;
    } else if (tableView == self.yeWuYuanYFKTableView){
        if (_searchFlag == 1) {
            if (_searchDateArray1.count!=0) {
                YingShouKuanModel * model = _searchDateArray1[indexPath.section];
                cell.custName.text = [NSString stringWithFormat:@"业务员:%@",model.saler];
                cell.xiaoji.hidden = YES;
                cell.qichu.text = [NSString stringWithFormat:@"期初:%@",model.totalqichujine];
                cell.yingshou.text = [NSString stringWithFormat:@"本期应收%@",model.totalyingfashengjine];
                cell.shouhui.text = [NSString stringWithFormat:@"本期收回:%@",model.totalfashengjine];
                cell.yue.text = [NSString stringWithFormat:@"余额:%@",model.totalyue];
            }
        }else{
            if (_dataArray2.count != 0) {
                YingShouKuanModel * model = _dataArray2[indexPath.section];
                cell.custName.text = [NSString stringWithFormat:@"业务员:%@",model.saler];
                cell.xiaoji.hidden = YES;
                cell.qichu.text = [NSString stringWithFormat:@"期初:%@",model.totalqichujine];
                cell.yingshou.text = [NSString stringWithFormat:@"本期应收%@",model.totalyingfashengjine];
                cell.shouhui.text = [NSString stringWithFormat:@"本期收回:%@",model.totalfashengjine];
                cell.yue.text = [NSString stringWithFormat:@"余额:%@",model.totalyue];
            }
            
        }
        return cell;
    }else if(tableView == self.custTableView){
       
        cell2.model = _dataArray[indexPath.section];
        return cell2;
    }else if (tableView == self.salerTableView){
        CustModel *model = _salerArray[indexPath.section];
        cell3.textLabel.text = model.name;
        return cell3;
    }else if (tableView == self.custSalerTableView){
        if (_custSalerArray.count!=0) {
            CustModel *model = _custSalerArray[indexPath.section];
            cell3.textLabel.text = model.name;
        }
        return cell3;
    }
    return cell;
}
//点击事件，进入付款详情页面;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.keHuYFKTableView){
        if (_searchFlag == 1) {
            if (_searchDateArray.count != 0) {
                FuKuanDetailView *fuKuanMessage =[[FuKuanDetailView alloc] init];
                KHfukuanModel *model = [_searchDateArray objectAtIndex:indexPath.section];
                fuKuanMessage.custId = model.custid;
                fuKuanMessage.createtimeGE = _pastDateStr;
                fuKuanMessage.createtimeLE = _currentDateStr;
                [self.navigationController pushViewController:fuKuanMessage animated:YES];
            }
        }else{
            if (_dataArray1.count != 0) {
                FuKuanDetailView *fuKuanMessage =[[FuKuanDetailView alloc] init];
                KHfukuanModel *model = [_dataArray1 objectAtIndex:indexPath.section];
                fuKuanMessage.custId = model.custid;
                fuKuanMessage.createtimeGE = _pastDateStr;
                fuKuanMessage.createtimeLE = _currentDateStr;
                [self.navigationController pushViewController:fuKuanMessage animated:YES];
            }
        }
    } else if(tableView == self.custTableView){
        CustModel *model = _dataArray[indexPath.section];
        [_custButton setTitle:model.name forState:UIControlStateNormal];
        _custId = model.Id;
        _custButton.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
    } else if (tableView == self.salerTableView){
        [self.m_keHuPopView removeFromSuperview];
        CustModel *model = _salerArray[indexPath.section];
        [_custButton setTitle:model.name forState:UIControlStateNormal];
        _custButton.userInteractionEnabled = YES;
        _salerId = model.Id;
    }else if (tableView == self.custSalerTableView){
        [self.m_keHuPopView removeFromSuperview];
        if (_custSalerArray.count!=0) {
            CustModel *model = _custSalerArray[indexPath.section];
            [_custSalerButton setTitle:model.name forState:UIControlStateNormal];
            _custSalerId = model.Id;
            _custSalerButton.userInteractionEnabled = YES;
        }
    }
}




@end
