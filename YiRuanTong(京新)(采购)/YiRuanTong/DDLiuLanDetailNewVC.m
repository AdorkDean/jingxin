//
//  DDLiuLanDetailNewVC.m
//  YiRuanTong
//
//  Created by 邱 德政 on 17/7/27.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "DDLiuLanDetailNewVC.h"
#import "DingDanViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "StatueDetailView.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "ProMsgModel.h"
#import "DataPost.h"
#import "LogModel.h"
#import "DDLiuLanDetailproCell.h"
#import "ChangeOrderVC.h"
#import "Masonry.h"
//1. 对于约束参数可以省去"mas_"
#define MAS_SHORTHAND
//2. 对于默认的约束参数自动装箱
#define MAS_SHORTHAND_GLOBALS
#define lineColor COLOR(240, 240, 240, 1);
@interface DDLiuLanDetailNewVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>

{
    UIView *_backView;
    NSMutableArray *_logArray;   //物流单号
    
    UIButton *_stateButton;
    UITableView *_orderTableView;
    MBProgressHUD *_HUD;
    NSInteger status;
    MBProgressHUD *_hud;
    NSString *_tPID;
    NSMutableArray* _tPArray;
    NSArray* _shenpixingshiArr;
    UIView* _spView;
    UILabel* _rHistoryLabel;
    UILabel* _contentLabel;
    UILabel* _rcontentLabel;
    UITextField* _pifuneirong;
    UIButton* _pifuxingshi;
    UIButton* _pifurenname;
    NSInteger pifuLishicount;
    NSArray *_pifulishiArray;
    UIButton* _hide_keHuPopViewBut;
    NSArray *_shiArr;
    
}
@property(nonatomic,retain)UITableView *tPtableView;
@property(nonatomic,retain)UITableView *pfTableView;
@property (nonatomic,strong) UIView *m_keHuPopView;

@end

@implementation DDLiuLanDetailNewVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"订单详情";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [NSMutableArray array];
    _logArray = [NSMutableArray array];
    _tPArray = [[NSMutableArray alloc]init];
//    _shenpixingshiArr = @[@"审批通过",@"审批拒绝",@"转特批",@"特批通过返回",@"特批结束审批",@"特批拒绝"];
    _shenpixingshiArr = @[@"特批通过",@"转特批",@"特批结束",@"特批拒绝"];
    _shiArr = @[@"审批通过",@"审批拒绝",@"转特批"];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self DataRequest2];
        if ([self.vcType isEqualToString:@"1"]) {
            [self requestPifuHistory];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
}

- (void)initScrollView {
    self.dingDanScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    self.dingDanScrollView.showsVerticalScrollIndicator = NO;
    self.dingDanScrollView.bounces = NO;
    self.dingDanScrollView.backgroundColor =COLOR(229, 228, 239, 1);
    self.dingDanScrollView.delegate =self;
    [self.view addSubview:self.dingDanScrollView];
    if ([self.vcType isEqualToString:@"0"]) {
        //导航栏状态按钮
        _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stateButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
        [_stateButton setTitle:@"状态" forState:UIControlStateNormal];
        [_stateButton addTarget:self action:@selector(initAlert) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_stateButton];
        self.navigationItem.rightBarButtonItem = right;
    }

}

- (void)initAlert{
    NSString* sp = [NSString stringWithFormat:@"%@",_model.spstatus];
    if ([sp integerValue] == 0||[sp integerValue] == -1) {
        UIAlertView *showRight = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看状态",@"关闭订单",@"修改订单", nil];
        showRight.tag = 10010;
        
        [showRight show];
    }else{
        UIAlertView *showRight = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看状态",@"关闭订单", nil];
        showRight.tag = 10010;
        
        [showRight show];
    }

    
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
        else if (buttonIndex == 3){
            //修改
            ChangeOrderVC *changeVc = [[ChangeOrderVC alloc]init];
            changeVc.model = _model;
            changeVc.ProArray = _dataArray;
            [self.navigationController pushViewController:changeVc animated:YES];

        }
    
        
    }else if (alertView.tag == 10011){
        //关闭订单的方法
        if (buttonIndex == 1) {
            [self stop];
        }
        
    }else if (alertView.tag == 20010){
        if (buttonIndex == 1) {
            
            [self spUPdata];
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
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing linecolor:(UIColor *)linecolor{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:linecolor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (void)creatUI{
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KscreenWidth, 45*11)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.dingDanScrollView addSubview:headerView];
    
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KscreenWidth - 20, 44)];
    headerLabel.text = @"订单信息";
    headerLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:headerLabel];
    UIView* line0 = [[UIView alloc]initWithFrame:CGRectMake(0, headerLabel.bottom, KscreenWidth, 1)];
    line0.backgroundColor = lineColor;
    [headerView addSubview:line0];
    NSArray* titleArray = @[@"订单编号",@"客户名称",@"付款方式",@"联系方式",@"收货人",@"收货地址",@"代收",@"代收金额",@"备注",@"总额"];
    NSString* orderno = [NSString stringWithFormat:@"%@",_model.orderno];
    NSString* custname = [NSString stringWithFormat:@"%@",_model.custname];
    NSString* paidtype = [NSString stringWithFormat:@"%@",_model.paidtype];
    NSString* receiveTel = [NSString stringWithFormat:@"%@",_model.receivertel];
    NSString* receiver = [NSString stringWithFormat:@"%@",_model.receiver];
    NSString* receiveaddr = [NSString stringWithFormat:@"%@(%@)",_model.receiveaddr,_model.logisticsname];
    NSString* daidaiint = [NSString stringWithFormat:@"%@",_model.daidai];
    NSString* daidai;
    if ([daidaiint integerValue] == 1) {
        daidai = @"是";
    }else{
        daidai = @"否";
    }
    NSString* daishoumoney = [NSString stringWithFormat:@"%@",_model.daishoumoney];
    daishoumoney = [NSString stringWithFormat:@"￥%.2f",[daishoumoney doubleValue]];
    NSString* ordernote = [NSString stringWithFormat:@"%@",_model.ordernote];
    NSString* returnordermoney = [NSString stringWithFormat:@"%@",_model.returnordermoney];
    returnordermoney = [NSString stringWithFormat:@"￥%.2f",[returnordermoney doubleValue]];
    NSArray* detailArray = @[orderno,custname,paidtype,receiveTel,receiver,receiveaddr,daidai,daishoumoney,ordernote,returnordermoney];
    
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45+45*i, 80, 44)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:titleLabel];
        UILabel* detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, headerView.width - titleLabel.width - 20, titleLabel.height)];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.numberOfLines = 0;
        detailLabel.tag = 100+i;
        if (i<detailArray.count) {
           detailLabel.text = detailArray[i];
        }
        [headerView addSubview:detailLabel];
        
        if (i == titleArray.count - 1) {
            titleLabel.textColor = UIColorFromRGB(0x3cbaff);
            detailLabel.textColor = UIColorFromRGB(0x3cbaff);
        }
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, KscreenWidth - 20, 0.5)];
        [self drawDashLine:line lineLength:1 lineSpacing:1 linecolor:COLOR(188, 188, 188, 1)];
        [headerView addSubview:line];
        
    }
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, KscreenWidth, 1) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.dingDanScrollView addSubview:_tbView];
//    if ([self.vcType isEqualToString:@"1"]) {
//        _spView = [[UIView alloc]initWithFrame:CGRectMake(0, _tbView.bottom, KscreenWidth, 45*5)];
//        _spView.backgroundColor = [UIColor whiteColor];
//        [self.dingDanScrollView addSubview:_spView];
//        UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 44)];
//        headerLabel.text = @"审批";
//        headerLabel.font = [UIFont systemFontOfSize:14];
//        headerLabel.textAlignment = NSTextAlignmentCenter;
//        headerLabel.textColor = UIColorFromRGB(0x3cbaff);
//        [_spView addSubview:headerLabel];
//        UILabel* historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KscreenWidth/3, 44)];
//        historyLabel.text = @"批复历史";
//        historyLabel.font = [UIFont systemFontOfSize:12];
//        [_spView addSubview:historyLabel];
//        _rHistoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(historyLabel.right, 0, KscreenWidth - historyLabel.right, 44)];
//        _rHistoryLabel.font = [UIFont systemFontOfSize:12];
//        [_spView addSubview:_rHistoryLabel];
//        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, KscreenWidth/3, 44)];
//        _contentLabel.text = @"批复内容";
//        _contentLabel.font = [UIFont systemFontOfSize:12];
//        [_spView addSubview:_contentLabel];
//        
//        _rcontentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_contentLabel.right, _contentLabel.top, KscreenWidth - _contentLabel.right, _contentLabel.height)];
//        _rcontentLabel.font = [UIFont systemFontOfSize:12];
//        _rcontentLabel.numberOfLines = 0;
//        [_spView addSubview:_rcontentLabel];
//        
//        
//        
//        
//        
//    }
}

- (void)requestPifuHistory
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sp"];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getAnswers&data={\"id\":\"%@\",\"table\":\"ddxx\"}",_chanpinID];
    NSLog(@"审批历史字符串:%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 =[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    _pifulishiArray = [NSJSONSerialization JSONObjectWithData:[str1 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"审批历史返回:%@",_pifulishiArray);
    pifuLishicount = _pifulishiArray.count;
}

#pragma mark 审批信息页面

- (void)shenPiload
{
    //审批
    _spView = [[UIView alloc]initWithFrame:CGRectMake(0, _tbView.bottom, KscreenWidth, 180+45*pifuLishicount)];
    _spView.backgroundColor = [UIColor whiteColor];
    [self.dingDanScrollView addSubview:_spView];
    
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 44)];
    headerLabel.text = @"审批";
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = UIColorFromRGB(0x3cbaff);
    [_spView addSubview:headerLabel];
    
    //审批历史
    for (int i = 0; i < pifuLishicount; i++) {
        //审批历史
        UILabel* historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 44+45*i, KscreenWidth/3, 44)];
        historyLabel.text = @"批复历史";
        historyLabel.font = [UIFont systemFontOfSize:12];
        
        UILabel* hline = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/3, historyLabel.top, 1, historyLabel.height)];
        hline.backgroundColor = lineColor;
        
        
        UILabel *fengexian  = [[UILabel alloc]initWithFrame:CGRectMake(0, 44 + 45*i, KscreenWidth, 1)];
        fengexian.backgroundColor = lineColor;
        
        NSDictionary *dic = [_pifulishiArray objectAtIndex:i];
        NSString *spmatter = dic[@"spmatter"];
        NSString *spzt = dic[@"spzt"];
        int z = [spzt intValue];
        if (z == 0) {
            spmatter = @"未审批";
        }
        
        UILabel *shenpiInfo  = [[UILabel alloc]initWithFrame:CGRectMake(historyLabel.right+1, historyLabel.top, KscreenWidth - historyLabel.right, 30)];
        shenpiInfo.font = [UIFont systemFontOfSize:12];
        shenpiInfo.text = [NSString stringWithFormat:@"%@ ｜%@ ",dic[@"answerstatedesc"],spmatter];
        UILabel *shenpiInfo2 = [[UILabel alloc]initWithFrame:CGRectMake(historyLabel.right, historyLabel.top + 20, KscreenWidth - historyLabel.right, 24)];
        shenpiInfo2.font = [UIFont systemFontOfSize:12];
        shenpiInfo2.text = dic[@"sptime"];
        [_spView addSubview:historyLabel];
        [_spView addSubview:hline];
        [_spView addSubview:fengexian];
        [_spView addSubview:shenpiInfo];
        [_spView addSubview:shenpiInfo2];
    }
    
    UILabel *fengexian  = [[UILabel alloc]initWithFrame:CGRectMake(0, 44 + 45*pifuLishicount, KscreenWidth, 1)];
    fengexian.backgroundColor = lineColor;
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45 + 45*pifuLishicount, KscreenWidth/3, 44)];
    _contentLabel.text = @"批复内容";
    _contentLabel.font = [UIFont systemFontOfSize:12];
    UILabel* hline1 = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/3, _contentLabel.top, 1, _contentLabel.height)];
    hline1.backgroundColor = lineColor;
    
    _pifuneirong = [[UITextField alloc] initWithFrame:CGRectMake(_contentLabel.right, _contentLabel.top, KscreenWidth - _contentLabel.right, _contentLabel.height)];
    _pifuneirong.delegate = self;
    _pifuneirong.font = [UIFont systemFontOfSize:13];
    [_spView addSubview:fengexian];
    [_spView addSubview:_contentLabel];
    [_spView addSubview:hline1];
    [_spView addSubview:_pifuneirong];

    
    UILabel *fengexian1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 44 + 45*(pifuLishicount+1)+1, KscreenWidth, 1)];
    fengexian1.backgroundColor = lineColor;
    
    [_spView addSubview:fengexian1];
    
    UILabel *pifuzhuangtai = [[UILabel alloc]initWithFrame:CGRectMake(10, 44 + 45*(pifuLishicount+1)+2, KscreenWidth/3, 44)];
    pifuzhuangtai.text = @"批复状态";
    // pifuzhuangtai.backgroundColor = COLOR(231, 231, 231, 1);
    pifuzhuangtai.font = [UIFont systemFontOfSize:12];
    // pifuzhuangtai.textAlignment = NSTextAlignmentCenter;
    
    UILabel *fengexian2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 44 + 45*(pifuLishicount+2)+2, KscreenWidth, 1)];
    fengexian2.backgroundColor = lineColor;
    
    _pifuxingshi = [UIButton buttonWithType:UIButtonTypeCustom];
    _pifuxingshi.frame = CGRectMake(pifuzhuangtai.right, 44 + 45*(pifuLishicount+1), KscreenWidth/3, 44);
    _pifuxingshi.titleLabel.font = [UIFont systemFontOfSize:16];
    [_pifuxingshi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pifuxingshi addTarget:self action:@selector(pifuxingshi) forControlEvents:UIControlEventTouchUpInside];
    if ([self.model.spnodename containsString:@"特批"]) {
        [_pifuxingshi setTitle:@"特批通过" forState:UIControlStateNormal];
    }else{
        [_pifuxingshi setTitle:@"审批通过" forState:UIControlStateNormal];
    }
    
    //小竖线
    UILabel* statusline = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth/3, 44 + 45*(pifuLishicount+1)+2, 1, 44)];
    statusline.backgroundColor = lineColor;
    [_spView addSubview:statusline];
    UILabel *shulifengexian = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/3*2, 44 + 45*(pifuLishicount+1)+2, 1, 44)];
    shulifengexian.backgroundColor = lineColor;
    [_spView addSubview:shulifengexian];
    //    //大竖线
    //    UIView *shu = [[UIView alloc] initWithFrame:CGRectMake(80, 30, 1, 122)];
    //    shu.backgroundColor = [UIColor grayColor];
    //    [spView addSubview:shu];
    
    
    _pifurenname = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _pifurenname.frame = CGRectMake(KscreenWidth/3*2+1, 44 + 45*(pifuLishicount+1), KscreenWidth/3-1, 44);
    _pifurenname.titleLabel.font = [UIFont systemFontOfSize:14];
    _pifurenname.tintColor = [UIColor blackColor];
    [_pifurenname addTarget:self action:@selector(shenPiRequeat) forControlEvents:UIControlEventTouchUpInside];
    [_spView addSubview:pifuzhuangtai];
    [_spView addSubview:fengexian2];
    [_spView addSubview:_pifuxingshi];
    [_spView addSubview:_pifurenname];
    
    
    
    UIButton *pifu = [UIButton buttonWithType:UIButtonTypeCustom];
    pifu.frame = CGRectMake(KscreenWidth/2-90, 44 + 45*(pifuLishicount+2)+10, 75, 30);
    [pifu setTitle:@"确定" forState:UIControlStateNormal];
    [pifu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pifu.backgroundColor = UIColorFromRGB(0x3cbaff);
    [pifu addTarget:self action:@selector(pifuqueren) forControlEvents:UIControlEventTouchUpInside];
    
    [_spView addSubview:pifu];
    
    UIButton *chongzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhi.frame = CGRectMake(KscreenWidth/2+30, 44 + 45*(pifuLishicount+2)+10, 75, 30);
    [chongzhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongzhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongzhi.backgroundColor = UIColorFromRGB(0x3cbaff);
    [chongzhi addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];
    
    [_spView addSubview:chongzhi];
    
}

- (void)pifuxingshi
{
    _pifuxingshi.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 200, KscreenWidth - 120, 200)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.pfTableView == nil) {
        self.pfTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120,180) style:UITableViewStylePlain];
        [self.pfTableView setBackgroundColor:[UIColor grayColor]];
    }
    self.pfTableView.delegate = self;
    self.pfTableView.dataSource = self;
    [bgView addSubview:self.pfTableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    
    [self.pfTableView reloadData];
    
    
}

- (void)closePop
{
    [self.m_keHuPopView removeFromSuperview];
}

- (void)pifuqueren
{
    UIAlertView *sp = [[UIAlertView alloc] initWithTitle:@"提示"
                                                 message:@"是否审批此订单？"
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定", nil];
    sp.tag = 20010;
    
    [sp show];
}

- (void)spUPdata{
    
    /*
     
     
     特批通过返回
     action:"doSp"
     table:"ddxx"
     data:"{"recordid":"190","SPresult":"11","SPcontent":"通过返回"}"
     特批结束审批
     data:"{"recordid":"189","SPresult":"13","SPcontent":"特批结束审批"}"
     特批拒绝
     data:"{"recordid":"186","SPresult":"-2","SPcontent":"特批拒绝"}"
     转特批
     data:"{"recordid":"124","tpaccountid":"238","tpname":"lx04","SPresult":"2","SPcontent":"再次转特批"}"
     通过
     data:"{"recordid":"190","SPresult":"1","SPcontent":"通过"}"
     
     @[@"审批通过",@"审批拒绝",@"转特批",@"特批通过返回",@"特批结束审批",@"特批拒绝"];
     
     */
    
    
    if ([_pifuxingshi.titleLabel.text isEqualToString:@"审批通过"]) {
        status = 1;
    }
    
    if ([_pifuxingshi.titleLabel.text isEqualToString:@"审批拒绝"]) {
        status = -1;
    }
    
    if ([_pifuxingshi.titleLabel.text isEqualToString:@"转特批"]) {
        status = 2;
    }
    if ([_pifuxingshi.titleLabel.text isEqualToString:@"特批通过"]) {
        status = 11;
    }
    if ([_pifuxingshi.titleLabel.text isEqualToString:@"特批结束"]) {
        status = 13;
    }
    if ([_pifuxingshi.titleLabel.text isEqualToString:@"特批拒绝"]) {
        status = -2;
    }
    
    if (status == 1 || status == -1||status == 11||status == 13||status == -2) {
        /*
         action:"doSp"
         table:"fybx"
         data:"{"recordid":"203","SPresult":"1","SPcontent":"1212121212131312"}"
         
         */
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sp"];
        NSDictionary *params = @{@"action":@"doSp",@"table":@"ddxx",@"data":[NSString stringWithFormat:@"{\"SPresult\":\"%zi\",\"SPcontent\":\"%@\",\"recordid\":\"%@\"}",status,_pifuneirong.text,_model.Id]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str1 = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"批复结果返回:%@",str1);
            NSString *realStr;
            if(str1.length != 0){
                realStr =  [self replaceOthers:str1];
            }
            
            [self showAlert:realStr];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrder" object:self];
            
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSLog(@"批复上传失败");
        }];
        
        
    }else if(status == 2){
        /*
         action:"doSp"
         table:"fybx"
         data:"{"recordid":"206","tpaccountid":"218","tpname":"邢玉军","SPresult":"2","SPcontent":""}"
         
         */
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sp"];
        NSDictionary *params = @{@"action":@"doSp",@"table":@"ddxx",@"data":[NSString stringWithFormat:@"{\"recordid\":\"%@\",\"tpaccountid\":\"%@\",\"tpname\":\"%@\",\"SPresult\":\"%zi\",\"SPcontent\":\"%@\"}",_model.Id,_tPID,_pifurenname.titleLabel.text,status,_pifuneirong.text]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str1 = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"批复结果返回:%@",str1);
            NSString *realStr;
            if(str1.length != 0){
                realStr =  [self replaceOthers:str1];
            }
            [self showAlert:realStr];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrder" object:self];
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSLog(@"特批上传失败");
        }];
        
    }
    
}



- (void)chongzhi
{
    _pifuneirong.text = @"";
    [_pifurenname setTitle:@" "forState:UIControlStateNormal];
}


- (void)shenPiRequeat{
    
    _pifurenname.userInteractionEnabled = NO;
    self.m_keHuPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    //    self.m_keHuPopView.backgroundColor = [UIColor grayColor];
    self.m_keHuPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //
    _hide_keHuPopViewBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _hide_keHuPopViewBut.backgroundColor = [UIColor clearColor];
    _hide_keHuPopViewBut.frame = CGRectMake(0, 0, KscreenWidth, KscreenHeight);
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_keHuPopView addSubview:_hide_keHuPopViewBut];
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 100, KscreenWidth - 120, 300)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.m_keHuPopView addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(bgView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    if (self.tPtableView == nil) {
        self.tPtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120,280) style:UITableViewStylePlain];
        [self.tPtableView setBackgroundColor:[UIColor grayColor]];
    }
    self.tPtableView.dataSource = self;
    self.tPtableView.delegate = self;
    [bgView addSubview:self.tPtableView];
    //    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.tPtableView reloadData];
    [self tPRequest];
    
}
- (void)tPRequest{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
    NSDictionary *params = @{@"action":@"getLeaders"};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        _tPArray = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"上级领导:%@",_tPArray);
        if (_tPArray.count != 0) {
            NSDictionary *dic = _tPArray[0];
            NSString *name = dic[@"name"];
            [_pifurenname setTitle:name forState:UIControlStateNormal];
            _tPID = dic[@"id"];
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




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else if(tableView == self.pfTableView){
        
        if ([self.model.spnodename containsString:@"特批"]) {
            return _shenpixingshiArr.count;
        }else{
            return _shiArr.count;
        }
        
    }else if (tableView == self.tPtableView){
        return _tPArray.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tbView) {
        return _dataArray.count;
    }
//    if (tableView == _pfTableView) {
//        return 1;
//    }
//    if (tableView == _pfTableView) {
//        return 1;
//    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        return 280;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 10;
    }
    return 0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    DDLiuLanDetailproCell* procell = [tableView dequeueReusableCellWithIdentifier:@"DDLiuLanDetailproCellID"];
    if (!procell) {
        procell = [[[NSBundle mainBundle]loadNibNamed:@"DDLiuLanDetailproCell" owner:self options:nil]firstObject];
    }
    
    if (tableView == _tbView) {
        if (_dataArray.count!=0) {
            procell.model = _dataArray[indexPath.section];
            procell.count = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
            NSLog(@"procell.count%@",procell.count);
        }
        procell.selectionStyle = UITableViewCellSelectionStyleNone;
        return procell;
    }else if (tableView == self.pfTableView) {
        if ([self.model.spnodename containsString:@"特批"]) {
            cell.textLabel.text = [_shenpixingshiArr objectAtIndex:indexPath.row];
        }else{
            cell.textLabel.text = [_shiArr objectAtIndex:indexPath.row];
        }
        return cell;
        
    }else if(tableView == self.tPtableView){
        NSDictionary *dic = _tPArray[indexPath.row];
        cell.textLabel.text =  dic[@"name"];
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.m_keHuPopView removeFromSuperview];
    [self.tPtableView removeFromSuperview];
    NSString * str;
    if(tableView == self.pfTableView){
        
        if ([self.model.spnodename containsString:@"特批"]) {
            str = _shenpixingshiArr[indexPath.row];
        }else{
            str = _shiArr[indexPath.row];
        }
        
        [_pifuxingshi setTitle:str forState:UIControlStateNormal];
        
        if ([str isEqualToString:@"转特批"]) {
            //请求特批时的上级领导
            [self shenPiRequeat];
            [self.m_keHuPopView removeFromSuperview];
            _pifurenname.userInteractionEnabled = YES;
            
        }else{
            [_pifurenname setTitle:@"" forState:UIControlStateNormal];
            _pifurenname.userInteractionEnabled = NO;
        }
        _pifuxingshi.userInteractionEnabled = YES;
        [self.m_keHuPopView removeFromSuperview];
        
    }else if(tableView == self.tPtableView){
        NSDictionary *dic = _tPArray[indexPath.row];
        NSString *name = dic[@"name"];
        [_pifurenname setTitle:name forState:UIControlStateNormal];
        _tPID = dic[@"id"];
        [self.m_keHuPopView removeFromSuperview];
        [self.tPtableView removeFromSuperview];
    }
}




- (void)DataRequest2
{
    //产品信息 (订单详情)
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSDictionary* parmas = @{@"mobile":@"true",@"action":@"toAudit",@"table":@"ddmx",@"params":[NSString stringWithFormat:@"{\"idEQ\":\"%@\"}",_chanpinID]};
    
    [DataPost requestAFWithUrl:urlStr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* returnStr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in  arr) {
                ProMsgModel *model = [[ProMsgModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self initScrollView];
            [self creatUI];
            if ([self.vcType isEqualToString:@"1"]) {
                [self shenPiload];
            }
            _tbView.frame = CGRectMake(0, 10+45*11, KscreenWidth, 290*_dataArray.count);
            if ([self.vcType isEqualToString:@"1"]) {
                _spView.frame = CGRectMake(0, _tbView.bottom+10, KscreenWidth, 180+45*pifuLishicount);
                self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, 10+45*11+290*_dataArray.count+20+_spView.height);
            }else{
                self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, 10+45*11+290*_dataArray.count+20);
            }
            [_tbView reloadData];
            NSLog(@"产品信息%@",arr);
        }
        [_HUD hide:YES];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_HUD hide:YES];
    }];
    
}

@end
