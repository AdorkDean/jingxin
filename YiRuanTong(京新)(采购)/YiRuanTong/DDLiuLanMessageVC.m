//
//  DDLiuLanMessageVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "DDLiuLanMessageVC.h"
#import "DingDanViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "StatueDetailView.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "ProMsgModel.h"
#import "DataPost.h"
#import "LogModel.h"
#import "ChangeOrderVC.h"


#define lineColor COLOR(240, 240, 240, 1);
@interface DDLiuLanMessageVC ()<UITextFieldDelegate>

{
    UIView *_backView;
    UIView *_chanPinView;
    NSInteger count;
    NSString *_showStr;
    NSString *_showStr2;
    NSMutableArray *_logArray;   //物流单号
    
    UIButton *_stateButton;
    UITableView *_orderTableView;
    NSArray *_array;
    MBProgressHUD *_HUD;
    //客户信息
    UIButton  *_nameButton;
    UITextField *_yuEField;
    UIButton *_payTypeButton;
    //产品

    //增加产品
    NSMutableArray *_cpNameBtnArray;
    NSMutableArray *_cpCodeArray;
    NSMutableArray *_cpGuigeArray;
    NSMutableArray *_cpDanweiArray;
    NSMutableArray *_xiaoshouTypeArray;
    NSMutableArray *_singlePriceArray;
    NSMutableArray *_countArray;
    NSMutableArray *_JineArray;
    NSMutableArray *_keyongKuCunArray;
    NSMutableArray *_chanpinViewArray;
    NSMutableArray *_proidArray;
    NSMutableArray *_salertypeidArray;
    NSMutableArray *_unitidArray;
    NSMutableArray *_leixingArr;//销售类型
    NSMutableArray *_fukuanfangshiId;
    NSMutableArray *_fanliLvArray;
    NSMutableArray *_danweiArr;
    
    
    //
    //客户联系人物流字段
    UIButton *_wuLiuButton;
    UITextField *_receiver;
    UITextField *_receiveTel;
    UITextField *_receiveAdd;
    UIButton *_wuLiuDaiShou;
    UITextField *_daiShouJinE;
    UITextField *_note;
    
}
//@property(nonatomic,retain)UITableView *RightTableView;
@end

@implementation DDLiuLanMessageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"订单详情";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [NSMutableArray array];
    _cpNameBtnArray = [[NSMutableArray alloc] init];
    _cpCodeArray = [[NSMutableArray alloc] init];
    _cpGuigeArray = [[NSMutableArray alloc] init];
    _cpDanweiArray = [[NSMutableArray alloc] init];
    _xiaoshouTypeArray = [[NSMutableArray alloc] init];
    _singlePriceArray = [[NSMutableArray alloc] init];
    _countArray = [[NSMutableArray alloc] init];
    _cpCodeArray = [[NSMutableArray alloc] init];
    _JineArray = [[NSMutableArray alloc] init];
    _keyongKuCunArray = [[NSMutableArray alloc] init];
    
    _proidArray = [[NSMutableArray alloc] init];
    _unitidArray = [[NSMutableArray alloc] init];
    _salertypeidArray = [[NSMutableArray alloc] init];
    _logArray = [NSMutableArray array];
    _chanpinViewArray = [[NSMutableArray alloc] init];
   
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self DataRequest1];
        [self DataRequest2];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self initScrollView];
           // [self PageViewDidLoad];
            [self initCustView];
            [self initDetailView];
            [self initCustDetailView];
        });
    });
    
    
}

- (void)initScrollView {
    self.dingDanScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    self.dingDanScrollView.showsVerticalScrollIndicator = NO;
    NSLog(@"%zi",count);   //订单的数量
   // self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, 286+ 153*count +15);
    self.dingDanScrollView.bounces = NO;
    self.dingDanScrollView.backgroundColor =[UIColor clearColor];
    self.dingDanScrollView.delegate =self;
   [self.view addSubview:self.dingDanScrollView];
    //导航栏状态按钮
    _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [_stateButton setTitle:@"状态" forState:UIControlStateNormal];
    [_stateButton addTarget:self action:@selector(initAlert) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_stateButton];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)initAlert{
    
    UIAlertView *showRight = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看状态",@"关闭订单", nil];
    showRight.tag = 10010;

    [showRight show];
    
}
#pragma mark - 订单选择操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10010) {
            /*
             取消 0
             状态 1
             关闭 2
             修改 3
             */
        NSLog(@"选择的的index: %zi",buttonIndex);
        if (buttonIndex == 0) {
            NSLog(@"选择了取消");
        }else if (buttonIndex == 1){
            //显示状态
            [self stateAction];
            
        }else if (buttonIndex == 2){
            //关闭
            [self DeletEd];
        }
//        else if (buttonIndex == 3){
//            //修改
//            ChangeOrderVC *changeVc = [[ChangeOrderVC alloc]init];
//            changeVc.model = _model;
//            changeVc.ProArray = _dataArray;
//            [self.navigationController pushViewController:changeVc animated:YES];
//            
//        }


    }else if (alertView.tag == 10011){
        //关闭订单的方法
        if (buttonIndex == 1) {
            [self stop];
        }
    
    }
    
    

}
//关闭订单
- (void)DeletEd{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否关闭此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 10011;
    [alert show];
    
    
}

//删除上传方法

- (void)stop{
    
    /*
     182.92.96.58:8005/sdb/servlet/
     order?
     action=stopOrder
     table=ddxx
     data	{"id":"1255","stopreason":"不想要了"}
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order?action=stopOrder"];
    NSDictionary *params = @{@"action":@"stopOrder",@"table":@"ddxx",@"data":[NSString stringWithFormat:@"{\"id\":\"%@\",\"stopreason\":\"手机端关闭\"}",_model.Id]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"关闭返回:%@",str);
       
        if (str.length != 0) {
           NSString  *realStr = [self replaceOthers:str];
            if ([realStr isEqualToString:@"true"]) {
                [self showAlert:@"订单关闭成功!"];
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrder" object:self];
            }else{
                [self showAlert:@"订单关闭失败!"];
            }
        }
        
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        NSLog(@"删除失败");
    }];
    
    
    
}


//状态按钮的显示
- (void)stateAction{
    
    //_stateButton.userInteractionEnabled = NO;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary *params = @{@"action":@"getOrderStatus",@"orderno":[NSString stringWithFormat:@"%@",_orderNo]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"状态%@",array);
        if (array.count != 0) {
            for (NSDictionary *dic in array) {
                LogModel *model = [[LogModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_logArray addObject:model];
            }
    
            //订单详情状态页面
            _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
            _backView.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:_backView];
            //
            UIButton *yesbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            yesbutton.frame = CGRectMake(0,180, KscreenWidth, KscreenHeight - 64 - 160);
            [yesbutton addTarget:self action:@selector(yesButton) forControlEvents:UIControlEventTouchUpInside];
            [_backView addSubview:yesbutton];
            
            UILabel *stateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth , 40)];
            stateLabel1.backgroundColor = [UIColor lightGrayColor];
            stateLabel1.font = [UIFont systemFontOfSize:18];
            [_backView addSubview:stateLabel1];
            stateLabel1.text = @"物流单号:";

            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KscreenWidth, 1)];
            line.backgroundColor = [UIColor grayColor];
            [_backView addSubview:line];
            _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KscreenWidth, 200)];
            _orderTableView.delegate = self;
            _orderTableView.dataSource = self;
            _orderTableView.rowHeight = 50;
            [_backView addSubview:_orderTableView];
            [_orderTableView reloadData];
        }else{
            NSLog(@"未查询到物流单号信息");
            //订单详情状态页面
            _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
            _backView.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:_backView];
            //
            UIButton *yesbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            yesbutton.frame = CGRectMake(0,180, KscreenWidth, KscreenHeight - 64 - 160);
            [yesbutton addTarget:self action:@selector(yesButton) forControlEvents:UIControlEventTouchUpInside];
            [_backView addSubview:yesbutton];
            
            UILabel *stateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth , 40)];
            stateLabel1.backgroundColor = [UIColor lightGrayColor];
            stateLabel1.font = [UIFont systemFontOfSize:18];
            [_backView addSubview:stateLabel1];
            stateLabel1.text = @"未查到物流单号!";
            

        
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];

    
    
   
}

- (void)yesButton{
    
    _stateButton.userInteractionEnabled = YES;
    [_backView removeFromSuperview];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _logArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *iden = @"cell_order";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
       // cell.backgroundColor = [UIColor redColor];
    }
    LogModel *model = _logArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"单号:%@",model.logisticsno];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StatueDetailView *statusVC = [[StatueDetailView alloc] init];
    LogModel *model = _logArray[indexPath.row];
    statusVC.urlString = [NSString stringWithFormat:@"%@",model.logisticsno];
    [self.navigationController pushViewController: statusVC animated:YES];
    
}

#pragma mark  数据加载
//- (void)DataRequest1
//{
//    //物流信息（订单详情） 的接口
//    //拼接地址字符串
//    NSString *strAdress = @"/customer";
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
//    
//    NSURL *url =[NSURL URLWithString:urlStr];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    NSString *str = [NSString stringWithFormat:@"action=getLogisInfo&params={\"idEQ\":\"%@\"}&table=wlxx",_wuliuID];
//    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data1 != nil) {
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options: NSJSONReadingAllowFragments error:nil];
//        if(array.count != 0 ){
//            _wuLiuData = array[0];
//            NSLog(@"物流信息%@",_wuLiuData);
//        }
//    }else{
//        [self showAlert:@"物流信息加载失败！"];
//    }
//    
//    
//}

- (void)DataRequest2
{
    //产品信息 (订单详情)
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
     NSString *str =[NSString stringWithFormat:@"mobile=true&action=toAudit&params={\"idEQ\":\"%@\"}&table=ddmx",_chanpinID];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        returnStr = [self replaceOthers:returnStr];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in  arr) {
                ProMsgModel *model = [[ProMsgModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            
            NSLog(@"产品信息%@",arr);
            count = _dataArray.count;
            [_HUD removeFromSuperview];
        }
    }
        
}

#pragma mark 客户页面
- (void)initCustView
{
    
    UILabel *label1 =  [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 45)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"客户名称*";
    [self.dingDanScrollView addSubview:label1];
    _nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nameButton.frame = CGRectMake(85, 0, KscreenWidth - 90, 45);
    [_nameButton setTintColor:[UIColor grayColor]];
    _nameButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    //[_nameButton addTarget:self action:@selector(nameAction) forControlEvents:UIControlEventTouchUpInside];
    _nameButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanScrollView addSubview:_nameButton];
    [_nameButton setTitle:_model.custname forState:UIControlStateNormal];
    
    UIView *line1  = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    line1.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanScrollView addSubview:line1];
    //订单的总金额
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 46, 80, 45)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"总金额";
    [self.dingDanScrollView addSubview:label2];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 91, KscreenWidth, 1)];
    line2.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanScrollView addSubview:line2];
    _yuEField = [[UITextField alloc] initWithFrame:CGRectMake(85, 46, KscreenWidth - 90, 45)];
    _yuEField.delegate = self;
    _yuEField.font = [UIFont systemFontOfSize:14];
    _yuEField.textAlignment = NSTextAlignmentLeft;
    [self.dingDanScrollView addSubview:_yuEField];
    _yuEField.text = [NSString stringWithFormat:@"%@",_model.returnordermoney];
    
    
    UILabel  *label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 92, 80, 45)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"付款方式";
    [self.dingDanScrollView addSubview:label3];
    _payTypeButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _payTypeButton.frame = CGRectMake(85, 92, KscreenWidth - 90, 45);
    [_payTypeButton setTintColor:[UIColor grayColor]];
    _payTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[_payTypeButton addTarget:self action:@selector(payTypeAction) forControlEvents:UIControlEventTouchUpInside];
    _payTypeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanScrollView addSubview:_payTypeButton];
     [_payTypeButton setTitle:_model.paidtype forState:UIControlStateNormal];
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 137, KscreenWidth, 10)];
    view0.backgroundColor = COLOR(225, 225, 225, 1);
    [self.dingDanScrollView addSubview:view0];
    _nameButton.userInteractionEnabled = NO;
    _yuEField.userInteractionEnabled = NO;
    _payTypeButton.userInteractionEnabled = NO;

}
#pragma mark - 产品信息页面
- (void)initDetailView{
//添加产品的按钮设置
    NSLog(@"产品信息%zi",count);
for (int i = 0; i < count; i++) {
    ProMsgModel *model = _dataArray[i];
    
    self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, 150 + count * 455 + 400);
    UIView *chanpinView = [[UIView alloc] initWithFrame:CGRectMake(0, 137 + 455 *i , KscreenWidth, 570)];
    chanpinView.backgroundColor = [UIColor whiteColor];
    
    //产品UI搭建
#pragma mark - 产品UI搭建
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 39)];
    info.backgroundColor = COLOR(220, 220, 220, 1);
    info.text = [NSString stringWithFormat:@"产品信息(%zi)",i + 1];
    info.textAlignment = NSTextAlignmentCenter;
    info.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [chanpinView addSubview:info];
    //关闭按钮
//    if (count > 1) {
//        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        closeBtn.frame = CGRectMake(KscreenWidth - 40, 0, 40, 35);
//        [closeBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(closeChanpinView) forControlEvents:UIControlEventTouchUpInside];
//        [chanpinView addSubview:closeBtn];
//        
//    }
    UILabel *line0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, KscreenWidth, 1)];
    line0.backgroundColor =  lineColor
    [chanpinView addSubview:line0];
    
    //产品名称
    UILabel *chanPinName = [[UILabel alloc] initWithFrame:CGRectMake(5, 40 , 80, 45)];
    chanPinName.text = @"产品名称*";
    chanPinName.font = [UIFont systemFontOfSize:14];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 85, KscreenWidth, 1)];
    line1.backgroundColor = COLOR(240, 240, 240, 1);
    [chanpinView addSubview:line1];
    [chanpinView addSubview:chanPinName];
    
    UIButton *CPNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(86, 40, KscreenWidth - 90, 45)];
    CPNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CPNameBtn.tag = count;
    [CPNameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [CPNameBtn.titleLabel  setFont:[UIFont systemFontOfSize:14]];
   // [CPNameBtn addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
    [chanpinView addSubview:CPNameBtn];
    [CPNameBtn setTitle:model.proname forState:UIControlStateNormal];
    [_cpNameBtnArray addObject:CPNameBtn];
    
    UILabel *cPNO = [[UILabel alloc] initWithFrame:CGRectMake(5, chanPinName.bottom + 1 , 80, 45)];
    cPNO.text = @"产品编码";
    cPNO.font = [UIFont systemFontOfSize:14];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, cPNO.bottom, KscreenWidth, 1)];
    line2.backgroundColor = COLOR(240, 240, 240, 1);
    [chanpinView addSubview:line2];
    [chanpinView addSubview:cPNO];
    UILabel *proNo = [[UILabel alloc] initWithFrame:CGRectMake(86, chanPinName.bottom + 1, KscreenWidth - 90, 45)];
    proNo.font = [UIFont systemFontOfSize:14];
    proNo.textAlignment = NSTextAlignmentLeft;
    proNo.textColor = [UIColor grayColor];
    [chanpinView addSubview:proNo];
    proNo.text = model.prono;
    [_cpCodeArray addObject:proNo];
    
    
    //产品规格
    UILabel *chanPinGuiGe =[[UILabel alloc] initWithFrame:CGRectMake(5, cPNO.bottom + 1, 80, 45)];
    chanPinGuiGe.text = @"产品规格";
    chanPinGuiGe.font = [UIFont systemFontOfSize:14];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, chanPinGuiGe.bottom, KscreenWidth, 1)];
    line3.backgroundColor = COLOR(240, 240, 240, 1);
    [chanpinView addSubview:line3];
    [chanpinView addSubview:chanPinGuiGe];
    UILabel *chanPinGuiGe1 = [[UILabel alloc] initWithFrame:CGRectMake(86, cPNO.bottom + 1, KscreenWidth - 90, 45)];
    chanPinGuiGe1.font = [UIFont systemFontOfSize:14];
    chanPinGuiGe1.textAlignment = NSTextAlignmentLeft;
    chanPinGuiGe1.textColor = [UIColor grayColor];
    chanPinGuiGe1.text = model.specification;
    [chanpinView addSubview:chanPinGuiGe1];
    [_cpGuigeArray addObject:chanPinGuiGe1];
    
    
    
    
    //产品单位
    UILabel *chanPinDanWei = [[UILabel alloc] initWithFrame:CGRectMake(5, chanPinGuiGe.bottom + 1, 80, 45)];
    chanPinDanWei.text = @"产品单位";
    chanPinDanWei.font = [UIFont systemFontOfSize:14];
    UIView *line4 =[[UIView alloc]initWithFrame:CGRectMake(0, chanPinDanWei.bottom, KscreenWidth, 1)];
    line4.backgroundColor = lineColor;
    [chanpinView addSubview:line4];
    [chanpinView addSubview:chanPinDanWei];
    UIButton *chanPinDanWeiButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    chanPinDanWeiButton1.frame = CGRectMake(86, chanPinGuiGe.bottom + 1, KscreenWidth - 90, 45);
    chanPinDanWeiButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [chanPinDanWeiButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    chanPinDanWeiButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    //chanPinDanWeiButton1.userInteractionEnabled = NO;
    //[chanPinDanWeiButton1 addTarget:self action:@selector(danweiAction) forControlEvents:UIControlEventTouchUpInside];
    [chanPinDanWeiButton1 setTitle:model.prounitname forState:UIControlStateNormal];
    [chanpinView addSubview:chanPinDanWeiButton1];
    [_cpDanweiArray addObject:chanPinDanWeiButton1];
    
    
    //单价
    UILabel *danJia =[[UILabel alloc] initWithFrame:CGRectMake(5, chanPinDanWei.bottom + 1, 80, 45)];
    danJia.text = @"单价";
    danJia.font = [UIFont systemFontOfSize:14];
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, danJia.bottom, KscreenWidth, 1)];
    line6.backgroundColor = lineColor;
    [chanpinView addSubview:line6];
    [chanpinView addSubview:danJia];
    
    UILabel *danJia1 =[[UILabel alloc] initWithFrame:CGRectMake(86, chanPinDanWei.bottom + 1, KscreenWidth - 90, 45)];
    danJia1.font =[UIFont systemFontOfSize:14];
    danJia1.textAlignment = NSTextAlignmentLeft;
    danJia1.textColor = [UIColor grayColor];
    [chanpinView addSubview:danJia1];
    danJia1.text = [NSString stringWithFormat:@"%@",model.singleprice];
    [_singlePriceArray addObject:danJia1];
    
    
    //销售类型
    UILabel *xiaoShouLeiXing = [[UILabel alloc] initWithFrame:CGRectMake(5, danJia.bottom + 1, 80, 45)];
    xiaoShouLeiXing.text = @"销售类型";
    xiaoShouLeiXing.font = [UIFont systemFontOfSize:14];
    UIView *line5 =[[UIView alloc] initWithFrame:CGRectMake(0, xiaoShouLeiXing.bottom, KscreenWidth, 1)];
    line5.backgroundColor = lineColor;
    [chanpinView addSubview:line5];
    [chanpinView addSubview:xiaoShouLeiXing];
    UIButton *xiaoShouLeiXingButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    xiaoShouLeiXingButton1.frame = CGRectMake(86, danJia.bottom + 1, KscreenWidth - 90, 45);
    xiaoShouLeiXingButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [xiaoShouLeiXingButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   // [xiaoShouLeiXingButton1 addTarget:self action:@selector(saleTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [xiaoShouLeiXingButton1 setTitle:model.saletypename forState:UIControlStateNormal];
    xiaoShouLeiXingButton1.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [chanpinView addSubview:xiaoShouLeiXingButton1];
//    //默认销售类型
//    NSLog(@"销售类型%@",_leixingArr);
//    if (_leixingArr.count != 0) {
//        DWandLXModel *model = _leixingArr[0];
//        [xiaoShouLeiXingButton1 setTitle:model.name forState:UIControlStateNormal];
//        _saletypeid = model.Id;
//        [_salertypeidArray addObject:_saletypeid];
//    }
    [_xiaoshouTypeArray addObject:xiaoShouLeiXingButton1];
    
    UILabel *returnRate = [[UILabel alloc] initWithFrame:CGRectMake(5, xiaoShouLeiXing.bottom + 1, 80, 45)];
    returnRate.text = @"返利率";
    returnRate.font = [UIFont systemFontOfSize:14];
    UIView *lineFan =[[UIView alloc] initWithFrame:CGRectMake(0, returnRate.bottom, KscreenWidth, 1)];
    lineFan.backgroundColor = lineColor;
    [chanpinView addSubview:lineFan];
    [chanpinView addSubview:returnRate];
    UITextField *returnRate1 = [[UITextField alloc] initWithFrame:CGRectMake(86, xiaoShouLeiXing.bottom + 1, KscreenWidth - 90, 45)];
    returnRate1.delegate = self;
    returnRate1.tag = 102;
    returnRate1.textColor = [UIColor lightGrayColor];
    returnRate1.font = [UIFont systemFontOfSize:14];
    [chanpinView addSubview:returnRate1];
    returnRate1.text = [NSString stringWithFormat:@"%@",model.returnrate];
    [_fanliLvArray addObject:returnRate1];
    
    //数量
    UILabel *shuLiang = [[UILabel alloc] initWithFrame:CGRectMake(5, returnRate.bottom + 1, 80, 45)];
    shuLiang.text = @"数量";
    shuLiang.font = [UIFont systemFontOfSize:14];
    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(0, shuLiang.bottom, KscreenWidth, 1)];
    line7.backgroundColor = lineColor;
    [chanpinView addSubview:line7];
    [chanpinView addSubview:shuLiang];
    UITextField *shuLiang1 = [[UITextField alloc] initWithFrame:CGRectMake(86, returnRate.bottom + 1, KscreenWidth - 90, 45)];
    shuLiang1.font =[UIFont systemFontOfSize:14];
    shuLiang1.delegate = self;
    shuLiang1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    shuLiang1.textAlignment = NSTextAlignmentLeft;
    shuLiang1.textColor = [UIColor grayColor];
    shuLiang1.placeholder = @"请输入数量";
    [chanpinView addSubview:shuLiang1];
    shuLiang1.text = [NSString stringWithFormat:@"%@",model.maincount];
    [_countArray addObject:shuLiang1];
    
    
    //金额
    UILabel *jinE = [[UILabel alloc] initWithFrame:CGRectMake(5, shuLiang.bottom + 1, 80, 45)];
    jinE.text = @"折后金额";
    jinE.font =[UIFont systemFontOfSize:14];
    UIView *line10 = [[UIView alloc] initWithFrame:CGRectMake(0, jinE.bottom, KscreenWidth, 1)];
    line10.backgroundColor = lineColor;
    [chanpinView addSubview:line10];
    [chanpinView addSubview:jinE];
    UILabel *jinE1 = [[UILabel alloc] initWithFrame:CGRectMake(86, shuLiang.bottom + 1, KscreenWidth - 90, 45)];
    jinE1.font = [UIFont systemFontOfSize:14];
    jinE1.textAlignment = NSTextAlignmentLeft;
    jinE1.textColor = [ UIColor grayColor];
    double n = [model.saledmoney doubleValue];
    jinE1.text = [NSString stringWithFormat:@"%.2f",n];
    [chanpinView addSubview:jinE1];
    [_JineArray addObject:jinE1];

    //可用库存
//    UILabel *keYongKuCun = [[UILabel alloc] initWithFrame:CGRectMake(5, 362, 80, 45)];
//    keYongKuCun.text = @"可用库存";
//    keYongKuCun.font = [UIFont systemFontOfSize:14];
//    UIView *line12 = [[UIView alloc] initWithFrame:CGRectMake(0,407, KscreenWidth, 1)];
//    line12.backgroundColor = lineColor;
//    [chanpinView addSubview:line12];
//    [chanpinView addSubview:keYongKuCun];
//    UILabel *keYongKuCun1 = [[UILabel alloc] initWithFrame:CGRectMake(86, 362, KscreenWidth - 90, 45)];
//    keYongKuCun1.font = [UIFont systemFontOfSize:14];
//    keYongKuCun1.textAlignment = NSTextAlignmentLeft;
//    keYongKuCun1.textColor = [UIColor grayColor];
//    [chanpinView addSubview:keYongKuCun1];
//    keYongKuCun1.text = [NSString stringWithFormat:@"%@",model.stockcount];
//    [_keyongKuCunArray addObject:keYongKuCun1];
    
    
    
    
    [self.dingDanScrollView addSubview:chanpinView];
    
    [_chanpinViewArray addObject:chanpinView];
    chanpinView.userInteractionEnabled = NO;
  
    }
}
#pragma mark - 物流 以及联系人页面设置
- (void)initCustDetailView{
    
    UIView *fenGeView = [[UIView alloc] initWithFrame:CGRectMake(0, 137 + count * 455, KscreenWidth, 20)];
    fenGeView.backgroundColor = COLOR(230, 230, 230, 1);
    [self.dingDanScrollView addSubview:fenGeView];
    
    ///
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 157 + count * 455, KscreenWidth, 322)];
    detailView.backgroundColor = [UIColor whiteColor];
    [self.dingDanScrollView addSubview:detailView];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 45)];
    label1.text = @"物流名称";
    label1.font =[UIFont systemFontOfSize:14];
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 40, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [detailView addSubview:view1];
    [detailView addSubview:label1];
    _wuLiuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _wuLiuButton.frame = CGRectMake(86, 0, KscreenWidth - 90, 45);
    [_wuLiuButton setTintColor:[UIColor grayColor]];
    _wuLiuButton.tag = 10;
    _wuLiuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
   // [_wuLiuButton addTarget:self action:@selector(wuLiuAction) forControlEvents:UIControlEventTouchUpInside];
    
    [detailView addSubview:_wuLiuButton];
    NSString *wuliu = _model.logisticsname;
    [_wuLiuButton setTitle:wuliu forState:UIControlStateNormal];
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 46, 80, 45)];
    label2.text = @"收货人";
    label2.font =[UIFont systemFontOfSize:14];
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 91, KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    _receiver =[[UITextField alloc]initWithFrame:CGRectMake(86, 46, KscreenWidth - 90, 45)];
    _receiver.font =[UIFont systemFontOfSize:14];
    _receiver.textAlignment = NSTextAlignmentLeft;
    _receiver.delegate = self;
    [detailView addSubview:label2];
    [detailView addSubview:view2];
    [detailView addSubview:_receiver];
    _receiver.text = _model.receiver;
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 92, 80, 45)];
    label3.text = @"收货人电话";
    label3.font = [UIFont systemFontOfSize:14];
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 137, KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    _receiveTel = [[UITextField alloc] initWithFrame:CGRectMake(86, 92, KscreenWidth - 90, 45)];
    _receiveTel.delegate  = self;
    _receiveTel.font = [UIFont systemFontOfSize:14];
    _receiveTel.textAlignment = NSTextAlignmentLeft;
    [detailView addSubview:label3];
    [detailView addSubview:view3];
    [detailView addSubview:_receiveTel];
    _receiveTel.text = [NSString stringWithFormat:@"%@",_model.receivertel];
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(5, 138, 80, 45)];
    label4.text = @"收货人地址";
    label4.font = [UIFont systemFontOfSize:14];
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 183, KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    _receiveAdd =[[UITextField alloc]initWithFrame:CGRectMake(86, 138, KscreenWidth - 90, 45)];
    _receiveAdd.font =[UIFont systemFontOfSize:14];
    _receiveAdd.textAlignment = NSTextAlignmentLeft;
    _receiveAdd.delegate = self;
    [detailView addSubview:label4];
    [detailView addSubview:view4];
    [detailView addSubview:_receiveAdd];
    _receiveAdd.text = _model.receiveaddr;
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(5, 184, 80, 45)];
    label5.text = @"物流代收";
    label5.font = [UIFont systemFontOfSize:14];
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, 229, KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    _wuLiuDaiShou = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _wuLiuDaiShou.frame = CGRectMake(86, 184, KscreenWidth - 90, 45);
    [_wuLiuDaiShou setTintColor:[UIColor grayColor]];
    _wuLiuDaiShou.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
   // [_wuLiuDaiShou addTarget:self action:@selector(YORN) forControlEvents:UIControlEventTouchUpInside];
    
    [detailView addSubview:label5];
    [detailView addSubview:view5];
    [detailView addSubview:_wuLiuDaiShou];
    NSString *daishou = [NSString stringWithFormat:@"%@",_model.daidai];
    int i = [daishou intValue];
    if (i == 1) {
        [_wuLiuDaiShou setTitle:@"是" forState:UIControlStateNormal];
    }else if (i == 0){
    
        [_wuLiuDaiShou setTitle:@"否" forState:UIControlStateNormal];
    }
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(5, 230, 80, 45)];
    label6.text = @"代收金额";
    label6.font =[UIFont systemFontOfSize:14];
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, 275, KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    _daiShouJinE = [[UITextField alloc] initWithFrame:CGRectMake(86, 230, KscreenWidth - 90, 45)];
    _daiShouJinE.delegate = self;
    _daiShouJinE.font = [UIFont systemFontOfSize:14];
    _daiShouJinE.textAlignment = NSTextAlignmentLeft;
    [detailView addSubview:label6];
    [detailView addSubview:view6];
    [detailView addSubview:_daiShouJinE];
    _daiShouJinE.text = _model.daishoumoney;
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(5, 276, 80, 45)];
    label7.text = @"备注";
    label7.font =[UIFont systemFontOfSize:14];
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, 321, KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [detailView addSubview:label7];
    [detailView addSubview:view7];
    _note = [[UITextField alloc] initWithFrame:CGRectMake(86, 276, KscreenWidth - 90, 45)];
    _note.font = [UIFont systemFontOfSize:14];
    _note.textAlignment = NSTextAlignmentLeft;
    _note.delegate = self;
    [detailView addSubview:_note];
    _note.text = _model.ordernote;
    detailView.userInteractionEnabled = NO;
    
}


@end
