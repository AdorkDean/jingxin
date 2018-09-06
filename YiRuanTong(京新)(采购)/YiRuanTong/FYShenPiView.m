//
//  FYShenPiView.m
//  YiRuanTong
//
//  Created by 联祥 on 15/5/25.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FYShenPiView.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"

#import "DataPost.h"

#define lineColor COLOR(240, 240, 240, 1);
@interface FYShenPiView ()
{
    
    NSInteger _count;
    NSArray *_array;
    NSInteger pifuLishicount;
    NSArray *_pifulishiArray;
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
@property(nonatomic,retain)UIScrollView *fYsPScrollView;
@property(nonatomic,retain)UITableView *pfTabelView;
@property(nonatomic,retain)UIView *m_keHuPopView;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UITableView *tPtableView;
@end

@implementation FYShenPiView
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"审批详情";
    self.navigationItem.rightBarButtonItem = nil;
    self.view .backgroundColor = [UIColor whiteColor];
    
    [self dataRequest];
    [self initScrollView];
    [self initDetailView];
    [self initDetailView2];
    [self shenPiload];
//    _shenpixingshiArr = @[@"审批通过",@"审批拒绝",@"转特批",@"特批通过返回",@"特批结束审批",@"特批拒绝"];
    _shenpixingshiArr = @[@"特批通过",@"转特批",@"特批结束",@"特批拒绝"];
    _shiArr = @[@"审批通过",@"审批拒绝",@"转特批"];
}
- (void)initScrollView{
    _fYsPScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _fYsPScrollView.showsVerticalScrollIndicator = NO;
    
    _fYsPScrollView.bounces = NO;
    _fYsPScrollView.backgroundColor =[UIColor clearColor];
    _fYsPScrollView.delegate =self;
    [self.view addSubview:_fYsPScrollView];
    
    
    
}
- (void)initDetailView{
    //
    //
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
    label1.text = @"报销人";
    label1.font =[UIFont systemFontOfSize:13];
    label1.textAlignment = NSTextAlignmentLeft;
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    view1.backgroundColor = COLOR(240, 240, 240, 1);
    [self.fYsPScrollView addSubview:view1];
    [self.fYsPScrollView addSubview:label1];
    UILabel * applyer = [[UILabel alloc]initWithFrame:CGRectMake(91, 0, KscreenWidth - 100, 45)];
    applyer.font =[UIFont systemFontOfSize:13];
    [self.fYsPScrollView addSubview:applyer];
    applyer.text = _model.applyer;
    //
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
    label2.text = @"日期";
    label2.font =[UIFont systemFontOfSize:13];
    label2.textAlignment = NSTextAlignmentLeft;
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
    view2.backgroundColor = lineColor;
    [self.fYsPScrollView addSubview:view2];
    [self.fYsPScrollView addSubview:label2];
    UILabel *applytime =[[UILabel alloc]initWithFrame:CGRectMake(91, label1.bottom + 1, KscreenWidth - 100, 45)];
    applytime.font =[UIFont systemFontOfSize:13];
    [self.fYsPScrollView addSubview:applytime];
    applytime.text = _model.applytime;
    //
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
    label3.text = @"发票合计";
    label3.font =[UIFont systemFontOfSize:13];
    //    label3.textAlignment =NSTextAlignmentCenter;
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom , KscreenWidth, 1)];
    view3.backgroundColor = lineColor;
    [self.fYsPScrollView addSubview:view3];
    [self.fYsPScrollView addSubview:label3];
    UILabel *totalnum =[[UILabel alloc]initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 100, 45)];
    totalnum.font =[UIFont systemFontOfSize:13];
    [self.fYsPScrollView addSubview:totalnum];
    totalnum.text = [NSString stringWithFormat:@"%@",_model.totalnum];
    //
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
    label4.text = @"金额合计";
    label4.font =[UIFont systemFontOfSize:13];
    // label4.textAlignment =NSTextAlignmentCenter;
    UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 1)];
    view4.backgroundColor = lineColor;
    [self.fYsPScrollView addSubview:view4];
    [self.fYsPScrollView addSubview:label4];
    UILabel *applymoney =[[UILabel alloc]initWithFrame:CGRectMake(91, label3.bottom + 1, KscreenWidth - 100, 45)];
    applymoney.font =[UIFont systemFontOfSize:13];
    [self.fYsPScrollView addSubview:applymoney];
    applymoney.text = [NSString stringWithFormat:@"%@",_model.applymoney];
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, label4.bottom + 1, 80, 45)];
    label5.text = @"还款合计";
    label5.font =[UIFont systemFontOfSize:13];
    label5.textAlignment = NSTextAlignmentLeft;
    UIView *view5 =[[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom , KscreenWidth, 1)];
    view5.backgroundColor = lineColor;
    [self.fYsPScrollView addSubview:view5];
    [self.fYsPScrollView addSubview:label5];
    UILabel *refundmoney =[[UILabel alloc]initWithFrame:CGRectMake(91, label4.bottom + 1, KscreenWidth - 100, 45)];
    refundmoney.font =[UIFont systemFontOfSize:13];
    [self.fYsPScrollView addSubview:refundmoney];
    refundmoney.text = [NSString stringWithFormat:@"%@",_model.refundmoney];
    //
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, label5.bottom + 1, 80, 45)];
    label6.text = @"实际报销";
    label6.font =[UIFont systemFontOfSize:13];
    label6.textAlignment = NSTextAlignmentLeft;
    UIView *view6 =[[UIView alloc]initWithFrame:CGRectMake(0, label6.bottom , KscreenWidth, 1)];
    view6.backgroundColor = lineColor;
    [self.fYsPScrollView addSubview:view6];
    [self.fYsPScrollView addSubview:label6];
    UILabel *realapplymon =[[UILabel alloc]initWithFrame:CGRectMake(91, label5.bottom + 1, KscreenWidth - 100, 45)];
    realapplymon.font =[UIFont systemFontOfSize:13];
    [self.fYsPScrollView addSubview:realapplymon];
    realapplymon.text = [NSString stringWithFormat:@"%@",_model.realapplymon];
    //
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, label6.bottom + 1, 80, 45)];
    label7.text = @"备注";
    label7.font =[UIFont systemFontOfSize:13];
    label7.textAlignment = NSTextAlignmentLeft;
    UIView *view7 =[[UIView alloc]initWithFrame:CGRectMake(0, label7.bottom , KscreenWidth, 1)];
    view7.backgroundColor = lineColor;
    [self.fYsPScrollView addSubview:view7];
    [self.fYsPScrollView addSubview:label7];
    UILabel *note =[[UILabel alloc]initWithFrame:CGRectMake(91, label6.bottom + 1, KscreenWidth - 100, 45)];
    note.font =[UIFont systemFontOfSize:13];
    [self.fYsPScrollView addSubview:note];
    note.text = _model.note;
}
- (void)dataRequest{
    /*
     costapply
     action:"getDetailReimBeans"
     table:"fybx"
     params:"{"idEQ":"200"}"
     */
    NSString *strAdress = @"/costapply?action=getDetailReimBeans";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"table=fybx&params={\"idEQ\":\"%@\"}",_model.Id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    if (returnStr.length != 0) {
        returnStr = [self replaceOthers:returnStr];
        if ([returnStr isEqualToString:@"sessionoutofdate"]) {
            //掉线自动登录
            [self selfLogin];
        }else{
            _array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            _count = _array.count;
            NSLog(@"费用的详情:%@",_array);
        }
    }
    
    NSLog(@"费用的详情:%@",_array);
    
}
- (void)initDetailView2{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 327, KscreenWidth, 40)];
    titleLabel.backgroundColor = COLOR(230, 230, 230, 1);
    
    titleLabel.text = @"费用详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.fYsPScrollView addSubview:titleLabel];
    _fYsPScrollView.contentSize = CGSizeMake(KscreenWidth, 370 + 190*_count);
    for (int i = 0; i< _count; i++) {
        NSDictionary *detailDic = _array[i];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 367 + 190*i , KscreenWidth, 190)];
        backView.backgroundColor = [UIColor clearColor];
        [self.fYsPScrollView addSubview:backView];
        //1
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 45)];
        label1.text = @"费用类型";
        
        label1.font =[UIFont systemFontOfSize:13];
        label1.textAlignment = NSTextAlignmentLeft;
        UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
        view1.backgroundColor = lineColor;
        [backView addSubview:view1];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 1)];
        view.backgroundColor = lineColor;
        [self.view addSubview:view];
        [backView addSubview:label1];
        UILabel * applyer = [[UILabel alloc]initWithFrame:CGRectMake(91, 0, KscreenWidth - 100, 45)];
        applyer.font =[UIFont systemFontOfSize:13];
        [backView addSubview:applyer];
        applyer.text = detailDic[@"costtype"];
        //2
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom + 1, 80, 45)];
        label2.text = @"发票张数";
        label2.font =[UIFont systemFontOfSize:13];
        label2.textAlignment = NSTextAlignmentLeft;
        UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom, KscreenWidth, 1)];
        view2.backgroundColor = lineColor;
        [backView addSubview:view2];
        [backView addSubview:label2];
        UILabel *applytime =[[UILabel alloc]initWithFrame:CGRectMake(91, label1.bottom + 1, KscreenWidth - 100, 45)];
        applytime.font =[UIFont systemFontOfSize:13];
        [backView addSubview:applytime];
        applytime.text = [NSString stringWithFormat:@"%@",detailDic[@"singelnum"]];
        //3
        UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom + 1, 80, 45)];
        label3.text = @"金额";
        label3.font =[UIFont systemFontOfSize:13];
        label3.textAlignment = NSTextAlignmentLeft;
        UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom , KscreenWidth, 1)];
        view3.backgroundColor = lineColor;
        [backView addSubview:view3];
        [backView addSubview:label3];
        UILabel *totalnum =[[UILabel alloc]initWithFrame:CGRectMake(91, label2.bottom + 1, KscreenWidth - 100, 45)];
        totalnum.font =[UIFont systemFontOfSize:13];
        [backView addSubview:totalnum];
        totalnum.text = [NSString stringWithFormat:@"%@",detailDic[@"applymon"]];
        //4
        UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom + 1, 80, 45)];
        label4.text = @"原因";
        label4.font =[UIFont systemFontOfSize:13];
        label4.textAlignment = NSTextAlignmentLeft;
        UIView *view4 =[[UIView alloc]initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 1)];
        view4.backgroundColor = lineColor;
        [backView addSubview:view4];
        [backView addSubview:label4];
        UILabel *applymoney =[[UILabel alloc]initWithFrame:CGRectMake(91, label3.bottom + 1, KscreenWidth - 100, 45)];
        applymoney.font =[UIFont systemFontOfSize:13];
        [backView addSubview:applymoney];
        applymoney.text = [NSString stringWithFormat:@"%@",detailDic[@"costcause"]];
        UIView *show = [[UIView alloc] initWithFrame:CGRectMake(0, label4.bottom , KscreenWidth, 5)];
        show.backgroundColor = COLOR(235, 235, 235, 1);
        [backView addSubview:show];
    }
    
}
#pragma mark - 审批页面

- (void)requestPifuHistory
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sp"];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =[NSString stringWithFormat:@"action=getAnswers&data={\"id\":\"%@\",\"table\":\"fybx\"}",_model.Id];
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
    _fYsPScrollView.contentSize = CGSizeMake(KscreenWidth, 410 + 190*_count +40*(pifuLishicount+2) +100);
    
        //审批
        UIView   *spView = [[UIView alloc] initWithFrame:CGRectMake(0,  365 + _count * 190, KscreenWidth, 150 + 40 * pifuLishicount)];
        spView.backgroundColor = [UIColor whiteColor];
        [self.fYsPScrollView addSubview:spView];
        
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
    if ([self.model.spnodename containsString:@"特批"]) {
        [_pifuxingshi setTitle:@"特批通过" forState:UIControlStateNormal];
    }else{
        [_pifuxingshi setTitle:@"审批通过" forState:UIControlStateNormal];
    }
    
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
    if (self.pfTabelView == nil) {
        self.pfTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120,180) style:UITableViewStylePlain];
        [self.pfTabelView setBackgroundColor:[UIColor grayColor]];
    }
    self.pfTabelView.dataSource = self;
    self.pfTabelView.delegate = self;
    [bgView addSubview:self.pfTabelView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.pfTabelView reloadData];
}

- (void)closePop
{
    [self.m_keHuPopView removeFromSuperview];
    [self.tableView removeFromSuperview];
}

- (void)pifuqueren
{
    UIAlertView *sp = [[UIAlertView alloc] initWithTitle:@"提示"
                                                 message:@"是否审批？"
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
        NSDictionary *params = @{@"action":@"doSp",@"table":@"fybx",@"data":[NSString stringWithFormat:@"{\"SPresult\":\"%zi\",\"SPcontent\":\"%@\",\"recordid\":\"%@\"}",status,_pifuneirong.text,_model.Id]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str1 = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"批复结果返回:%@",str1);
            NSString *realStr;
            if(str1.length != 0){
                realStr =  [self replaceOthers:str1];
            }
            
            [self showAlert:realStr];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newCostapply" object:self];
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
        NSDictionary *params = @{@"action":@"doSp",@"table":@"fybx",@"data":[NSString stringWithFormat:@"{\"recordid\":\"%@\",\"tpaccountid\":\"%@\",\"tpname\":\"%@\",\"SPresult\":\"%zi\",\"SPcontent\":\"%@\"}",_model.Id,_tPID,_pifurenname.titleLabel.text,status,_pifuneirong.text]};
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
    if(tableView == self.pfTabelView){
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
    if (tableView == self.pfTabelView) {
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
    NSString * str;
    if(tableView == self.pfTabelView){
        
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


@end
