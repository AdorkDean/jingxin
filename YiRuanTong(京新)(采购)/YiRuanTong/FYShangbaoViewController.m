//
//  FYShangbaoViewController.m
//  YiRuanTong
//
//  Created by lx on 15/5/25.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FYShangbaoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "CommonModel.h"
#define lineColor COLOR(240, 240, 240, 1);


@interface FYShangbaoViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

{
    UIScrollView *_scrollerView;
    UILabel *_shangbaorenLabel;
    UILabel *_fapiaohejiLabel;
    UILabel *_jinehejiLabel;
    UILabel *_shijibaoxiaoLabel;
    UITextField *_beizhuText;
    NSArray *_nameArray;
    NSMutableArray *_labelArray;
    NSInteger _chanpinOKFlag;
    NSInteger _flag;
    NSMutableArray *_feiyongTypeArray;
    NSMutableArray *_fapiaoCountArray;
    NSMutableArray *_baoxiaoMoneyArray;
    NSMutableArray *_feiyongDescribeArray;
    NSMutableArray *_feiyongViewArray;
    
    NSInteger _totalFapiao;
    NSInteger _totalJine;
    
    NSMutableArray *_typeIdArray;
    NSMutableArray *_typeArray;
    NSArray *_array;
   
    MBProgressHUD *_hud;
    UIButton* _hide_keHuPopViewBut;
}

@end

@implementation FYShangbaoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"费用上报";
    //添加按钮
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [AddButton setTitle:@"上报" forState:UIControlStateNormal];
    [AddButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(addbaoxiao) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;
    
    _nameArray = @[@"上报人",@"发票合计",@"金额合计",@"实际报销金额",@"备注",];
    
    _labelArray = [[NSMutableArray alloc] init];
    _feiyongTypeArray = [[NSMutableArray alloc] init];
    _fapiaoCountArray = [[NSMutableArray alloc] init];
    _baoxiaoMoneyArray = [[NSMutableArray alloc] init];
    _feiyongDescribeArray = [[NSMutableArray alloc] init];
    _feiyongViewArray = [[NSMutableArray alloc] init];
    _typeIdArray = [[NSMutableArray alloc] init];
    _typeArray = [NSMutableArray array];
    
    [self pageloadView];
    [self addDetail];
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    UILabel *shangbaoLabel = [_labelArray objectAtIndex:0];
    shangbaoLabel.text = name;
    
}
#pragma mark - 主页面
- (void)pageloadView
{
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    _scrollerView.contentSize = CGSizeMake(KscreenWidth, 250);
    _scrollerView.bounces = NO;
    _scrollerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollerView];

    for (int i = 0; i < 5; i++) {
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 46*i, 89, 45)];
        titleLabel.text = [_nameArray objectAtIndex:i];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        //展示label
        if (i != 4) {
            UILabel *zhanshiLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 46*i, KscreenWidth-110, 45)];
            zhanshiLabel.textAlignment = NSTextAlignmentLeft;
            zhanshiLabel.textColor = [UIColor grayColor];
            zhanshiLabel.font = [UIFont systemFontOfSize:14.0];
            [_labelArray addObject:zhanshiLabel];
            [_scrollerView addSubview:zhanshiLabel];
        } else if (i == 4) {
            _beizhuText = [[UITextField alloc] initWithFrame:CGRectMake(95, 46*4, KscreenWidth - 110, 45)];
            _beizhuText.font = [UIFont systemFontOfSize:14];
        }
        //横线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,45 + 46*i , KscreenWidth, 1)];
        line.backgroundColor = lineColor;
        [_scrollerView addSubview:_beizhuText];
        [_scrollerView addSubview:titleLabel];
        [_scrollerView addSubview:line];
    }
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, _beizhuText.bottom, KscreenWidth, 45)];
    view1.backgroundColor = COLOR(230, 230, 230, 1);
    [_scrollerView addSubview:view1];
    UIButton *tianJiaButton = [[UIButton alloc] initWithFrame:CGRectMake(KscreenWidth - 100, 0, 100, 45)];
    [tianJiaButton setTitle:@"添加详情" forState:UIControlStateNormal];
    [tianJiaButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [tianJiaButton addTarget:self action:@selector(addDetail) forControlEvents:UIControlEventTouchUpInside];
    tianJiaButton.titleLabel.font = [ UIFont systemFontOfSize:16];
    [view1 addSubview:tianJiaButton];
}
#pragma mark - 详情页面
- (void)addDetail
{
    _chanpinOKFlag = 1;
    _flag = _flag + 1;
    _scrollerView.contentSize = CGSizeMake(KscreenWidth, 231 + 224 * _flag + 60);
    UIView *chanpinView = [[UIView alloc] initWithFrame:CGRectMake(0, 231 + (_flag-1) * 224, KscreenWidth,269 )];
    chanpinView.backgroundColor = [UIColor whiteColor];
    
    UILabel *chanPinXinXi = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 39)];
    chanPinXinXi.text = @"费用详情";
    chanPinXinXi.backgroundColor = COLOR(230, 230, 230, 1);
    chanPinXinXi.textColor = [UIColor blackColor];
    chanPinXinXi.font = [UIFont systemFontOfSize:16];
    chanPinXinXi.textAlignment = NSTextAlignmentCenter;
    [chanpinView addSubview:chanPinXinXi];
    if (_flag > 1) {
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(KscreenWidth - 40, 0, 40, 30);
        [cancel setTitle:@"删除" forState:UIControlStateNormal];
        cancel.backgroundColor = COLOR(230, 230, 230, 1);
        [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(closeFeiyongView) forControlEvents:UIControlEventTouchUpInside];
        [chanpinView addSubview:cancel];
    }
   
    
    UILabel *line0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, KscreenWidth, 1)];
    line0.backgroundColor = lineColor;
    [chanpinView addSubview:line0];
    
    //费用类型
    UILabel *chanPinName = [[UILabel alloc] initWithFrame:CGRectMake(10,line0.bottom + 1, 80, 45)];
    chanPinName.text = @"费用类型";
    chanPinName.font = [UIFont systemFontOfSize:13];
    chanPinName.textAlignment = NSTextAlignmentLeft;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, chanPinName.bottom, KscreenWidth, 1)];
    line1.backgroundColor = lineColor;
    [chanpinView addSubview:chanPinName];
    [chanpinView addSubview:line1];
    
    UIButton *CPNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(91, line0.bottom + 1, KscreenWidth - 100, 45)];
    CPNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [CPNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CPNameBtn.backgroundColor = [UIColor whiteColor];
    CPNameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [CPNameBtn addTarget:self action:@selector(feiyongleixingMethod) forControlEvents:UIControlEventTouchUpInside];
    [chanpinView addSubview:CPNameBtn];
    [_feiyongTypeArray addObject:CPNameBtn];
     UILabel *faPiaoTypeId = [[UILabel alloc] initWithFrame:CGRectMake(10, CPNameBtn.bottom + 1, 80, 45)];
    [_typeIdArray addObject:faPiaoTypeId];
    
    //发票数量
    UILabel *faHuoDanHao = [[UILabel alloc] initWithFrame:CGRectMake(10, chanPinName.bottom + 1, 80, 45)];
    faHuoDanHao.text = @"发票数量";
    faHuoDanHao.font = [UIFont systemFontOfSize:13];
    faHuoDanHao.textAlignment = NSTextAlignmentLeft;
    UIView *line2 =[[UIView alloc] initWithFrame:CGRectMake(0,faHuoDanHao.bottom , KscreenWidth, 1)];
    line2.backgroundColor = lineColor;
    [chanpinView addSubview:line2];
    [chanpinView addSubview:faHuoDanHao];
    
    UITextField *fapiaoCountText = [[UITextField alloc] initWithFrame:CGRectMake(91, chanPinName.bottom + 1, KscreenWidth - 100, 45)];
    fapiaoCountText.font = [UIFont systemFontOfSize:13];
    fapiaoCountText.delegate = self;
    fapiaoCountText.tag = 1*_flag;
    fapiaoCountText.placeholder = @"请输入数字";
    fapiaoCountText.keyboardType = UIKeyboardTypeNumberPad;
    [chanpinView addSubview:fapiaoCountText];
    [_fapiaoCountArray addObject:fapiaoCountText];
    
    //报销金额
    UILabel *chanPinGuiGe = [[UILabel alloc] initWithFrame:CGRectMake(10, faHuoDanHao.bottom + 1, 80, 45)];
    chanPinGuiGe.text = @"报销金额";
    chanPinGuiGe.font = [UIFont systemFontOfSize:13];
    chanPinGuiGe.textAlignment = NSTextAlignmentLeft;
    UIView *line3 =[[UIView alloc] initWithFrame:CGRectMake(0, chanPinGuiGe.bottom , KscreenWidth, 1)];
    line3.backgroundColor = lineColor;
    [chanpinView addSubview:line3];
    [chanpinView addSubview:chanPinGuiGe];
    
    UITextField *baoxiaoJine = [[UITextField alloc] initWithFrame:CGRectMake(91, faHuoDanHao.bottom + 1, KscreenWidth - 100, 45)];
    baoxiaoJine.font = [UIFont systemFontOfSize:13];
    baoxiaoJine.delegate = self;
    baoxiaoJine.tag = 2*_flag;
    baoxiaoJine.keyboardType = UIKeyboardTypeNumberPad;
    baoxiaoJine.placeholder = @"请输入数字";
    [chanpinView addSubview:baoxiaoJine];
    
    [_baoxiaoMoneyArray addObject:baoxiaoJine];
    
    //费用描述
    UILabel *chanPinDanWei = [[UILabel alloc] initWithFrame:CGRectMake(10, chanPinGuiGe.bottom + 1, 80, 45)];
    chanPinDanWei.text = @"费用描述";
    chanPinDanWei.font = [UIFont systemFontOfSize:13];
    chanPinDanWei.textAlignment = NSTextAlignmentLeft;
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, chanPinDanWei.bottom , KscreenWidth, 1)];
    line4.backgroundColor = lineColor;
    [chanpinView addSubview:line4];
    [chanpinView addSubview:chanPinDanWei];
    
    UITextField *feiyongmiaoshu = [[UITextField alloc] initWithFrame:CGRectMake(91, chanPinGuiGe.bottom + 1, KscreenWidth - 100, 45)];
    feiyongmiaoshu.font = [UIFont systemFontOfSize:13];
    [chanpinView addSubview:feiyongmiaoshu];
    [_feiyongDescribeArray addObject:feiyongmiaoshu];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, chanPinDanWei.bottom, KscreenWidth, 45)];
    view1.backgroundColor = COLOR(230, 230, 230, 1);
    [chanpinView addSubview:view1];
    //添加产品
    UIButton *tianJiaButton = [[UIButton alloc] initWithFrame:CGRectMake(KscreenWidth-100, 0, 100, 40)];
    [tianJiaButton setTitle:@"添加详情" forState:UIControlStateNormal];
    [tianJiaButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [tianJiaButton addTarget:self action:@selector(addDetail) forControlEvents:UIControlEventTouchUpInside];
    tianJiaButton.titleLabel.font = [ UIFont systemFontOfSize:16];
    [view1 addSubview:tianJiaButton];
    
    [_scrollerView addSubview:chanpinView];
    [_feiyongViewArray addObject:chanpinView];
}

- (void)feiyongleixingMethod
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
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(60, 40, KscreenWidth - 120, KscreenHeight - 144)];
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
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth - 120, KscreenHeight - 174) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor grayColor];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [bgView addSubview:self.tableView];
//    [self.view addSubview:self.m_keHuPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.m_keHuPopView];
    [self typeRequest];
}

- (void)closePop{
    
    [self.m_keHuPopView removeFromSuperview];
}

- (void)typeRequest
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/sysbase?action=getSelectType&type=costtype"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    
    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_typeArray removeAllObjects];
        NSArray *array = (NSArray *)responseObject;
        NSLog(@"报销费用类型输出:%@",array);
        for (NSDictionary *dic in array) {
            CommonModel *model = [[CommonModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_typeArray addObject:model];
           
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}

- (void)closeFeiyongView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除本条信息吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            
            UITextField *text1 = [_fapiaoCountArray objectAtIndex:_flag - 1];
            _totalFapiao -= [text1.text integerValue];
            
            UITextField *text2 = [_baoxiaoMoneyArray objectAtIndex:_flag - 1];
            _totalJine -= [text2.text integerValue];
            
            UILabel *zongshuliang = [_labelArray objectAtIndex:1];
            zongshuliang.text = [NSString stringWithFormat:@"%zi",_totalFapiao];
            
            UILabel *zongjine = [_labelArray objectAtIndex:2];
            zongjine.text = [NSString stringWithFormat:@"%zi",_totalJine];
            
            UILabel *shijijine = [_labelArray objectAtIndex:3];
            shijijine.text = [NSString stringWithFormat:@"%zi",_totalJine];
            
            [_feiyongTypeArray removeObjectAtIndex:_flag - 1];
            [_fapiaoCountArray removeObjectAtIndex:_flag - 1];
            [_baoxiaoMoneyArray removeObjectAtIndex:_flag - 1];
            [_feiyongDescribeArray removeObjectAtIndex:_flag - 1];
            [_typeIdArray removeObjectAtIndex:_flag - 1];
            UIView *view = [_feiyongViewArray objectAtIndex:_flag - 1];
            [view removeFromSuperview];
            [_feiyongViewArray removeObjectAtIndex:_flag - 1];
            _scrollerView.contentSize = CGSizeMake(KscreenWidth, _scrollerView.contentSize.height - 210);
            _flag -= 1;
        }
    }else if (alertView.tag == 1001){
        if (buttonIndex == 1) {
            [self shangBao];
        }
    
    }

}
    
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1 * _flag) {
        _totalFapiao -= [textField.text integerValue];
    } else if (textField.tag == 2 * _flag){
        _totalJine -= [textField.text integerValue];
    }
    
    if (_totalFapiao < 0) {
        _totalFapiao = 0;
    }
    
    if (_totalJine < 0) {
        _totalJine = 0;
    }
    
    UILabel *zongshuliang = [_labelArray objectAtIndex:1];
    zongshuliang.text = [NSString stringWithFormat:@"%zi",_totalFapiao];
    
    UILabel *zongjine = [_labelArray objectAtIndex:2];
    zongjine.text = [NSString stringWithFormat:@"%zi",_totalJine];
    
    UILabel *shijijine = [_labelArray objectAtIndex:3];
    shijijine.text = [NSString stringWithFormat:@"%zi",_totalJine];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1*_flag) {
        
        _totalFapiao += [textField.text integerValue];
        
    } else if (textField.tag == 2*_flag){
        
        _totalJine += [textField.text integerValue];
    }
        
    UILabel *zongshuliang = [_labelArray objectAtIndex:1];
    zongshuliang.text = [NSString stringWithFormat:@"%zi",_totalFapiao];
    
    UILabel *zongjine = [_labelArray objectAtIndex:2];
    zongjine.text = [NSString stringWithFormat:@"%zi",_totalJine];
    
    UILabel *shijijine = [_labelArray objectAtIndex:3];
    shijijine.text = [NSString stringWithFormat:@"%zi",_totalJine];
}
#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
       
    }
    if (_typeArray.count != 0) {
        CommonModel *model = _typeArray[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
    return cell;
}

//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    CommonModel *model = _typeArray[indexPath.row];
    UIButton *btn = [_feiyongTypeArray objectAtIndex:_flag - 1];
    [btn setTitle:model.name forState:UIControlStateNormal];
    UILabel *typeId = [_typeIdArray objectAtIndex:_flag - 1];
    typeId.text = [NSString stringWithFormat:@"%@",model.Id];
    [self.m_keHuPopView removeFromSuperview];
}


- (void)addbaoxiao
{
    /*
     data:"{"table":"fybx","applyer":"胡云龙","applyerid":"168","refundids":"","refundmoney":"","totalnum":"12","applymoney":"1477572","note":"wwwwwww","fybxmxList":[{"table":"cost_reimbursement_apply_detail","costtypeid":"152","costtype":"宴请","singelnum":"12","singlemoney":"123131","costcause":"22"}]}"
     
     data:"{"table":"fybx","applyer":"胡云龙","applyerid":"168","refundids":"","refundmoney":"","totalnum":"13","applymoney":"466","note":"","fybxmxList":[{"table":"cost_reimbursement_apply_detail","costtypeid":"151","costtype":"住宿","singelnum":"11","singlemoney":"2","costcause":""},{"table":"cost_reimbursement_apply_detail","costtypeid":"151","costtype":"住宿","singelnum":"2","singlemoney":"222","costcause":""}]}"
     */
    if ( _flag == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加费用详情!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        for (int i = 0; i < _flag; i++) {
            
            UIButton *feiyongleixing = [_feiyongTypeArray objectAtIndex:i];
            UITextField *fapiaoCount = [_fapiaoCountArray objectAtIndex:i];
            UITextField *jineCount = [_baoxiaoMoneyArray objectAtIndex:i];
            NSString *type = feiyongleixing.titleLabel.text;
            NSString *count = fapiaoCount.text;
            NSString *money = jineCount.text;
            if (type.length == 0 || count.length == 0 || money.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"类型、数量、金额能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否添加此申请?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 1001;
                [alert show];
                
            }
        }
        
    }
}


- (void)shangBao{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/costapply?action=addReim&table=fybx&SP=true"];
    NSURL *url =[NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    UILabel *shangaboren = [_labelArray objectAtIndex:0];
    UILabel *fapiaoheji = [_labelArray objectAtIndex:1];
    UILabel *jineheji = [_labelArray objectAtIndex:2];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *IDStr = [userDefault objectForKey:@"id"];
    NSMutableString *cpStr = [NSMutableString stringWithFormat:@"data={\"applyerid\":\"%@\",\"applyer\":\"%@\",\"totalnum\":\"%@\",\"applymoney\":\"%@\",\"refundids\":\"\",\"refundmoney\":0,\"table\":\"fybx\",\"note\":\"\",}",IDStr,shangaboren.text,fapiaoheji.text,jineheji.text];
    
    NSMutableString *chanpinStr = [NSMutableString stringWithFormat:@"\"fybxmxList\":[]"];
    
    for (int i = 0; i < _flag; i++) {
        
        UIButton *feiyongleixing = [_feiyongTypeArray objectAtIndex:i];
        UITextField *fapiaoCount = [_fapiaoCountArray objectAtIndex:i];
        UITextField *jineCount = [_baoxiaoMoneyArray objectAtIndex:i];
        UITextField *miaoshu = [_feiyongDescribeArray objectAtIndex:i];
        UILabel *IdLabel = [_typeIdArray objectAtIndex:i];
        
        [chanpinStr insertString:[NSString stringWithFormat:@"{\"table\":\"cost_reimbursement_apply_detail\",\"costtypeid\":\"%@\",\"costtype\":\"%@\",\"singelnum\":\"%@\",\"applyMon\":\"%@\",\"costcause\":\"%@\"},",IdLabel.text,feiyongleixing.titleLabel.text,fapiaoCount.text,jineCount.text,miaoshu.text] atIndex:chanpinStr.length - 1];
    }
    
    [chanpinStr deleteCharactersInRange:NSMakeRange(chanpinStr.length - 2, 1)];
    
    [cpStr insertString:[NSString stringWithFormat:@"%@",chanpinStr] atIndex:cpStr.length-1];
    
    NSLog(@"添加费用字符串:%@",cpStr);
    
    NSData *data = [cpStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"添加费用返回字符串:%@",str1);
    if (str1.length != 0) {
        NSRange range = {1,str1.length-2};
        NSString *reallystr = [str1 substringWithRange:range];
        if ([reallystr isEqualToString:@"true"]) {
        
            [self showAlert:@"添加成功!"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newCostapply" object:nil];
        } else {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"添加失败";
            _hud.margin = 10.f;
            _hud.yOffset = 150.f;
            [_hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_hud removeFromSuperview];
            }];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
