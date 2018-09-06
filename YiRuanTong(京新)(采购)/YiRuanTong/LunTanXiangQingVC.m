//
//  LunTanXiangQingVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "LunTanXiangQingVC.h"
#import "LTReplyModel.h"
#import "LTReplyCell.h"
#import "MBProgressHUD.h"

@interface LunTanXiangQingVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    UITableView *_replyTableView;
    NSMutableArray *_dataArray;
    UITextField *_replyText;
    UIView *_replyView;
    MBProgressHUD *_hud;
}

@end

@implementation LunTanXiangQingVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    self.title = @"详情";
    self.navigationItem.rightBarButtonItem = nil;
    
    self.biaoTi.text = _model.epidemictitle;
    self.faBuRen.text = _model.publisher;
    self.faBuTime.text = _model.publishtime;
    self.leiXing.text = _model.Typename;
    self.neiRong.text = _model.content;
    
    _replyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 164, KscreenWidth, KscreenHeight-64-164-50) style:UITableViewStylePlain];
    _replyTableView.delegate = self;
    _replyTableView.dataSource = self;
    _replyTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_replyTableView];
    
    _replyView = [[UIView alloc] initWithFrame:CGRectMake(0, KscreenHeight-114, KscreenWidth, 50)];
    
    _replyView.backgroundColor = [UIColor whiteColor];
    _replyView.tag = 100;
    
    _replyText = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, KscreenWidth/4*3, 40)];
    _replyText.placeholder = @"我来说几句";
    _replyText.delegate = self;
    _replyText.borderStyle = UITextBorderStyleRoundedRect;
    _replyText.backgroundColor = [UIColor whiteColor];
    
    [_replyView addSubview:_replyText];
    
    UIButton *reply = [UIButton buttonWithType:UIButtonTypeCustom];
    reply.layer.cornerRadius = 10;
    reply.frame = CGRectMake(KscreenWidth/4*3+15, 7, KscreenWidth/4-20, 35);
    reply.backgroundColor = COLOR(98, 198, 248, 1);
    
    [reply setTitle:@"评论" forState:UIControlStateNormal];
    [reply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [reply addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
    
    [_replyView addSubview:reply];
    
    [self.view addSubview:_replyView];
    
    [self DataRequest];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘高度
    NSValue *keyboardObject = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:0.3];
    
    //设置view的frame，往上平移
    [(UIView *)[self.view viewWithTag:100] setFrame:CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height - 50, KscreenWidth,50)];
    
    [UIView commitAnimations];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    //设置view的frame，往下平移
    [(UIView *)[self.view viewWithTag:100] setFrame:CGRectMake(0, self.view.frame.size.height-50, KscreenWidth, 50)];
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)reply
{
    //http://182.92.96.58:8005/yrt/servlet/epidemicmanage
    //action	addReply
    //data	{"epidemictitle":"～…","epidemicid":"211","replyContent":"eed"}
    NSString *str = _replyText.text;
    if (str.length != 0) {
        NSString *strAdress = @"/epidemicmanage";
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
        
        NSURL *url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str = [NSString stringWithFormat:@"action=addReply&data={\"epidemictitle\":\"%@\",\"epidemicid\":\"%@\",\"replyContent\":\"%@\"}",_model.epidemictitle,_model.Id,_replyText.text];
        
        NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data2 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 =[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
        
        NSLog(@"回复返回信息:%@",str1);
        
        NSRange range = {1,str1.length-2};
        NSString *reallystr = [str1 substringWithRange:range];
        if ([reallystr isEqualToString:@"true"]) {
            [_dataArray removeAllObjects];
            
            [self DataRequest];
            
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"评论成功";
            _hud.margin = 10.f;
            _hud.yOffset = 150.f;
            _hud.removeFromSuperViewOnHide = YES;
            [_hud hide:YES afterDelay:1];
            
        }else{
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"评论失败";
            _hud.margin = 10.f;
            _hud.yOffset = 150.f;
            _hud.removeFromSuperViewOnHide = YES;
            [_hud hide:YES afterDelay:1];
        }
        _replyText.text = @"";

    }else if(str.length == 0){
        UIAlertView *tan = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tan show];
    }
    
}

- (void)DataRequest
{
    /*回复列表
     http://182.92.96.58:8005/yrt/servlet/epidemicmanage
     action	getReplysByEpId
     params	{"idEQ":"211"}*/
    //数据接口拼接
    NSString *strAdress = @"/epidemicmanage";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"action=getReplysByEpId&params={\"idEQ\":\"%@\"}",_model.Id];
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
   
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    
    if (array.count == 0) {
        
        _replyTableView.hidden = YES;
        
    } else if (array.count != 0){
        
        _replyTableView.hidden = NO;
        
        for (NSDictionary *dic in array) {
            LTReplyModel *model = [[LTReplyModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        
        [_replyTableView reloadData];
        
        NSLog(@"回复列表:%@",array);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    LTReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = (LTReplyCell *)[[[NSBundle mainBundle] loadNibNamed:@"LTReplyCell" owner:nil options:nil] firstObject];
    }
    
    if (_dataArray.count != 0) {
        LTReplyModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.name.text = model.replyer;
        cell.content.text = model.replycontent;
        cell.time.text = model.replytime;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
