//
//  WuliuManageViewController.m
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/19.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "WuliuManageViewController.h"
#import "DataPost.h"
#import "ShipnoAndWuliuModel.h"
#import "WuliuDetailModel.h"
#import "WuliuShipnoCell.h"
#import "UIViewExt.h"
#import "WuliuDetailViewController.h"

@interface WuliuManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD* _HUD;
    NSMutableArray* _shipnoArray;
}
@property (nonatomic,strong)UITableView* tbView;
@property (nonatomic,strong)UILabel* wuliuemptyLabel;
@property (nonatomic,strong)UILabel* hintContrl;
@end

@implementation WuliuManageViewController


- (UITableView*)tbView{
    if (_tbView == nil) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tbView];
    }
    return _tbView;
}


- (UILabel*)wuliuemptyLabel{
    if (_wuliuemptyLabel == nil) {
        _wuliuemptyLabel = [[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth - 160)/2, (KscreenHeight - 30) / 2, 160, 30)];
        _wuliuemptyLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        _wuliuemptyLabel.font = [UIFont systemFontOfSize:14];
        _wuliuemptyLabel.textColor = [UIColor whiteColor];
        _wuliuemptyLabel.textAlignment = NSTextAlignmentCenter;
        _wuliuemptyLabel.text = @"暂时没有物流信息";
        _wuliuemptyLabel.hidden = YES;
        [self.view addSubview:_wuliuemptyLabel];
    }
    return _wuliuemptyLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流管理";
    self.navigationItem.rightBarButtonItem = nil;
    _shipnoArray = [[NSMutableArray alloc]init];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    [self creatUI];
    [self dataRequest];
    
}

- (void)creatUI{
    [self tbView];
    
    //初始化提示界面
    self.hintContrl = [[UILabel alloc] initWithFrame:CGRectMake((KscreenWidth - 160)/2, (KscreenHeight - 30) / 2, 160, 30)];
    self.hintContrl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    self.hintContrl.font = [UIFont systemFontOfSize:14];
    self.hintContrl.textColor = [UIColor whiteColor];
    self.hintContrl.textAlignment = NSTextAlignmentCenter;
    self.hintContrl.text = @"未查到发货单";
    self.hintContrl.hidden = YES;
    [self.view addSubview:_hintContrl];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return _shipnoArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    WuliuShipnoCell *nocell = [tableView dequeueReusableCellWithIdentifier:@"WuliuShipnoCellID"];
    if (!nocell) {
        nocell = [[[NSBundle mainBundle]loadNibNamed:@"WuliuShipnoCell" owner:self options:nil]firstObject];
    }

    
    if (tableView == _tbView) {
        if (_shipnoArray.count!=0) {
            nocell.model = _shipnoArray[indexPath.row];

        }
        [nocell setTransValue:^(BOOL click) {
            ShipnoAndWuliuModel* model = _shipnoArray[indexPath.row];
            model.shipno = [self convertNull:model.shipno];
            model.logisticsno = [self convertNull:model.logisticsno];
            for (int i = 0; i < _shipnoArray.count; i ++) {
                ShipnoAndWuliuModel* model = _shipnoArray[i];
                if (i == indexPath.row) {
                    model.select = @"1";
                    
                }else{
                    model.select = @"0";

                }
                [self wuliuemptyLabel];

                WuliuDetailViewController *deta = [[WuliuDetailViewController alloc]init];
                deta.shipno = model.shipno;
                deta.logisticsno = model.logisticsno;
                [self.navigationController pushViewController:deta animated:YES];
            }
        }];

        nocell.selectionStyle = UITableViewCellSelectionStyleNone;
        return nocell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _tbView) {
        ShipnoAndWuliuModel* model = _shipnoArray[indexPath.row];
        model.shipno = [self convertNull:model.shipno];
        model.logisticsno = [self convertNull:model.logisticsno];
        for (int i = 0; i < _shipnoArray.count; i ++) {
            ShipnoAndWuliuModel* model = _shipnoArray[i];
            if (i == indexPath.row) {
                model.select = @"1";
                WuliuDetailViewController *deta = [[WuliuDetailViewController alloc]init];
                deta.shipno = model.shipno;
                deta.logisticsno = model.logisticsno;
                [self.navigationController pushViewController:deta animated:YES];
            }else{
                model.select = @"0";
                [self wuliuemptyLabel];

            }
        }

        
    }
}



- (void)dataRequest{
/*
 查询发货单号和物流单号
 rootPath+'/order?action=searchShipOrderno&table=ddxx'+callback1
 参数{“orderno”:""}
 */
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    self.orderno = [self convertNull:self.orderno];
    NSDictionary *params = @{@"action":@"searchShipOrderno",@"table":@"ddxx",@"params":[NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderno]};
    
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSString *realStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回字符串%@",realStr);
        if ([realStr isEqualToString:@"\"sessionoutofdate\""] ||[realStr isEqualToString:@"sessionoutofdate"]) {
            [self selfLogin];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    ShipnoAndWuliuModel* model = [[ShipnoAndWuliuModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_shipnoArray addObject:model];
                }
                self.hintContrl.hidden = YES;
            }else{
                self.hintContrl.hidden = NO;
            }
            
            [_tbView reloadData];
        }
        [_HUD hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
         [_HUD hide:YES];
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




@end
