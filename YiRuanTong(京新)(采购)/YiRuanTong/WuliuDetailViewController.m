//
//  WuliuDetailViewController.m
//  YiRuanTong
//
//  Created by apple on 17/7/28.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "WuliuDetailViewController.h"
#import "WuliuDetailCell.h"
#import "UIViewExt.h"
#import "DataPost.h"

@interface WuliuDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD* _HUD;

    NSMutableArray* _wuliuArray;

}
@property (nonatomic,strong)UITableView* wuliuTbView;

@end

@implementation WuliuDetailViewController

- (UITableView*)wuliuTbView{
    if (_wuliuTbView == nil) {
        _wuliuTbView = [[UITableView alloc]initWithFrame:CGRectMake(20, 50*MYWIDTH, KscreenWidth-40, KscreenHeight - 200*MYWIDTH) style:UITableViewStylePlain];
        _wuliuTbView.delegate = self;
        _wuliuTbView.dataSource = self;
        _wuliuTbView.layer.cornerRadius= 10;
        _wuliuTbView.layer.shadowColor=[UIColor blackColor].CGColor;
        _wuliuTbView.layer.shadowOffset=CGSizeMake(0, 0);
        _wuliuTbView.layer.shadowOpacity=0.5;
        _wuliuTbView.layer.shadowRadius= 10;
        _wuliuTbView.clipsToBounds = false;
        _wuliuTbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_wuliuTbView];
    }
    return _wuliuTbView;
}
//视图将要显示时隐藏
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

//视图将要消失时取消隐藏
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"物流详情";
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    _wuliuArray = [[NSMutableArray alloc]init];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"正在加载中...";
    [_HUD show:YES];
    
    [self createUIview];

    [self dataRequest];
}
- (void)createUIview{
    UIImageView *blueview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 180*MYWIDTH)];
    blueview.image = [UIImage imageNamed:@"渐变颜色"];
    [self.view addSubview:blueview];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _wuliuTbView){
        if (_wuliuArray.count*60>tableView.bounds.size.height) {
            _wuliuTbView.userInteractionEnabled = YES;
        }else{
            _wuliuTbView.userInteractionEnabled = NO;
        }
        return _wuliuArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    WuliuDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"WuliuDetailCellID"];
    if (!detailCell) {
        detailCell = [[[NSBundle mainBundle]loadNibNamed:@"WuliuDetailCell" owner:self options:nil]firstObject];
    }
    
    if (tableView == _wuliuTbView){
        if (_wuliuArray.count!=0) {
            detailCell.model = _wuliuArray[indexPath.row];
        }
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        detailCell.layer.cornerRadius= 10;

        return detailCell;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)dataRequest{
    /*
     查询物流信息接口：
     rootPath+'/order?action=getShipmentsLogicstic&table=ddxx'+callback1
     参数：'{"shipno":"'+rows.shipno+'","logisticsno":"'+rows.logisticsno+'"}
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary *params = @{@"action":@"getShipmentsLogicstic",@"table":@"ddxx",@"params":[NSString stringWithFormat:@"{\"shipno\":\"%@\",\"logisticsno\":\"%@\"}",_shipno,_logisticsno]};
    
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        _HUD.labelText = [NSString stringWithFormat:@"%@",@"正在查询.."];
        NSDictionary * array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
            if (array.count != 0) {
                for (NSDictionary *dic in array) {
                    WuliuDetailTracesModel* model = [[WuliuDetailTracesModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_wuliuArray addObject:model];
                }
                _wuliuTbView.hidden = NO;
                 [self.wuliuTbView reloadData];
            }else{
                _wuliuTbView.hidden = YES;
                [self showAlert:@"暂无物流信息"];
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
//跨域
- (NSString *)replaceOhter:(NSString *)dataStr
{
    NSString * returnString = [dataStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    return returnString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
