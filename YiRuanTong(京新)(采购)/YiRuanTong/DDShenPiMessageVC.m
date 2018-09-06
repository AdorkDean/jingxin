//
//  DDShenPiMessageVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/4/14.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "DDShenPiMessageVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "ProMsgModel.h"
#import "UIViewExt.h"
#import "DataPost.h"

#define lineColor COLOR(240, 240, 240, 1);
@interface DDShenPiMessageVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    
    UIView *_backView;
    UIView *_chanPinView;
    NSInteger count;
    NSInteger pifuLishicount;
    NSArray *_pifulishiArray;
    UITextField *_pifuneirong;
    UIButton *_pifuxingshi;
    UIButton *_pifurenname;
    NSArray *_shenpixingshiArr;
   
    NSInteger status;
    MBProgressHUD *_hud;
    NSString *_tPID;
    
    NSMutableString  *_showStr;
    //代收字段
    UILabel *_daiShouLabel;
    UILabel *_daiShouMoneyLabel;
    //客户信息
    UIButton  *_nameButton;
    UITextField *_yuEField;
    UIButton *_payTypeButton;
    NSMutableArray *_tPArray;
    // //客户联系人物流字段
    UIButton *_wuLiuButton;
    UITextField *_receiver;
    UITextField *_receiveTel;
    UITextField *_receiveAdd;
    UIButton *_wuLiuDaiShou;
    UITextField *_daiShouJinE;
    UITextField *_note;
    UIButton* _hide_keHuPopViewBut;
}
@property(nonatomic,retain)UITableView *tPtableView;
@property(nonatomic,retain)UITableView *pfTableView;


@end

@implementation DDShenPiMessageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"订单审批";
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = [NSMutableArray array];
    [self DataRequest1];
    [self DataRequest2];
    [self requestPifuHistory];
    [self initScrollView];
    [self initCustView];
    [self initDetailView];
    [self initCustDetailView];
    [self shenPiload];
    
    
    
    _shenpixingshiArr = @[@"审批通过",@"审批拒绝",@"转特批",@"特批通过返回",@"特批结束审批",@"特批拒绝"];
    //_tePiArray = @[@"转特批",@"特批通过返回",@"特批结束审批",@"特批拒绝"];
}

- (void)initScrollView {
    self.dingDanScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    self.dingDanScrollView.showsVerticalScrollIndicator = NO;
    NSLog(@"%zi",count);
    self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, 316 + 155*count+40*(pifuLishicount+2));
    self.dingDanScrollView.bounces = NO;
    self.dingDanScrollView.backgroundColor =[UIColor clearColor];
    self.dingDanScrollView.delegate =self;
    [self.view addSubview:self.dingDanScrollView];
    //导航栏状态按钮
//    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    stateButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
//    [stateButton setTitle:@"状态" forState:UIControlStateNormal];
//    [stateButton addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:stateButton];
//    self.navigationItem.rightBarButtonItem = right;
//    
}
//状态按钮的显示
- (void)stateAction:(UIButton *)button{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getOrderStatus&orderno=%@",_orderId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 =[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    
    if (str1.length != 0) {
        NSRange range = {1,str1.length - 2};
        NSString *labelStr = [str1 substringWithRange:range];
        NSLog(@"%@",labelStr);
        _showStr = [[NSMutableString alloc]initWithString:labelStr];
        
        NSRange replaceRange = [_showStr rangeOfString:@"\"\n\""];
        if (replaceRange.location != NSNotFound) {
            [_showStr replaceCharactersInRange:replaceRange withString:@" "];
        }
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
        _backView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_backView];
        
        UIButton *yesbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        yesbutton.frame = CGRectMake(0,60, KscreenWidth, KscreenHeight - 64 - 120);
        [yesbutton addTarget:self action:@selector(yesButton) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:yesbutton];
        
        UILabel *stateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth , 120)];
        stateLabel1.backgroundColor = [UIColor whiteColor];
        stateLabel1.font = [UIFont systemFontOfSize:20];
        stateLabel1.numberOfLines = 0;
        stateLabel1.lineBreakMode = 0;
        stateLabel1.text = _showStr;
        [_backView addSubview:stateLabel1];
        
    } else {
        
    }
   
}
- (void)yesButton{
    
    [_backView removeFromSuperview];
}
#pragma mark  数据加载
-(void)DataRequest1
{
    //物流信息（订单详情） 的接口   解析good
    //拼接地址字符串
    NSString *strAdress = @"/customer";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getLogisInfo&params={\"idEQ\":\"%@\"}&table=wlxx",_wuliuID];
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options: NSJSONReadingAllowFragments error:nil];
        if (array.count > 0) {
            _wuLiuData = array[0];
        }
        NSLog(@"物流信息%@",_wuLiuData);
    }else{
        UIAlertView *tan =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"物流信息加载失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    }
    
}

- (void)DataRequest2
{
    //产品信息（订单详情）
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/order"];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"mobile=true&action=toAudit&params={\"idEQ\":\"%@\"}&table=ddmx",_chanpinID];
    
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
        
        }
    }
    
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
    UIView   *spView = [[UIView alloc] initWithFrame:CGRectMake(0,  440 + 45 + count * 455, KscreenWidth, 150 + 40 * pifuLishicount)];
    spView.backgroundColor = [UIColor whiteColor];
    [self.dingDanScrollView addSubview:spView];
    
    UILabel * chanPinXinXi = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 30)];
    chanPinXinXi.text = @"审批";
    chanPinXinXi.backgroundColor = COLOR(230, 230, 230, 1);
    chanPinXinXi.textColor =  [UIColor blackColor];
    chanPinXinXi.font =[UIFont systemFontOfSize:20];
    chanPinXinXi.textAlignment = NSTextAlignmentCenter;
    [spView addSubview:chanPinXinXi];
    
    //审批历史
    for (int i = 0; i < pifuLishicount; i++) {
        //审批历史
        UILabel * pifulishi = [[UILabel alloc]initWithFrame:CGRectMake(10, 30 +  40*i, 80, 40)];
        pifulishi.text = @"审批历史";
       // pifulishi.backgroundColor = COLOR(231, 231, 231, 1);
        pifulishi.font =[UIFont systemFontOfSize:12];
       // pifulishi.textAlignment = NSTextAlignmentCenter;
        
        UILabel *fengexian  = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 + 40*i, KscreenWidth, 1)];
        fengexian.backgroundColor = lineColor;
        
        NSDictionary *dic = [_pifulishiArray objectAtIndex:i];
        NSString *spmatter = dic[@"spmatter"];
        NSString *spzt = dic[@"spzt"];
        int z = [spzt intValue];
        if (z == 0) {
            spmatter = @"未审批";
        }
        
        UILabel *shenpiInfo  = [[UILabel alloc]initWithFrame:CGRectMake(82, 30 + 40*i, 240, 20)];
        shenpiInfo.font = [UIFont systemFontOfSize:12];
        
        shenpiInfo.text = [NSString stringWithFormat:@"%@ ｜%@ ",dic[@"answerstatedesc"],spmatter];
        UILabel *shenpiInfo2 = [[UILabel alloc]initWithFrame:CGRectMake(82, 30 + 40*i + 20, 240, 20)];
        shenpiInfo2.font = [UIFont systemFontOfSize:12];
        shenpiInfo2.text = dic[@"sptime"];
        [spView addSubview:pifulishi];
        [spView addSubview:fengexian];
        [spView addSubview:shenpiInfo];
        [spView addSubview:shenpiInfo2];
    }
    
    UILabel *fengexian  = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 + 40*pifuLishicount, KscreenWidth, 1)];
    fengexian.backgroundColor = lineColor;
    
    UILabel *pifuneirong = [[UILabel alloc]initWithFrame:CGRectMake(10, 30 + 40*pifuLishicount +1, 80, 40)];
    pifuneirong.text = @"批复内容";
   // pifuneirong.backgroundColor = COLOR(231, 231, 231, 1);
    pifuneirong.font = [UIFont systemFontOfSize:12];
   // pifuneirong.textAlignment = NSTextAlignmentCenter;
    
    _pifuneirong = [[UITextField alloc] initWithFrame:CGRectMake(82, 30 + 40*pifuLishicount, 240, 40)];
    _pifuneirong.delegate = self;
    _pifuneirong.font = [UIFont systemFontOfSize:13];
    [spView addSubview:fengexian];
    [spView addSubview:pifuneirong];
    [spView addSubview:_pifuneirong];
    
    UILabel *fengexian1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 + 40*(pifuLishicount+1)+1, KscreenWidth, 1)];
    fengexian1.backgroundColor = lineColor;
    
    [spView addSubview:fengexian1];
    
    UILabel *pifuzhuangtai = [[UILabel alloc]initWithFrame:CGRectMake(10, 30 + 40*(pifuLishicount+1)+2, 80, 40)];
    pifuzhuangtai.text = @"批复状态";
   // pifuzhuangtai.backgroundColor = COLOR(231, 231, 231, 1);
    pifuzhuangtai.font = [UIFont systemFontOfSize:12];
   // pifuzhuangtai.textAlignment = NSTextAlignmentCenter;
    
    UILabel *fengexian2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 + 40*(pifuLishicount+2)+2, KscreenWidth, 1)];
    fengexian2.backgroundColor = lineColor;
    
    _pifuxingshi = [UIButton buttonWithType:UIButtonTypeCustom];
    _pifuxingshi.frame = CGRectMake(82, 30 + 40*(pifuLishicount+1), 120, 40);
    _pifuxingshi.titleLabel.font = [UIFont systemFontOfSize:16];
    [_pifuxingshi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pifuxingshi addTarget:self action:@selector(pifuxingshi) forControlEvents:UIControlEventTouchUpInside];
    [_pifuxingshi setTitle:@"审批通过" forState:UIControlStateNormal];
    
    //小竖线
    UILabel *shulifengexian = [[UILabel alloc] initWithFrame:CGRectMake(202, 30 + 40*(pifuLishicount+1)+2, 1, 40)];
    shulifengexian.backgroundColor = lineColor;
    [spView addSubview:shulifengexian];
//    //大竖线
//    UIView *shu = [[UIView alloc] initWithFrame:CGRectMake(80, 30, 1, 122)];
//    shu.backgroundColor = [UIColor grayColor];
//    [spView addSubview:shu];
    
    
    _pifurenname = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _pifurenname.frame = CGRectMake(202, 30 + 40*(pifuLishicount+1), 120, 40);
    _pifurenname.titleLabel.font = [UIFont systemFontOfSize:14];
    _pifurenname.tintColor = [UIColor blackColor];
    [_pifurenname addTarget:self action:@selector(shenPiRequeat) forControlEvents:UIControlEventTouchUpInside];
    [spView addSubview:pifuzhuangtai];
    [spView addSubview:fengexian2];
    [spView addSubview:_pifuxingshi];
    [spView addSubview:_pifurenname];
    
    
    
    UIButton *pifu = [UIButton buttonWithType:UIButtonTypeCustom];
    pifu.frame = CGRectMake(40, 30 + 40*(pifuLishicount+2)+10, 75, 30);
    [pifu setTitle:@"确定" forState:UIControlStateNormal];
    [pifu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pifu.backgroundColor = [UIColor grayColor];
    [pifu addTarget:self action:@selector(pifuqueren) forControlEvents:UIControlEventTouchUpInside];
    
    [spView addSubview:pifu];
    
    UIButton *chongzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhi.frame = CGRectMake(40+60+75, 30 + 40*(pifuLishicount+2)+10, 75, 30);
    [chongzhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongzhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongzhi.backgroundColor = [UIColor grayColor];
    [chongzhi addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];
    
    [spView addSubview:chongzhi];

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
    self.pfTableView.dataSource = self;
    self.pfTableView.delegate = self;
    [bgView addSubview:self.pfTableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.pfTableView reloadData];
    
    
}

- (void)closePop
{
    [self.m_keHuPopView removeFromSuperview];
    [self.tableView removeFromSuperview];
}

- (void)pifuqueren
{
    UIAlertView *sp = [[UIAlertView alloc] initWithTitle:@"提示"
                                                 message:@"是否审批此订单？"
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定", nil];
    
    [sp show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [self spUPdata];
    }

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
    if ([_pifuxingshi.titleLabel.text isEqualToString:@"特批通过返回"]) {
        status = 11;
    }
    if ([_pifuxingshi.titleLabel.text isEqualToString:@"特批结束审批"]) {
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
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.pfTableView){
        
        return _shenpixingshiArr.count;
        
    }else if (tableView == self.tPtableView){
        return _tPArray.count;
    }
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if (tableView == self.pfTableView) {
        cell.textLabel.text = [_shenpixingshiArr objectAtIndex:indexPath.row];
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
    
    if(tableView == self.pfTableView){
       
        NSString *str = _shenpixingshiArr[indexPath.row];
        [_pifuxingshi setTitle:str forState:UIControlStateNormal];
       
        if ([str isEqualToString:@"转特批"]) {
            //请求特批时的上级领导
            [self shenPiRequeat];
            [self.m_keHuPopView removeFromSuperview];
            [self.tableView removeFromSuperview];
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
   // [_nameButton addTarget:self action:@selector(nameAction) forControlEvents:UIControlEventTouchUpInside];
    _nameButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dingDanScrollView addSubview:_nameButton];
    [_nameButton setTitle:_model.custname forState:UIControlStateNormal];
    
    UIView *line1  = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    line1.backgroundColor = COLOR(240, 240, 240, 1);
    [self.dingDanScrollView addSubview:line1];
    
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



#pragma mark 产品信息
- (void)initDetailView{
    //添加产品的按钮设置
    NSLog(@"产品信息%zi",count);
    for (int i = 0; i < count; i++) {
        ProMsgModel *model = _dataArray[i];
        
        self.dingDanScrollView.contentSize = CGSizeMake(KscreenWidth, 150 + count * 455 + 500 + 50 + 40 *pifuLishicount);
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
        //[CPNameBtn addTarget:self action:@selector(proAction) forControlEvents:UIControlEventTouchUpInside];
        [chanpinView addSubview:CPNameBtn];
        [CPNameBtn setTitle:model.proname forState:UIControlStateNormal];
        //[_cpNameBtnArray addObject:CPNameBtn];
        
        
        
        
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
        //[_cpCodeArray addObject:proNo];
        
        
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
       // [_cpGuigeArray addObject:chanPinGuiGe1];
        
        
        
        
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
        //[_cpDanweiArray addObject:chanPinDanWeiButton1];
        
        
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
        //[_singlePriceArray addObject:danJia1];
        
        
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
        //    [_xiaoshouTypeArray addObject:xiaoShouLeiXingButton1];
        
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
       // [_fanliLvArray addObject:returnRate1];

        
        
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
        //[_countArray addObject:shuLiang1];
        
        
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
        //[_JineArray addObject:jinE1];

        
        [self.dingDanScrollView addSubview:chanpinView];
        
        //[_chanpinViewArray addObject:chanpinView];
        chanpinView.userInteractionEnabled = NO;
        
    }
}

- (void)initCustDetailView{
    
    UIView *fenGeView = [[UIView alloc] initWithFrame:CGRectMake(0, 137 + count * 455, KscreenWidth, 20)];
    fenGeView.backgroundColor = COLOR(230, 230, 230, 1);
    [self.dingDanScrollView addSubview:fenGeView];
    
    //
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
  //  [_wuLiuButton addTarget:self action:@selector(wuLiuAction) forControlEvents:UIControlEventTouchUpInside];
    
    [detailView addSubview:_wuLiuButton];
    NSString *wuliu = _wuLiuData[@"logname"];
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
