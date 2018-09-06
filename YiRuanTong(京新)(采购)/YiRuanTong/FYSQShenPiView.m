//
//  FYSQShenPiView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/6/1.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FYSQShenPiView.h"
#import "FYSQModel.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "DataPost.h"
#define lineColor COLOR(240, 240, 240, 1);
@interface FYSQShenPiView ()
{
    
    FYSQModel *_model;
    NSInteger pifuLishicount;
    NSMutableArray *_pifulishiArray;
    UITextField *_pifuneirong;
    UIButton *_pifuxingshi;
    UIButton *_pifurenname;
    NSArray *_shenpixingshiArr;
    NSInteger status;
    MBProgressHUD *_hud;
    NSArray *_tPArray;
    NSArray *_shiArr;
    NSString *_tPID;
    UIButton* _hide_keHuPopViewBut;
}
@property(nonatomic,retain)UIScrollView *fyScrollView;
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *pftableView;
@property(nonatomic,retain)UITableView *tPtableView;



@end

@implementation FYSQShenPiView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"费用审批";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [self shenPiload];
//    _shenpixingshiArr = @[@"审批通过",@"审批拒绝",@"转特批",@"特批通过返回",@"特批结束审批",@"特批拒绝"];
    _shenpixingshiArr = @[@"特批通过",@"转特批",@"特批结束",@"特批拒绝"];
    _shiArr = @[@"审批通过",@"审批拒绝",@"转特批"];

}
- (void)initView{
    
    _fyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
    _fyScrollView.contentSize = CGSizeMake(KscreenWidth, 400);
    _fyScrollView.backgroundColor =  [UIColor clearColor];
    _fyScrollView.delegate = self;
    [self.view addSubview:_fyScrollView];
    
    //页面设置
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"申请人";
    label1.font =[UIFont systemFontOfSize:13];
    //label1.textAlignment = NSTextAlignmentCenter;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = lineColor;
    [self.fyScrollView addSubview:view1];
    [self.fyScrollView addSubview:label1];
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(91, 0, KscreenWidth - 100, 45)];
    label11.font = [UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label11];
    label11.text = _model.applyer;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"申请编号";
    label2.font =[UIFont systemFontOfSize:13];
    //label2.textAlignment = NSTextAlignmentCenter;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom , KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    UILabel  *label22 =[[UILabel alloc]initWithFrame:CGRectMake(91, label1.bottom + 1, KscreenWidth - 100, 45)];
    label22.font =[UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label2];
    [self.fyScrollView addSubview:view2];
    [self.fyScrollView addSubview:label22];
    label22.text = [NSString stringWithFormat:@"%@",_model.costno];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"申请时间";
    label3.font =[UIFont systemFontOfSize:13];
    // label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom , KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    UILabel *label33 =[[UILabel alloc]initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 100, 45)];
    label33.font =[UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label3];
    [self.fyScrollView addSubview:view3];
    [self.fyScrollView addSubview:label33];
    label33.text = _model.applytime;
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"费用类型";
    label4.font =[UIFont systemFontOfSize:13];
    //label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    UILabel *label44 =[[UILabel alloc]initWithFrame:CGRectMake(91, label3.bottom + 1, KscreenWidth - 100, 45)];
    label44.font =[UIFont systemFontOfSize:13];
    
    [self.fyScrollView addSubview:label4];
    [self.fyScrollView addSubview:view4];
    [self.fyScrollView addSubview:label44];
    label44.text = _model.costtype;
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"申请原因";
    label5.font =[UIFont systemFontOfSize:13];
    // label5.textAlignment =NSTextAlignmentCenter;
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom , KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    UILabel *label55 =[[UILabel alloc]initWithFrame:CGRectMake(91, label4.bottom + 1, KscreenWidth - 100, 45)];
    label55.font =[UIFont systemFontOfSize:13];
    
    [self.fyScrollView addSubview:label5];
    [self.fyScrollView addSubview:view5];
    [self.fyScrollView addSubview:label55];
    label55.text = _model.applyaim;
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label6.text = @"申请金额";
    label6.font =[UIFont systemFontOfSize:13];
    //label6.textAlignment =NSTextAlignmentCenter;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom , KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    UILabel *label66 =[[UILabel alloc]initWithFrame:CGRectMake(91, label5.bottom + 1, KscreenWidth - 100, 45)];
    label66.font = [UIFont systemFontOfSize:13];
    
    [self.fyScrollView addSubview:label6];
    [self.fyScrollView addSubview:view6];
    [self.fyScrollView addSubview:label66];
    label66.text =  [NSString stringWithFormat:@"%@",_model.applymoney];
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label6.bottom + 1, 80, 45)];
    label7.text = @"审批状态";
    label7.font =[UIFont systemFontOfSize:13];
    //label7.textAlignment = NSTextAlignmentCenter;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom , KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [self.fyScrollView addSubview:label7];
    [self.fyScrollView addSubview:view7];
    UILabel *label77 = [[UILabel alloc] initWithFrame:CGRectMake(91, label6.bottom + 1, KscreenWidth - 100, 45)];
    label77.font = [UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label77];
    label77.text = _model.spnodename;
    
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(10, label7.bottom + 1, 80, 45)];
    label8.text = @"备注";
    label8.font =[UIFont systemFontOfSize:13];
    //label8.textAlignment =NSTextAlignmentCenter;
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, label8.bottom , KscreenWidth, 1)];
    view8.backgroundColor = lineColor;
    [self.fyScrollView addSubview:label8];
    [self.fyScrollView addSubview:view8];
    UILabel *label88 = [[UILabel alloc] initWithFrame:CGRectMake(91, label7.bottom + 1, KscreenWidth - 100, 45)];
    label88.font = [UIFont systemFontOfSize:13];
    [self.fyScrollView addSubview:label88];
    label88.text = _model.note;

}
#pragma mark - 审批页面
- (void)requestPifuHistory
{      //审批历史数据加载
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sp"];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getAnswers&data={\"id\":\"%@\",\"table\":\"fysq\"}", _model.Id];
    NSLog(@"审批历史字符串:%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 =[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    _pifulishiArray = [NSJSONSerialization JSONObjectWithData:[str1 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"审批历史返回:%@",_pifulishiArray);
    pifuLishicount = _pifulishiArray.count;
}

- (void)shenPiload
{
    //审批
    UILabel * chanPinXinXi = [[UILabel alloc]initWithFrame:CGRectMake(0, 290, KscreenWidth, 40)];
    chanPinXinXi.text = @"审批";
    chanPinXinXi.textColor =  [UIColor blackColor];
    chanPinXinXi.backgroundColor = COLOR(231,231, 231, 1);
    chanPinXinXi.font =[UIFont systemFontOfSize:20];
    chanPinXinXi.textAlignment = NSTextAlignmentCenter;
    [self.fyScrollView addSubview:chanPinXinXi];
    
    //审批历史
    for (int i = 0; i < pifuLishicount; i++) {
        //审批历史
        UILabel * pifulishi = [[UILabel alloc]initWithFrame:CGRectMake(0, 330 + 40*i, 80, 40)];
        pifulishi.text = @"审批历史";
        pifulishi.backgroundColor = COLOR(231, 231, 231, 1);
        pifulishi.font =[UIFont systemFontOfSize:12];
        pifulishi.textAlignment = NSTextAlignmentCenter;
        
        UILabel *fengexian  = [[UILabel alloc]initWithFrame:CGRectMake(0, 330 + 40*i, KscreenWidth, 1)];
        
        fengexian.backgroundColor = [UIColor grayColor];
        
        UILabel *shenpiInfo  = [[UILabel alloc]initWithFrame:CGRectMake(82, 330 + 40*i, KscreenWidth - 90, 40)];
        
        shenpiInfo.font = [UIFont systemFontOfSize:13.0];
        NSDictionary *dic = [_pifulishiArray objectAtIndex:i];
        shenpiInfo.text = dic[@"answerstatedesc"];
        [self.fyScrollView addSubview:pifulishi];
        [self.fyScrollView addSubview:fengexian];
        [self.fyScrollView addSubview:shenpiInfo];
    }
    
    UILabel *fengexian  = [[UILabel alloc]initWithFrame:CGRectMake(0, 330 + 40*pifuLishicount, KscreenWidth, 1)];
    fengexian.backgroundColor = [UIColor grayColor];
    
    UILabel *pifuneirong = [[UILabel alloc]initWithFrame:CGRectMake(0, 330 + 40*pifuLishicount+5, 80, 40)];
    pifuneirong.text = @"批复内容";
    pifuneirong.backgroundColor = COLOR(231, 231, 231, 1);
    pifuneirong.font = [UIFont systemFontOfSize:12];
    pifuneirong.textAlignment = NSTextAlignmentCenter;
    
    _pifuneirong = [[UITextField alloc] initWithFrame:CGRectMake(82, 330 + 40*pifuLishicount, KscreenWidth - 90, 40)];
    _pifuneirong.delegate = self;
    //[self.fYsPScrollView addSubview:fengexian];
    [self.fyScrollView addSubview:pifuneirong];
    [self.fyScrollView addSubview:_pifuneirong];
    
    UILabel *fengexian1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 330+40*(pifuLishicount+1), KscreenWidth, 1)];
    fengexian1.backgroundColor = [UIColor grayColor];
    
    [self.fyScrollView addSubview:fengexian1];
    
    UILabel *pifuzhuangtai = [[UILabel alloc]initWithFrame:CGRectMake(0, 330+40*(pifuLishicount+1)+1, 80, 40)];
    pifuzhuangtai.text = @"批复状态";
    pifuzhuangtai.backgroundColor = COLOR(231, 231, 231, 1);
    pifuzhuangtai.font = [UIFont systemFontOfSize:12];
    pifuzhuangtai.textAlignment = NSTextAlignmentCenter;
    
    UILabel *fengexian2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 330+40*(pifuLishicount+2), KscreenWidth, 1)];
    fengexian2.backgroundColor = [UIColor grayColor];
    
    _pifuxingshi = [UIButton buttonWithType:UIButtonTypeCustom];
    _pifuxingshi.frame = CGRectMake(82,330+40*(pifuLishicount+1), 120, 40);
    
    if ([self.model.spnodename containsString:@"特批"]) {
        [_pifuxingshi setTitle:@"特批通过" forState:UIControlStateNormal];
    }else{
        [_pifuxingshi setTitle:@"审批通过" forState:UIControlStateNormal];
    }
    [_pifuxingshi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_pifuxingshi addTarget:self action:@selector(pifuxingshi) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *shulifengexian = [[UILabel alloc] initWithFrame:CGRectMake(202, 330+40*(pifuLishicount+1), 1, 40)];
    shulifengexian.backgroundColor = [UIColor grayColor];
    [self.fyScrollView addSubview:shulifengexian];
    
    _pifurenname = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _pifurenname.frame = CGRectMake(202, 330+40*(pifuLishicount+1), 120, 40);
    _pifurenname.tintColor = [UIColor blackColor];
    [_pifurenname addTarget:self action:@selector(shenPiRequeat) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fyScrollView addSubview:pifuzhuangtai];
    [self.fyScrollView addSubview:fengexian2];
    [self.fyScrollView addSubview:_pifuxingshi];
    [self.fyScrollView addSubview:_pifurenname];
    
    UIButton *pifu = [UIButton buttonWithType:UIButtonTypeCustom];
    pifu.frame = CGRectMake(40, 330+40*(pifuLishicount+2)+10, 75, 30);
    [pifu setTitle:@"确定" forState:UIControlStateNormal];
    [pifu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pifu.backgroundColor = [UIColor grayColor];
    [pifu addTarget:self action:@selector(pifuqueren) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fyScrollView addSubview:pifu];
    
    UIButton *chongzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhi.frame = CGRectMake(KscreenWidth - 115, 330+40*(pifuLishicount+2)+10, 75, 30);
    [chongzhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongzhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongzhi.backgroundColor = [UIColor grayColor];
    [chongzhi addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];
    
    [self.fyScrollView addSubview:chongzhi];
    
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
        [self.pftableView setBackgroundColor:[UIColor grayColor]];
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
    [self.pftableView removeFromSuperview];
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
        NSDictionary *params = @{@"action":@"doSp",@"table":@"fysq",@"data":[NSString stringWithFormat:@"{\"SPresult\":\"%zi\",\"SPcontent\":\"%@\",\"recordid\":\"%@\"}",status,_pifuneirong.text,_model.Id]};
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
            NSLog(@"批复上传失败");
        }];
        
        
    }else if(status == 2){
        /*
         action:"doSp"
         table:"fybx"
         data:"{"recordid":"206","tpaccountid":"218","tpname":"邢玉军","SPresult":"2","SPcontent":""}"
         
         */
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sp"];
        NSDictionary *params = @{@"action":@"doSp",@"table":@"fysq",@"data":[NSString stringWithFormat:@"{\"recordid\":\"%@\",\"tpaccountid\":\"%@\",\"tpname\":\"%@\",\"SPresult\":\"%zi\",\"SPcontent\":\"%@\"}",_model.Id,_tPID,_pifurenname.titleLabel.text,status,_pifuneirong.text]};
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
    return 35;
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
    NSString *strAdress = @"/account";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getLeaders"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    _tPArray = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"上级领导:%@",_tPArray);
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
    if (self.tPtableView == nil) {
        self.tPtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120,180) style:UITableViewStylePlain];
        [self.tPtableView setBackgroundColor:[UIColor grayColor]];
    }
    self.tPtableView.dataSource = self;
    self.tPtableView.delegate = self;
    [bgView addSubview:self.tPtableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.tPtableView reloadData];
    
    
}



@end
