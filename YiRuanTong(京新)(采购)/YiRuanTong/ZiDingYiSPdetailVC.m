//
//  ZiDingYiSPdetailVC.m
//  YiRuanTong
//
//  Created by lx on 15/5/18.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZiDingYiSPdetailVC.h"
#import "SPDetaillModel.h"
#import "MBProgressHUD.h"

@interface ZiDingYiSPdetailVC ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *_nameArray;
    NSMutableArray *_labelArray;
    NSString *_name;
    NSString *_sptitle;
    NSString *_typename;
    
    NSMutableArray *_detailArray;
    NSMutableArray *_dataArray;
    UIView *_detailView;
    NSArray *_shenpiNameArray;
    UIButton *_zhuangtaiBtn;
    UITextField *_pifuneirongText;
    NSInteger _statusid;
    MBProgressHUD *_hud;
    UIButton* _hide_keHuPopViewBut;
}

@end

@implementation ZiDingYiSPdetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"审批详情";
    self.navigationItem.rightBarButtonItem = nil;
    
    _nameArray = @[@"类型",@"上报人",@"审批流程",@"审批状态",@"上报时间"];
    _labelArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    
    NSString *str = @"自定义审批";
    _shenpiNameArray = @[@"审批通过",@"审批不通过"];
    _detailArray = [[NSMutableArray alloc] init];
    
    [_detailArray addObject:_model.sptypename];
    [_detailArray addObject:_model.creator];
    [_detailArray addObject:str];
    [_detailArray addObject:_model.spnodename];
    [_detailArray addObject:_model.createtime];
    
    [self dataRequest];
    [self pageload];
    _statusid = 1;
}

- (void)pageload
{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    scroller.backgroundColor = [UIColor whiteColor];
    scroller.bounces = NO;
    
    for (int i = 0; i < 5; i++) {
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 41*i, 89, 40)];
        titleLabel.backgroundColor = COLOR(231, 231, 231, 1);
        titleLabel.text = [_nameArray objectAtIndex:i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        //展示label
        UILabel *zhanshiLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 41*i, KscreenWidth-110, 40)];
        zhanshiLabel.textAlignment = NSTextAlignmentCenter;
        zhanshiLabel.font = [UIFont systemFontOfSize:15.0];
        zhanshiLabel.text = [_detailArray objectAtIndex:i];
        [_labelArray addObject:zhanshiLabel];
        //横线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,40+41*i , KscreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        
        [scroller addSubview:titleLabel];
        [scroller addSubview:zhanshiLabel];
        [scroller addSubview:line];
    }
    //展示动态信息的View
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 41*5 , KscreenWidth, 61*_dataArray.count)];
    _detailView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        SPDetaillModel *model = [_dataArray objectAtIndex:i];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,61 *i, 89, 60)];
        titleLabel.backgroundColor = COLOR(231, 231, 231, 1);
        titleLabel.text = model.name;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        //展示label
        UILabel *zhanshiLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 61*i, KscreenWidth-110, 60)];
        zhanshiLabel.textAlignment = NSTextAlignmentCenter;
        zhanshiLabel.font = [UIFont systemFontOfSize:14.0];
        zhanshiLabel.numberOfLines = 0;
        zhanshiLabel.text = model.spcontent;
        [_labelArray addObject:zhanshiLabel];
        
        //横线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,60+61*i , KscreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        [_detailView addSubview:titleLabel];
        [_detailView addSubview:zhanshiLabel];
        [_detailView addSubview:line];
    }
    //竖线
    UILabel *line1 =[[UILabel alloc] initWithFrame:CGRectMake(89, 0, 1, 41*5 + _dataArray.count*61)];
    line1.backgroundColor = [UIColor grayColor];
    [scroller addSubview:_detailView];
    [scroller addSubview:line1];
    
    //审批菜单
    //审批大标题
    UILabel *shenpi = [[UILabel alloc] initWithFrame:CGRectMake(0,41*5 + _dataArray.count*61,KscreenWidth,39)];
    shenpi.backgroundColor = [UIColor whiteColor];
    shenpi.text = @"审批";
    shenpi.textAlignment = NSTextAlignmentCenter;
    shenpi.font = [UIFont boldSystemFontOfSize:18];
    
    //线
    UILabel *line0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 41*5 + _dataArray.count*61 + 39, KscreenWidth, 1)];
    line0.backgroundColor = [UIColor grayColor];
    [scroller addSubview:line0];
    
    //下面的内容
    UILabel *pifuneirongLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, shenpi.frame.origin.y+40, 89, 40)];
    pifuneirongLabel.backgroundColor = COLOR(231, 231, 231, 1);
    pifuneirongLabel.text = @"批复内容";
    pifuneirongLabel.textAlignment = NSTextAlignmentCenter;
    pifuneirongLabel.font = [UIFont systemFontOfSize:15.0];
    //输入框
    _pifuneirongText = [[UITextField alloc] initWithFrame:CGRectMake(95, shenpi.frame.origin.y+40, KscreenWidth-95-10, 40)];
    _pifuneirongText.font = [UIFont systemFontOfSize:14.0];
    
    //横线1
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, pifuneirongLabel.frame.origin.y + 40, KscreenWidth, 1)];
    line2.backgroundColor = [UIColor grayColor];
    //批复状态
    UILabel *pifuzhuangtaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, line2.frame.origin.y+1, 89, 40)];
    pifuzhuangtaiLabel.backgroundColor = COLOR(231, 231, 231, 1);
    pifuzhuangtaiLabel.text = @"批复状态";
    pifuzhuangtaiLabel.textAlignment = NSTextAlignmentCenter;
    pifuzhuangtaiLabel.font = [UIFont systemFontOfSize:15.0];
    
    //选择按钮
    _zhuangtaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zhuangtaiBtn.backgroundColor = [UIColor whiteColor];
    _zhuangtaiBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_zhuangtaiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_zhuangtaiBtn setTitle:@"审批通过" forState:UIControlStateNormal];
    _zhuangtaiBtn.frame = CGRectMake(90, line2.frame.origin.y+1, (KscreenWidth - 90-1)/2, 40);
    [_zhuangtaiBtn addTarget:self action:@selector(pifuxingshi) forControlEvents:UIControlEventTouchUpInside];
    
    //竖线
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(89,shenpi.frame.origin.y+40 , 1, 82)];
    line3.backgroundColor = [UIColor grayColor];
    
    //小竖线
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(90+(KscreenWidth - 90-1)/2, line2.frame.origin.y+1, 1, 40)];
    line4.backgroundColor = [UIColor grayColor];
    
    //底线
    UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(0, _zhuangtaiBtn.frame.origin.y + 40, KscreenWidth, 1)];
    line5.backgroundColor = [UIColor grayColor];
    
    [scroller addSubview:line5];
    [scroller addSubview:shenpi];
    [scroller addSubview:pifuneirongLabel];
    [scroller addSubview:_pifuneirongText];
    [scroller addSubview:pifuzhuangtaiLabel];
    [scroller addSubview:_zhuangtaiBtn];
    [scroller addSubview:line2];
    [scroller addSubview:line3];
    [scroller addSubview:line4];
    
    //确认 重置
    UIButton *doBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doBtn.backgroundColor = UIColorFromRGB(0x3cbaff);
    doBtn.frame = CGRectMake(60, _zhuangtaiBtn.frame.origin.y+40+20,60,30);
    [doBtn addTarget:self action:@selector(shenpi) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chongzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongzhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongzhi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chongzhi.frame = CGRectMake(KscreenWidth - 60 - 60,_zhuangtaiBtn.frame.origin.y+40+20,60,30);
    chongzhi.backgroundColor = UIColorFromRGB(0x3cbaff);
    [chongzhi addTarget:self action:@selector(chongzhi) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:doBtn];
    [scroller addSubview:chongzhi];
    scroller.contentSize = CGSizeMake(KscreenWidth,41*5+_dataArray.count*61+41*3+10);
    [self.view addSubview:scroller];
}

- (void)shenpi
{
    if ([_zhuangtaiBtn.titleLabel.text isEqualToString:@"审批通过"]){
        _statusid = 1;
    } else if ([_zhuangtaiBtn.titleLabel.text isEqualToString:@"审批不通过"]){
        _statusid = 0;
    }
    NSString *strAdress = @"/spdefine?action=accountSp";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"data={\"id\":\"%@\",\"typeid\":\"%@\",\"spmatter\":\"%@\",\"spstatusid\":\"%zi\"}",_Id,_model.sptypeid,_pifuneirongText.text,_statusid];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"审批返回信息:%@",str1);
    
    if ([str1 isEqualToString:@"\"true\""]) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"审批成功";
        _hud.margin = 10.f;
        _hud.yOffset = 150.f;
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:1];
        
        
    } else {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"审批失败";
        _hud.margin = 10.f;
        _hud.yOffset = 150.f;
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:1];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chongzhi
{
    _pifuneirongText.text = @"";
}

- (void)dataRequest
{
    NSString *strAdress = @"/spdefine?action=getSpSelfDefineDetail";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"table=shenpizdymx&params={\"idEQ\":\"%@\"}",_Id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data1 != nil) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
        NSLog(@"审批的详情:%@",array);
        for (NSDictionary *dic in array) {
            SPDetaillModel *model = [[SPDetaillModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }

    }
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
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120,180) style:UITableViewStylePlain];
        [self.tableView setBackgroundColor:[UIColor grayColor]];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [bgView addSubview:self.tableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self.tableView reloadData];
}

- (void)closePop
{
    [self.m_keHuPopView removeFromSuperview];
    [self.tableView removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    cell.textLabel.text = [_shenpiNameArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [_shenpiNameArray objectAtIndex:indexPath.row];
    [_zhuangtaiBtn setTitle:str forState:UIControlStateNormal];
    [self.m_keHuPopView removeFromSuperview];
    [self.tableView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
