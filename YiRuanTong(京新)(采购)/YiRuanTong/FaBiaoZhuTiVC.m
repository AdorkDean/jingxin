//
//  FaBiaoZhuTiVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "FaBiaoZhuTiVC.h"
#import "MBProgressHUD.h"
#import "IsNumberOrNot.h"

@interface FaBiaoZhuTiVC ()
{
    MBProgressHUD *_hud;
}

@end

@implementation FaBiaoZhuTiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发表主题";
    self.navigationItem.rightBarButtonItem = nil;
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.biaoTi.delegate = self;
    
    [self PageViewDidLoad];
    [self.view addSubview:_hud];
}
-(void)PageViewDidLoad
{   //保存按钮
    UIButton *baoCunButton = [UIButton buttonWithType:UIButtonTypeSystem];
    baoCunButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [baoCunButton setTitle:@"发表" forState:UIControlStateNormal];
    [baoCunButton addTarget:self action:@selector(fabiaoZhuti) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:baoCunButton];
    self.navigationItem.rightBarButtonItem = right;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)leiBieButtonClickMethod:(id)sender
{
    /*发表主题   类别
     http://182.92.96.58:8005/yrt/servlet/epidemicmanage
     action	getType*/
    //数据接口拼接
    NSString *strAdress = @"/epidemicmanage";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str =@"action=getType";
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray * dict8 = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
    self.m_leiBieDataArray = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i < dict8.count; i++) {
        NSString * str = dict8[i][@"name"];
        [self.m_leiBieDataArray addObject:str];
    }
    self.m_leiBiePopView = [[UIView alloc]initWithFrame:CGRectMake(60, 40,KscreenWidth-120, KscreenHeight-144)];
    self.m_leiBiePopView.backgroundColor = [UIColor grayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_m_leiBiePopView.frame.size.width - 40, 0, 40, 20);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.m_leiBiePopView addSubview:btn];
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, KscreenWidth-120, KscreenHeight-174) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor grayColor];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.m_leiBiePopView addSubview:self.tableView];
    [self.view addSubview:self.m_leiBiePopView];
    
    [self.tableView reloadData];
}

- (void)closePop
{
    [self.m_leiBiePopView removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m_leiBieDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = self.m_leiBieDataArray[indexPath.row];
    return cell;
}
//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.m_leiBiePopView removeFromSuperview];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.leiBieButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
}
- (void) textViewShouldBeginEditing:(UITextView *)textView{
    NSString *str = _neiRong.text;
    if (str.length == 0) {
        [_tiShi setHidden:NO];
    }else{
        [_tiShi setHidden:YES];
    }
}
- (void)fabiaoZhuti
{
    /*保存
     http://182.92.96.58:8005/yrt/servlet/epidemicmanage
     action	add
     data	{"content":"gggg","epidemictitle":"ghh","table":"yqgl","typeid":"146","typename":"重大疫情"}
     table	yqgl*/
    
    if (self.biaoTi.text.length == 0 || self.neiRong.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题和内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
    
     NSString *strAdress = @"/epidemicmanage";
     NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
     NSURL *url =[NSURL URLWithString:urlStr];
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
     [request setHTTPMethod:@"POST"];
     NSString *str = [NSString stringWithFormat:@"action=add&data={\"content\":\"%@\",\"epidemictitle\":\"%@\",\"table\":\"yqgl\",\"typeid\":\"146\",\"typename\":\"%@\"}&table=yqgl",self.neiRong.text,self.biaoTi.text,self.leiBieButton.titleLabel.text];
     NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
     [request setHTTPBody:data];
     NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     NSString *str1 =[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
     NSLog(@"发表主题返回%@",str1);
        
     NSRange range = {1,str1.length-2};
     NSString *reallystr = [str1 substringWithRange:range];
     if ([IsNumberOrNot isAllNum:reallystr]) {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"发表成功";
        _hud.margin = 10.f;
        _hud.yOffset = 150.f;
        [_hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [_hud removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
        }];
     }else {
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"发表失败";
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

@end
