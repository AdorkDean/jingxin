//
//  ShangBaoVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ShangBaoVC.h"

#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "IsNumberOrNot.h"
#import "RZInfoModel.h"


@interface ShangBaoVC ()<UITextViewDelegate>
{
    MBProgressHUD *_hud;
    UIButton *_leiXingBtn;
    NSMutableArray *_dataArray;
    UIView *_detailView;
    UILabel *_fujianLabel;
    UILabel *_line1;
    UILabel *_shuxian;
    NSMutableArray *_textFieldArray;
    NSMutableArray *_titleArray;
    NSMutableArray *_countLimitArray;
    NSInteger _flag;
    NSString *_firstNmae;
    UIScrollView *_rzScrollView;
    
    UIButton *_hide_keHuPopViewBut;
}

@property(strong,nonatomic) NSMutableArray *arr;

@end

@implementation ShangBaoVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"日志上报";
    self.view.backgroundColor = [UIColor whiteColor];
    //GCD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self typeRequest];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self PageViewDidLoad];
            [self loadfirstView];
            [self loadPageView];
            [self loadDetailView];
        });
    });
    
    
}
#pragma mark - 日志类型默认
- (void)loadfirstView
{
    
    
    
    //日志类型接口
    NSString *strAdress = @"/dailyreport";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getTypeComBox";
    
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
            NSArray *dict8 =[NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            NSLog(@"日志类型输出:%@",dict8);
            if (dict8.count != 0) {
                NSDictionary *dic = dict8[0];
                
                _nameID = [dic[@"id"] integerValue];
                
                _firstNmae = [NSString stringWithFormat:@"%@",dic[@"name"]];
                
            }
        }
    }

//    if (data1 != nil) {
//        NSArray *dict8 =[NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
//        NSLog(@"日志类型输出:%@",dict8);
//        if (dict8.count != 0) {
//            NSDictionary *dic = dict8[0];
//            
//            _nameID = [dic[@"id"] integerValue];
//            
//            _firstNmae = [NSString stringWithFormat:@"%@",dic[@"name"]];
//
//        }
//    }
   
}

- (void)loadPageView
{
    
    _rzScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _rzScrollView.delegate = self;
   
    _rzScrollView.bounces = NO;
    [self.view addSubview:_rzScrollView];
    
    UILabel *leixingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 89, 45)];
    leixingLabel.backgroundColor = COLOR(231, 231, 231, 1);
    leixingLabel.text = @"类型";
    leixingLabel.textAlignment = NSTextAlignmentCenter;
    leixingLabel.font = [UIFont systemFontOfSize:16.0];
    
    _leiXingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leiXingBtn.frame = CGRectMake(95, 2, KscreenWidth - 100, 40);
    _leiXingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leiXingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _leiXingBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_leiXingBtn setTitle:_firstNmae forState:UIControlStateNormal];
    [_leiXingBtn addTarget:self action:@selector(m_leiXingButtonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    UILabel *line0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, KscreenWidth, 1)];
    line0.backgroundColor = [UIColor grayColor];
    [_rzScrollView addSubview:leixingLabel];
    [_rzScrollView addSubview:_leiXingBtn];
    [_rzScrollView addSubview:line0];
}

- (void)loadDetailView
{
    [self DataRequest];
     _rzScrollView.contentSize = CGSizeMake(0, 46 + _dataArray.count * 91 + 40);
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, KscreenWidth, 46+_dataArray.count * 91)];
    _detailView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < _dataArray.count; i++) {
        
        RZInfoModel *model = [_dataArray objectAtIndex:i];
        //类型的具体标题 （比如日志的明日计划和今日总结）
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 91*i, 89, 90)];
        titleLabel.backgroundColor = COLOR(231, 231, 231, 1);
        titleLabel.text = model.name;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_titleArray addObject:titleLabel];
        //画线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 91*(i +1)-1, KscreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        //后面的输入框
        UITextView *contentText = [[UITextView alloc] initWithFrame:CGRectMake(95, 5 + 91 * i, KscreenWidth - 95 - 10, 70)];
        contentText.tag = i;
        contentText.delegate = self;
        contentText.font = [UIFont systemFontOfSize:13.0];
        [_textFieldArray addObject:contentText];
        
        //字数显示框
        UILabel *countlabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth - 120, 73 + 91*i, 115, 15)];
        countlabel.backgroundColor = [UIColor whiteColor];
        countlabel.textAlignment = NSTextAlignmentCenter;
        countlabel.textColor = [UIColor lightGrayColor];
        countlabel.text = [NSString stringWithFormat:@"最少%@字 0/%@",model.minlength,model.maxlength];
        countlabel.font = [UIFont systemFontOfSize:12.0];
        [_countLimitArray addObject:countlabel];
        
        [_detailView addSubview:titleLabel];
        [_detailView addSubview:line];
        [_detailView addSubview:contentText];
        [_detailView addSubview:countlabel];
    }
    [_rzScrollView addSubview:_detailView];
    //附件
    _fujianLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 137+91*(_dataArray.count-1), 89, 45)];
    _fujianLabel.backgroundColor = COLOR(231, 231, 231, 1);
    _fujianLabel.text = @"附件";
    _fujianLabel.textAlignment = NSTextAlignmentCenter;
    _fujianLabel.font = [UIFont systemFontOfSize:16.0];
    //最下面的那条线
    _line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 137 + 91 * (_dataArray.count-1) + 45, KscreenWidth, 1)];
    _line1.backgroundColor = [UIColor grayColor];
    //竖线
    _shuxian = [[UILabel alloc] initWithFrame:CGRectMake(89, 0, 1, _fujianLabel.frame.origin.y-1)];
    _shuxian.backgroundColor = [UIColor grayColor];
    
    [_rzScrollView addSubview:_shuxian];
    //[self.view addSubview:_fujianLabel];
    //[self.view addSubview:_line1];
}

- (void)textViewDidChange:(UITextView *)textView
{
    for (int i = 0; i < _dataArray.count; i++) {
        if (textView.tag == i) {
            
            RZInfoModel *model = [_dataArray objectAtIndex:i];
            UILabel *label = [_countLimitArray objectAtIndex:i];
            label.text = [NSString stringWithFormat:@"最少%@字 %zi/%@",model.minlength,textView.text.length,model.maxlength];
            NSInteger count = [model.maxlength integerValue];
            if (textView.text.length == count) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数已达最多" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}
#pragma mark - 日志类型详情加载
- (void)DataRequest
{
    /*
     类型详情
     http://182.92.96.58:8005/yrt/servlet/dailyreport
     action	getTypeDetail
     params	{"idEQ":"26"}  id=73
     */
    //类型详情接口   解析good；
    
    _dataArray = [[NSMutableArray alloc] init];
    _textFieldArray = [[NSMutableArray alloc] init];
    _titleArray = [[NSMutableArray alloc] init];
    _countLimitArray = [[NSMutableArray alloc] init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSString *str = [NSString stringWithFormat: @"action=getTypeDetail&params={\"idEQ\":\"%zi\"}",self.nameID];

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
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"类型数组:%@",array);
            
            for (NSDictionary *dic in array) {
                RZInfoModel *model = [[RZInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }

        }
    }

}

- (void)PageViewDidLoad
{
    //添加按钮
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(KscreenWidth - 45, 5, 40, 40);
    [AddButton setTitle:@"提交" forState:UIControlStateNormal];
    [AddButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(riBao) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:AddButton];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark 日志类型点击

- (void)m_leiXingButtonClickMethod
{
    /*
     日志类型
     http://182.92.96.58:8005/yrt/servlet/dailyreport
     action	getTypeComBox
     */
    //日志类型接口
    _leiXingBtn.userInteractionEnabled = NO;
    
    
    self.leiXingPopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,KscreenWidth, KscreenHeight)];
    self.leiXingPopView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //
    _hide_keHuPopViewBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    [_hide_keHuPopViewBut addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.leiXingPopView addSubview:_hide_keHuPopViewBut];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.leiXingPopView];
    
    UIView *grayview = [[UIView alloc]initWithFrame:CGRectMake(60, 74, KscreenWidth-120, 30)];
    grayview.backgroundColor = UIColorFromRGB(0x999999);
    [self.leiXingPopView addSubview:grayview];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.frame = CGRectMake(_leiXingPopView.frame.size.width - 100, 74, 40, 30);
    [btn addTarget:self action:@selector(closePop) forControlEvents:UIControlEventTouchUpInside];
    [self.leiXingPopView addSubview:btn];

    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 30+74, KscreenWidth-120, KscreenHeight-174 - 150)style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.leiXingPopView addSubview:self.tableView];
}
- (void)closePop{
    
    [self.leiXingPopView removeFromSuperview];
    _leiXingBtn.userInteractionEnabled = YES;
    [_hide_keHuPopViewBut removeFromSuperview];

}
#pragma mark - 日志类型加载方法
- (void)typeRequest{

    NSString *strAdress = @"/dailyreport";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"action=getTypeComBox";
    
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
            NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
            NSLog(@"日志类型输出:%@",array);
            self.leiXingDataArray = array;
            self.arr = [NSMutableArray  array];
            for (int i = 0; i< array.count; i++) {
                NSString *str12 = array[i][@"name"];
                [self.arr addObject:str12];
            }
        }
    }

    
//    if (data1 != nil) {
//        NSArray *array =[NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
//        NSLog(@"日志类型输出:%@",array);
//        self.leiXingDataArray = array;
//        self.arr = [NSMutableArray  array];
//        for (int i = 0; i< array.count; i++) {
//            NSString *str12 = array[i][@"name"];
//            [self.arr addObject:str12];
//        }
//        
//    }
//

}

#pragma mark -TableviewDatasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        //cell.backgroundColor = [UIColor grayColor];
    }
    NSDictionary * dict = self.leiXingDataArray[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    return cell;
}

//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_leiXingBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
        NSDictionary * dict = self.leiXingDataArray[indexPath.row];
        self.nameID = [dict[@"id"] intValue];
        [_detailView removeFromSuperview];
        [_fujianLabel removeFromSuperview];
        [_line1 removeFromSuperview];
        [_shuxian removeFromSuperview];
    _leiXingBtn.userInteractionEnabled = YES;
        [self loadDetailView];
        [self.leiXingPopView removeFromSuperview];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (void)riBao
{
    
        /*上报日志（上报）
         http://182.92.96.58:8005/yrt/servlet/dailyreport
         mobile	true
         action	addReprt
         data	{"reporttypename":"年度总结汇报","rbmxList":[],"reporttypeid":"34","table":"rzsb"}
         table	rzsb   */
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/dailyreport"];
        
        NSURL *url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
    
      NSMutableString *str = [NSMutableString stringWithFormat:@"mobile=true&action=addReprt&data={\"reporttypename\":\"%@\",\"reporttypeid\":\"%zi\",\"table\":\"rzsb\",\"rbmxList\":[]}",_leiXingBtn.titleLabel.text,_nameID];
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        UILabel *titleLabel = [_titleArray objectAtIndex:i];
        UITextView *textView = [_textFieldArray objectAtIndex:i];
        RZInfoModel *model = [_dataArray objectAtIndex:i];
        
        NSString *contentStr = textView.text;
        contentStr = [self replace:contentStr];
        
        NSInteger length = [model.minlength integerValue];
        
        if (contentStr.length < length) {
            _flag = 1;
        } else {
            
            _flag = 0;
            [str insertString:[NSString stringWithFormat:@"{\"table\":\"rbmx\",\"reporttitleid\":\"%@\",\"reporttitle\":\"%@\",\"reportcontent\":\"%@\"},",model.Id,titleLabel.text,contentStr] atIndex:str.length-2];
        }
    }
    
    if (_flag == 0) {
        
        [str deleteCharactersInRange:NSMakeRange(str.length - 3, 1)];
        
        NSLog(@"日志上传字符串:%@",str);
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
        NSLog(@"日志上报返回信息:%@",str1);
        if (str1.length != 0) {
            NSRange range = {1,str1.length-2};
            NSString *reallystr = [str1 substringWithRange:range];
            if ([IsNumberOrNot isAllNum:reallystr]) {
                
                [self showAlert:@"上报成功!"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newDailyreport" object:self];
                
            } else {
                [self showAlert:reallystr];
            }

        }
        
    } else if (_flag == 1){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字数不够" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSString *)replace:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    return returnString;
}


@end
