//
//  TuiHuoShenPiVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/4/15.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "TuiHuoShenPiVC.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "THPictureView.h"

#define lineColer COLOR(240, 240, 240, 1);
@interface TuiHuoShenPiVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    NSInteger count;
    UIView *_chanPinView;
    NSArray *_pifulishiArray;
    NSInteger pifuLishicount;
    UITextField *_pifuneirong;
    UIButton *_pifuxingshi;
    UIButton *_pifurenname;
    NSInteger status;
    MBProgressHUD *_hud;
    NSArray *_shenpixingshiArr;
    
    NSMutableArray *_tPArray;
    NSArray *_shiArr;
    
    NSString *_tPID;
    UIButton* _hide_keHuPopViewBut;
}
@property(nonatomic,retain)UITableView *tPtableView;
@property(nonatomic,retain)UITableView *pftableView;
@end

@implementation TuiHuoShenPiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退货审批";
    //删除 添加按钮
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nil;
    //[self showBarWithName:@"图片" addBarWithName:nil];
    [self DataRequest];
    [self requestPifuHistory];
    
    _shenPiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    self.shenPiScrollView.contentSize = CGSizeMake(KscreenWidth, 155 + 400*count + 40*(pifuLishicount+2) );
    self.shenPiScrollView.bounces = NO;
    self.shenPiScrollView.backgroundColor = [UIColor clearColor];
    self.shenPiScrollView.delegate = self;
    [self.view addSubview:self.shenPiScrollView];
//    _shenpixingshiArr = @[@"审批通过",@"审批拒绝",@"转特批",@"特批通过返回",@"特批结束审批",@"特批拒绝"];
    _shenpixingshiArr = @[@"特批通过",@"转特批",@"特批结束",@"特批拒绝"];
    _shiArr = @[@"审批通过",@"审批拒绝",@"转特批"];
    [self initCust];
    [self initPro];
    [self shenPiload];
}

- (void)DataRequest
{
    /*
     产品信息的接口
     http://182.92.96.58:8005/yrt/servlet/goodsreturn
     action=toUpdateReturn
     table=thmx
     params	{"idEQ":"184"}
     */
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/goodsreturn"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=toUpdateReturn&table=thmx&params={\"idEQ\":\"%@\"}",_model.Id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
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
            _xiangQinArray = arr;
            NSLog(@"退货详情%@",_xiangQinArray);
            count = _xiangQinArray.count;
        }
    }

    
}

- (void)requestPifuHistory
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sp"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getAnswers&data={\"id\":\"%@\",\"table\":\"thxx\"}",_model.Id];
    NSLog(@"审批历史字符串:%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        _pifulishiArray = [NSJSONSerialization JSONObjectWithData:[str1 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"审批历史返回:%@",_pifulishiArray);
        pifuLishicount = _pifulishiArray.count;
    }
   
}

- (void)shenPiload
{
    //审批
    UIView   *spView = [[UIView alloc] initWithFrame:CGRectMake(0,  137 + count * 384, KscreenWidth, 150 + 40*pifuLishicount)];
    spView.backgroundColor = [UIColor whiteColor];
    [self.shenPiScrollView addSubview:spView];
    
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
        fengexian.backgroundColor = lineColer;
        
        
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
    fengexian.backgroundColor = lineColer;
    
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
    fengexian1.backgroundColor = lineColer;
    
    [spView addSubview:fengexian1];
    
    UILabel *pifuzhuangtai = [[UILabel alloc]initWithFrame:CGRectMake(10, 30 + 40*(pifuLishicount+1)+2, 80, 40)];
    pifuzhuangtai.text = @"批复状态";
    // pifuzhuangtai.backgroundColor = COLOR(231, 231, 231, 1);
    pifuzhuangtai.font = [UIFont systemFontOfSize:12];
    // pifuzhuangtai.textAlignment = NSTextAlignmentCenter;
    
    UILabel *fengexian2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 + 40*(pifuLishicount+2)+2, KscreenWidth, 1)];
    fengexian2.backgroundColor = lineColer;
    
    _pifuxingshi = [UIButton buttonWithType:UIButtonTypeCustom];
    _pifuxingshi.frame = CGRectMake(82, 30 + 40*(pifuLishicount+1), 120, 40);
    _pifuxingshi.titleLabel.font = [UIFont systemFontOfSize:16];
    if ([self.model.spnodename containsString:@"特批"]) {
        [_pifuxingshi setTitle:@"特批通过" forState:UIControlStateNormal];
    }else{
        [_pifuxingshi setTitle:@"审批通过" forState:UIControlStateNormal];
    }
    [_pifuxingshi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pifuxingshi addTarget:self action:@selector(pifuxingshi) forControlEvents:UIControlEventTouchUpInside];
    
    //小竖线
    UILabel *shulifengexian = [[UILabel alloc] initWithFrame:CGRectMake(202, 30 + 40*(pifuLishicount+1)+2, 1, 40)];
    shulifengexian.backgroundColor = lineColer;
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
    if (self.pftableView == nil) {
        self.pftableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120,180) style:UITableViewStylePlain];
        [self.tableView setBackgroundColor:[UIColor grayColor]];
    }
    self.pftableView.dataSource = self;
    self.pftableView.delegate = self;
    [bgView addSubview:self.pftableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.pftableView reloadData];
}

- (void)closePop
{
    [self.m_keHuPopView removeFromSuperview];
    [self.tableView removeFromSuperview];
}

//批复
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
        NSDictionary *params = @{@"action":@"doSp",@"table":@"thxx",@"data":[NSString stringWithFormat:@"{\"SPresult\":\"%zi\",\"SPcontent\":\"%@\",\"recordid\":\"%@\"}",status,_pifuneirong.text,_model.Id]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str1 = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"批复结果返回:%@",str1);
            NSString *realStr;
            if(str1.length != 0){
                realStr =  [self replaceOthers:str1];
            }
            
            [self showAlert:realStr];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newReturn" object:self];
            
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
        NSDictionary *params = @{@"action":@"doSp",@"table":@"thxx",@"data":[NSString stringWithFormat:@"{\"recordid\":\"%@\",\"tpaccountid\":\"%@\",\"tpname\":\"%@\",\"SPresult\":\"%zi\",\"SPcontent\":\"%@\"}",_model.Id,_tPID,_pifurenname.titleLabel.text,status,_pifuneirong.text]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str1 = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"批复结果返回:%@",str1);
            NSString *realStr;
            if(str1.length != 0){
                realStr =  [self replaceOthers:str1];
            }
            [self showAlert:realStr];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
            NSLog(@"特批上传失败");
        }];
        
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





- (void)chongzhi
{
    _pifuneirong.text = @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.pftableView){
        if ([self.model.spnodename containsString:@"特批"]) {
            return _shenpixingshiArr.count;
        }else{
            return _shiArr.count;
        }
    }else{
        return _tPArray.count;
    }
    
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
    if (tableView == self.pftableView) {
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
    if(tableView == self.pftableView){
        
        if ([self.model.spnodename containsString:@"特批"]) {
            str = _shenpixingshiArr[indexPath.row];
        }else{
            str = _shiArr[indexPath.row];
        }
        
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

#pragma mark - 页面设置
-(void)initCust
{
    UILabel * keHuName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    keHuName.text = @"客户名称";
    keHuName.font =[UIFont systemFontOfSize:13];
    UIView *keHuNameView =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    keHuNameView.backgroundColor = lineColer;
    [self.shenPiScrollView addSubview:keHuNameView];
    [self.shenPiScrollView addSubview:keHuName];
    UILabel * keHuName1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, KscreenWidth - 100, 45)];
    keHuName1.font =[UIFont systemFontOfSize:13];
    keHuName1.textAlignment = NSTextAlignmentLeft;
    [self.shenPiScrollView addSubview:keHuName1];
    keHuName1.text = _model.custname;
    //
    UILabel * yeWuYuan = [[UILabel alloc]initWithFrame:CGRectMake(10, 46, 80, 45)];
    yeWuYuan.text = @"业务员";
    yeWuYuan.font = [UIFont systemFontOfSize:13];
    UIView *yeWuYuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 91, KscreenWidth, 1)];
    yeWuYuanView.backgroundColor = lineColer;
    [self.shenPiScrollView addSubview:yeWuYuanView];
    [self.shenPiScrollView addSubview:yeWuYuan];
    
    UILabel *yeWuYuan1 =[[UILabel alloc]initWithFrame:CGRectMake(90, 46, KscreenWidth - 100, 45)];
    yeWuYuan1.font =[UIFont systemFontOfSize:13];
    yeWuYuan1.textAlignment = NSTextAlignmentLeft;
    [self.shenPiScrollView addSubview:yeWuYuan1];
    yeWuYuan1.text = _model.saler;
    
    //
    UILabel * tuiHuoYuanYin = [[UILabel alloc]initWithFrame:CGRectMake(10, 92, 80, 45)];
    tuiHuoYuanYin.text = @"退货原因";
    tuiHuoYuanYin.font =[UIFont systemFontOfSize:13];
    UIView *tuiHuoYuanYinView =[[UIView alloc]initWithFrame:CGRectMake(0, 137, KscreenWidth, 1)];
    tuiHuoYuanYinView.backgroundColor = lineColer;
    [self.shenPiScrollView addSubview:tuiHuoYuanYinView];
    [self.shenPiScrollView addSubview:tuiHuoYuanYin];
    
    UILabel *tuiHuoYuanYin1 =[[UILabel alloc]initWithFrame:CGRectMake(90, 92, KscreenWidth - 100, 45)];
    tuiHuoYuanYin1.font =[UIFont systemFontOfSize:13];
    tuiHuoYuanYin1.textAlignment = NSTextAlignmentLeft;
    [self.shenPiScrollView addSubview:tuiHuoYuanYin1];
    tuiHuoYuanYin1.text = _model.returnreason;
    
}
-(void)initPro{
    
    for (int i = 0; i < count; i ++) {
        _chanPinView = [[UIView alloc] initWithFrame:CGRectMake(0, 137 +i* 384, KscreenWidth, 384)];
        
        NSDictionary *dic = _xiangQinArray[i];
        
        UILabel *chanPinXinXi=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 24)];
        chanPinXinXi.text = [NSString stringWithFormat:@"产品信息(%zi)",i + 1 ];
        chanPinXinXi.font =[UIFont systemFontOfSize:18];
        chanPinXinXi.backgroundColor = COLOR(240, 240, 240, 1);
        chanPinXinXi.textAlignment = NSTextAlignmentCenter;
        [_chanPinView addSubview:chanPinXinXi];
        //////////
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 80, 45)];
        label1.text = @"产品名称";
        label1.font =[UIFont systemFontOfSize:13];
        UIView *chanPinNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, KscreenWidth, 1)];
        chanPinNameView.backgroundColor = lineColer;
        [_chanPinView addSubview:label1];
        [_chanPinView addSubview:chanPinNameView];
        
        UILabel * chanPinName1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 25, KscreenWidth - 100, 45)];
        chanPinName1.font =[UIFont systemFontOfSize:13];
        chanPinName1.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:chanPinName1];
        chanPinName1.text = dic[@"proname"];
        
        UILabel *label2 =[[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
        label2.text = @"产品编码";
        label2.font =[UIFont systemFontOfSize:13];
        UIView *faHuoDanHaoView =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
        faHuoDanHaoView.backgroundColor = lineColer;
        [_chanPinView addSubview:faHuoDanHaoView];
        [_chanPinView addSubview:label2];
        
        UILabel * chanpinBianMa = [[UILabel alloc]initWithFrame:CGRectMake(90, label1.bottom + 1 , KscreenWidth - 100, 45)];
        chanpinBianMa.font =[UIFont systemFontOfSize:13];
        chanpinBianMa.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:chanpinBianMa];
        chanpinBianMa.text = dic[@"prono"];
        //
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
        label3.text = @"产品规格";
        label3.font =[UIFont systemFontOfSize:13];
        UIView *chanPinGuiGeView =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom, KscreenWidth, 1)];
        chanPinGuiGeView.backgroundColor =  lineColer;
        [_chanPinView addSubview:chanPinGuiGeView];
        [_chanPinView addSubview:label3];
        
        UILabel * chanPinGuiGe1 = [[UILabel alloc]initWithFrame:CGRectMake(90, label2.bottom + 1, KscreenWidth - 100, 45)];
        chanPinGuiGe1.font =[UIFont systemFontOfSize:13];
        chanPinGuiGe1.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:chanPinGuiGe1];
        chanPinGuiGe1.text = dic[@"specification"];
        //
        UILabel *label4 =[[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
        label4.text = @"产品单位";
        label4.font =[UIFont systemFontOfSize:13];
        UIView *chanPinDanWeiView = [[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom, KscreenWidth, 1)];
        chanPinDanWeiView.backgroundColor =  lineColer;
        [_chanPinView addSubview:chanPinDanWeiView];
        [_chanPinView addSubview:label4];
        
        UILabel * chanPinDanWei1 = [[UILabel alloc]initWithFrame:CGRectMake(90, label3.bottom + 1, KscreenWidth - 100, 45)];
        chanPinDanWei1.textAlignment = NSTextAlignmentLeft;
        chanPinDanWei1.font =[UIFont systemFontOfSize:13];
        [_chanPinView addSubview:chanPinDanWei1];
        chanPinDanWei1.text = dic[@"prounitname"];
        //
        UILabel *label5 =[[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
        label5.text = @"单价";
        label5.font =[UIFont systemFontOfSize:13];
        UIView *danJiaView =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom, KscreenWidth, 1)];
        danJiaView.backgroundColor = lineColer;
        [_chanPinView addSubview:danJiaView];
        [_chanPinView addSubview:label5];
        UILabel * danJia1 = [[UILabel alloc]initWithFrame:CGRectMake(90, label4.bottom + 1, KscreenWidth - 100, 45)];
        danJia1.font =[UIFont systemFontOfSize:13];
        [_chanPinView addSubview:danJia1];
        danJia1.textAlignment = NSTextAlignmentLeft;
        NSString *singleprice =[NSString stringWithFormat:@"%@",dic[@"singleprice"]];
        danJia1.text =singleprice;
        
        
        //
        UILabel *label6 =[[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
        label6.text = @"产品批号";
        label6.font =[UIFont systemFontOfSize:13];
        UIView *chanPinPiHaoView =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom, KscreenWidth, 1)];
        chanPinPiHaoView.backgroundColor =  lineColer;
        [_chanPinView addSubview:chanPinPiHaoView];
        [_chanPinView addSubview:label6];
        
        UILabel * chanPinPiHao1 = [[UILabel alloc]initWithFrame:CGRectMake(90,label5.bottom + 1, KscreenWidth - 100, 45)];
        chanPinPiHao1.font =[UIFont systemFontOfSize:13];
        chanPinPiHao1.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:chanPinPiHao1];
        chanPinPiHao1.text = dic[@"probatch"];
        //
        UILabel *label7 =[[UILabel alloc]initWithFrame:CGRectMake(10,label6.bottom + 1, 80, 45)];
        label7.text = @"退货数量";
        label7.font =[UIFont systemFontOfSize:13];
        UIView *tuiHuoShuLiangView =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom, KscreenWidth, 1)];
        tuiHuoShuLiangView.backgroundColor =  lineColer;
        [_chanPinView addSubview:tuiHuoShuLiangView];
        [_chanPinView addSubview:label7];
        UILabel * tuiHuoShuLiang1 = [[UILabel alloc]initWithFrame:CGRectMake(90,label6.bottom + 1, KscreenWidth - 100, 45)];
        tuiHuoShuLiang1.font =[UIFont systemFontOfSize:13];
        tuiHuoShuLiang1.textAlignment = NSTextAlignmentLeft;
        [_chanPinView addSubview:tuiHuoShuLiang1];
        NSString *procount =[NSString stringWithFormat:@"%@",dic[@"procount"]];
        tuiHuoShuLiang1.text =procount;
        
        //
        UILabel *label8 =[[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 80, 45)];
        label8.text = @"退货金额";
        label8.font =[UIFont systemFontOfSize:13];
        UIView *tuiHuoJinEView =[[UIView alloc]initWithFrame:CGRectMake(0,label8.bottom, KscreenWidth, 1)];
        tuiHuoJinEView.backgroundColor =  lineColer;
        [_chanPinView addSubview:tuiHuoJinEView];
        [_chanPinView addSubview:label8];
        
        UILabel * tuiHuoJinE1 = [[UILabel alloc]initWithFrame:CGRectMake(90,label7.bottom + 1, KscreenWidth - 100, 45)];
        tuiHuoJinE1.font =[UIFont systemFontOfSize:13];
        tuiHuoJinE1.textAlignment = NSTextAlignmentLeft;
        NSString *returnmoney =[NSString stringWithFormat:@"%@",dic[@"goodsmoney"]];
        tuiHuoJinE1.text =returnmoney;
        [_chanPinView addSubview:tuiHuoJinE1];
        
        [self.shenPiScrollView addSubview:_chanPinView];
        
    }
}

- (void)addNext{
    NSLog(@"跳转");
    THPictureView *PicVC = [[THPictureView alloc] init];
    PicVC.tHIId = _model.Id;
    [self.navigationController pushViewController:PicVC animated:YES];
    
}
- (void)searchAction{
    
}

@end
