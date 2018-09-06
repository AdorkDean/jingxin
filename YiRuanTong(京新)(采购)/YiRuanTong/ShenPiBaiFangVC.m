//
//  ShenPiBaiFangVC.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ShenPiBaiFangVC.h"
#import "ZhaoPianShangChuanVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "ReplyListCell.h"
#import "UIViewExt.h"
#import "DataPost.h"
#import "CustHistoryViewController.h"
@interface ShenPiBaiFangVC ()
{
    UITableView *_replyList;
    NSMutableArray *_allDataArray;
    MBProgressHUD *_hud;
    UIView *_moreView;
}


@end

@implementation ShenPiBaiFangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拜访详情";
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(KscreenWidth - 45, 5, 60, 40);
    [button setTitle:@"历史" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(zaiBaiFang) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;
    
    
    self.piFuNeiRong.delegate = self;
    _replyList = [[UITableView alloc] initWithFrame:CGRectMake(0,310, KscreenWidth, KscreenHeight-374) style:UITableViewStylePlain];
    _replyList.delegate = self;
    _replyList.dataSource = self;
    _replyList.separatorStyle = NO;

    [self.view addSubview:_replyList];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self requestReply];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self initView];
//            
//        });
//    });
    
    [self initView];
    [self requestReply];

    [self.view addSubview:_hud];
}
-(void)initView
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, KscreenWidth - 130, 40)];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:nameLabel];
    //saler
    UIButton *salerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    salerButton.frame = CGRectMake(15, nameLabel.bottom + 5, KscreenWidth - 30, 20);
    salerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [salerButton setTintColor:[UIColor blackColor]];
    salerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [salerButton addTarget:self action:@selector(showMoreView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:salerButton];

    //purpose
    UILabel *purpose = [[UILabel alloc] initWithFrame:CGRectMake(15, salerButton.bottom + 5, KscreenWidth - 30, 40)];
    purpose.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:purpose];
    //detail
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(15, purpose.bottom + 5, KscreenWidth - 30, 60)];
    detail.numberOfLines = 0;
    detail.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:detail];
    
    
    
    
    
    NSString *saler = _model.visitor;
    if (saler.length == 0) {
        saler = @"业务员未知";
    }
    NSString *str = _model.visitedate;
    NSString * realdate;
    if (str.length != 0) {
        realdate= [str substringToIndex:10];
    }else{
        realdate = @"时间未知";
    }
    //预计金额的类型转换
    NSString *money = [NSString stringWithFormat:@"%@",_model.forecastmoney];
    NSString *forecastmoney =[NSString stringWithFormat:@"预计成交金额%@万",money];
    if (money.length == 0) {
        forecastmoney = @"预计成交金额未知";
    }
    //客户名称
    nameLabel.text = _model.custname;
    //业务员时间显示
    [salerButton setTitle:[NSString stringWithFormat:@"%@ | %@ | %@",saler,realdate,forecastmoney] forState:UIControlStateNormal];
    
    //目的
    purpose.text = [NSString stringWithFormat:@"拜访目的：%@",_model.purpose];
    //内容
    detail.text = [NSString stringWithFormat:@"洽谈详情：%@",_model.visitecontent];
    
}
//显示更多信息
- (void)showMoreView{
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    _moreView.backgroundColor = [UIColor grayColor];
    //_moreView.alpha = .7;
    [self.view addSubview:_moreView];
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(40, 40, KscreenWidth - 80, 300)];
    
    back.backgroundColor =[UIColor whiteColor];
    [_moreView addSubview:back];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, KscreenWidth - 100, 40)];
    title.text = @"更多";
    title.font  = [UIFont systemFontOfSize:16];
    [back addSubview:title];
    //时间
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(10, title.bottom + 20, KscreenWidth - 100, 40)];
    date.font  = [UIFont systemFontOfSize:14];
    [back addSubview:date];
    date.text = [NSString stringWithFormat:@"下次拜访时间:%@",_model.nextvisitetime];
    //目的
    UILabel *purpose = [[UILabel alloc] initWithFrame:CGRectMake(10, date.bottom + 20, KscreenWidth - 100, 40)];
    purpose.font  = [UIFont systemFontOfSize:14];
    [back addSubview:purpose];
    purpose.text = [NSString stringWithFormat:@"下次拜访目的:%@",_model.nextvisitepurpose];
    //备注
    UILabel *note = [[UILabel alloc] initWithFrame:CGRectMake(10, purpose.bottom + 20, KscreenWidth - 100, 40)];
    note.numberOfLines = 0;
    note.font  = [UIFont systemFontOfSize:14];
    [back addSubview:note];
    note.text = [NSString stringWithFormat:@"备注:%@",_model.note];
    //确定
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(KscreenWidth - 160, note.bottom + 10, 60, 40);
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTintColor:[UIColor blackColor]];
    [sureButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:sureButton];
    
    
    
}
- (void)closeView{
    [_moreView removeFromSuperview];
}




- (void)zaiBaiFang{
    
    CustHistoryViewController *historyVC = [[CustHistoryViewController alloc] init];
    historyVC.visitorid = _model.visitorid;
    historyVC.custid = _model.custid;
    [self.navigationController pushViewController:historyVC animated:YES];


}
- (void)requestReply
{
    _allDataArray = [NSMutableArray array];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
    NSDictionary *params = @{@"action":@"queryThisDetail",@"table":@"khbf",@"params":[NSString stringWithFormat:@"{\"id\":\"%@\",\"custid\":\"%@\"}",_model.Id,_model.custid]};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        NSLog(@"回复列表返回:%@",array);
        for (NSDictionary *dic in array) {
            [_allDataArray addObject:dic];
        }
        [_replyList reloadData];
        NSLog(@"数组长度:%zi",_allDataArray.count);
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [self showAlert:@"批复详情加载失败"];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"cell";
    ReplyListCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (ReplyListCell *) [[[NSBundle mainBundle] loadNibNamed:@"ReplyListCell" owner:self options:nil]firstObject];
    }
    NSDictionary *dic = [_allDataArray objectAtIndex:indexPath.row];
    cell.name.text = [NSString stringWithFormat:@"%@:",dic[@"person"]];
    cell.content.text = dic[@"content"];
    cell.time.text = dic[@"time"];
    return cell;
    
}


#pragma mark 输入时后面视图向上弹
- (void)textFieldDidBeginEditing:(id)sender
{
    [self animateTextField:sender up:YES];
}
- (void)textFieldDidEndEditing:(id)sender
{
    [self animateTextField:sender up:NO];
}
- (void) animateTextField: (UITextField*) textField up:(BOOL) up
{
    const int movementDistance = 160;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)piFuButton:(id)sender
{
    /*custVisit
     action:"addVisitRe"
     table:"bfpf"
     data:"{"table":"bfpf","visiteid":"472","content":"测试"}"
     */
    NSString *content = self.piFuNeiRong.text;
    content = [self convertNull:content];
    NSLog(@"批复内容%@",content);
    if (content.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"批复内容不能为空!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/custVisit"];
        NSDictionary *params = @{@"action":@"addVisitRe",@"table":@"khbf",@"data":[NSString stringWithFormat:@"{\"table\":\"bfpf\",\"visiteid\":\"%@\",\"content\":\"%@\"}",_model.Id,content]};
        [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
            NSString *str1 =[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"客户拜访批复返回:%@",str1);
            if ([str1 isEqualToString:@"\"true\""]) {
                [self showAlert:@"批复成功"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newVisit" object:self];
            }else{
                 [self showAlert:@"批复失败"];
            }
        [self requestReply];
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
}

- (IBAction)AddAction:(UIButton *)sender {
    ZhaoPianShangChuanVC *ZPVC = [[ZhaoPianShangChuanVC alloc]init];
    [self.navigationController pushViewController:ZPVC animated:YES];
}

@end
