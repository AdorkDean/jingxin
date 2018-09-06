//
//  SheZhiViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/2.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "SheZhiViewController.h"
#import "LoginViewController.h"
#import "UIViewExt.h"
#import "ChangePassWordView.h"
#import "DataPost.h"
#import "JPUSHService.h"
@interface SheZhiViewController ()<UITableViewDelegate,UITableViewDataSource>
{   UIScrollView *_setScrollView;
    UIImageView *_backView;
    UIImageView *_backView1;
    UIImageView *_backView2;

    UITableView *_myTableView;
}
@end

@implementation SheZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.navigationItem.rightBarButtonItem = nil;

    self.view.backgroundColor = [UIColor whiteColor];
    [self myTableView];
}
- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64)];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2 || section == 3) {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2 || section == 3) {
        return 30;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 40;
    }
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
    header.backgroundColor = UIColorFromRGB(0xefefef);
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"cell_1";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titleArr = @[@[@"账号",@"密码"],@[@"版本号",@"意见反馈"]];
    if (indexPath.section < 2) {
        cell.textLabel.text = titleArr[indexPath.section][indexPath.row];
        
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 44, KscreenWidth, 1)];
        xian.backgroundColor = UIColorFromRGB(0xefefef);
        [cell addSubview:xian];
        
        UILabel *accountLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth-220, 10, 200, 25)];
        accountLabel1.font = [UIFont systemFontOfSize:14];
        accountLabel1.textColor = UIColorFromRGB(0x666666);
        accountLabel1.textAlignment = NSTextAlignmentRight;
        [cell addSubview:accountLabel1];
        //从userdefault 中取出数据
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (indexPath.section == 0 && indexPath.row == 0) {
            NSString *account = [userDefault objectForKey:@"account"];
            accountLabel1.text = account;
        }else if (indexPath.section == 1 && indexPath.row == 0){
            //版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            CFShow((__bridge CFTypeRef)(infoDictionary));
            accountLabel1.text = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }else if(indexPath.section == 2){
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 40)];
        lab.text = @"注销与退出";
        lab.textColor = UIColorFromRGB(0x3cbaff);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:lab];
    }else if (indexPath.section == 3){
        UILabel *showCompany = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 45)];
        showCompany.font = [UIFont systemFontOfSize:14];
        showCompany.text = @"技术支持:济南联祥网络技术有限公司\nhttp://www.lianxiangnet.com";
        showCompany.numberOfLines = 2;
        showCompany.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = UIColorFromRGB(0xefefef);
        [cell addSubview:showCompany];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self ChangePassWord];
    }else if (indexPath.section == 2) {
        [self leaveButtonACtion];
    }
}
//初始化视图
/*
- (void)_initView{
    _setScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    _setScrollView.contentSize = CGSizeMake(0, 580);
    _setScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_setScrollView];
   
    
    //姓名密码
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, KscreenWidth - 10, 80)];
    _backView.image = [UIImage imageNamed:@"set_back1.png"];
    _backView.userInteractionEnabled = NO;
    [_setScrollView addSubview:_backView];
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 50, 20)];
    accountLabel.font = [UIFont systemFontOfSize:18];
    accountLabel.text = @"账号:";
    [_backView addSubview:accountLabel];
    UILabel *accountLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(accountLabel.right, 10, 200, 20)];
    accountLabel1.font = [UIFont systemFontOfSize:18];
    
    [_backView addSubview:accountLabel1];
    
    UILabel *passWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 60, 20)];
    passWordLabel.font = [UIFont systemFontOfSize:18];
    passWordLabel.text = @"密码:";
    
    [_backView addSubview:passWordLabel];
    
    UIButton *passWordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    passWordButton.frame = CGRectMake(KscreenWidth/2+60, 45, 80, 30);
    passWordButton.userInteractionEnabled  = YES;
    passWordButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [passWordButton setTitle:@"立即修改" forState:UIControlStateNormal];
    [passWordButton addTarget:self action:@selector(ChangePassWord) forControlEvents:UIControlEventTouchUpInside];
    [_setScrollView addSubview:passWordButton];
    
    //个人信息1
    _backView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 90, KscreenWidth - 10, 160)];
    _backView1.image = [UIImage imageNamed:@"set_back.png"];
    [_setScrollView addSubview:_backView1];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 50, 20)];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.text = @"姓名:";
    [_backView1 addSubview:nameLabel];
    UILabel *nameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right, 10, 200, 20)];
    nameLabel1.font = [UIFont systemFontOfSize:18];
    
    [_backView1 addSubview:nameLabel1];
    
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 50, 20)];
    sexLabel.font = [UIFont systemFontOfSize:18];
    sexLabel.text = @"性别:";
    [_backView1 addSubview:sexLabel];
    UILabel *sexLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(sexLabel.right, 50, 200, 20)];
    sexLabel1.font = [UIFont systemFontOfSize:18];
    
    [_backView1 addSubview:sexLabel1];
    
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 50, 20)];
    ageLabel.font = [UIFont systemFontOfSize:18];
    ageLabel.text = @"年龄:";
    [_backView1 addSubview:ageLabel];
    UILabel *ageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(ageLabel.right, 90, 200, 20)];
    ageLabel1.font = [UIFont systemFontOfSize:18];
    
    [_backView1 addSubview:ageLabel1];
    
    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, 50, 20)];
    positionLabel.font = [UIFont systemFontOfSize:18];
    positionLabel.text = @"部门:";
    [_backView1 addSubview:positionLabel];
    UILabel *positionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(positionLabel.right, 130, 200, 20)];
    positionLabel1.font = [UIFont systemFontOfSize:18];
    
    [_backView1 addSubview:positionLabel1];
    
    
    //个人信息2
    _backView2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 255, KscreenWidth - 10, 160)];
    _backView2.image = [UIImage imageNamed:@"set_back.png"];
    [_setScrollView addSubview:_backView2];
    UILabel *cellnoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 50, 20)];
    cellnoLabel.font = [UIFont systemFontOfSize:18];
    cellnoLabel.text = @"手机:";
    [_backView2 addSubview:cellnoLabel];
    UILabel *cellnoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right, 10, 200, 20)];
    cellnoLabel1.font = [UIFont systemFontOfSize:18];
    
    [_backView2 addSubview:cellnoLabel1];
    
    UILabel *telnoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 50, 20)];
    telnoLabel.font = [UIFont systemFontOfSize:18];
    telnoLabel.text = @"固话:";
    [_backView2 addSubview:telnoLabel];
    UILabel *telnoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(sexLabel.right, 50, 200, 20)];
    telnoLabel1.font = [UIFont systemFontOfSize:18];
    
    [_backView2 addSubview:telnoLabel1];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 50, 20)];
    emailLabel.font = [UIFont systemFontOfSize:18];
    emailLabel.text = @"邮箱:";
    [_backView2 addSubview:emailLabel];
    UILabel *emailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(ageLabel.right, 90, 200, 20)];
    emailLabel1.font = [UIFont systemFontOfSize:18];

    [_backView2 addSubview:emailLabel1];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, 50, 20)];
    noteLabel.font = [UIFont systemFontOfSize:18];
    noteLabel.text = @"说明:";
    [_backView2 addSubview:noteLabel];
    UILabel *noteLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(positionLabel.right, 130, 200, 20)];
    noteLabel1.font = [UIFont systemFontOfSize:18];
    
    [_backView2 addSubview:noteLabel1];
    //从userdefault 中取出数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefault objectForKey:@"account"];
    accountLabel1.text = account;
    NSString *name = [userDefault objectForKey:@"name"];
    nameLabel1.text = name;
    NSString *sex = [userDefault objectForKey:@"sex"];
    [sex isEqualToString:@"1"]?(sexLabel1.text=@"男"):(sexLabel1.text=@"女");
    
    NSString *age = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"age"]];
    ageLabel1.text = age;
    NSString *positon = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"myposition"]];
    positionLabel1.text = positon;
    
    NSString *cellno = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"cellno"]];
    cellnoLabel1.text = cellno;
    NSString *telno = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"telno"]];
    telnoLabel1.text = telno;
    NSString *email = [userDefault objectForKey:@"email"];
    emailLabel1.text = email;
    NSString *note = [userDefault objectForKey:@"note"];
    noteLabel1.text = note;
    

    //退出
    _leaveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _leaveButton.frame = CGRectMake(KscreenWidth/2 - 110, 430 , 220, 40);
    _banbenButton.backgroundColor = [UIColor grayColor];
    
    [_leaveButton setTitle:@"注销登录" forState:UIControlStateNormal];
    _leaveButton.layer.masksToBounds = YES;
    _leaveButton.layer.cornerRadius = 5;
    [_leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leaveButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_leaveButton setBackgroundImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    [_leaveButton addTarget:self action:@selector(leaveButtonACtion:) forControlEvents:UIControlEventTouchUpInside];
    [_setScrollView addSubview:_leaveButton];
    //版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [NSString stringWithFormat:@"版本:%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    _banbenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _banbenButton.frame = CGRectMake(KscreenWidth/2 -110, 475, 220, 30);
    [_banbenButton setTitle:app_Version forState:UIControlStateNormal];
    [_banbenButton addTarget:self action:@selector(banbenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_setScrollView addSubview:_banbenButton];
    
    UILabel *showCompany = [[UILabel alloc] initWithFrame:CGRectMake(0, 505, KscreenWidth, 20)];
    showCompany.font = [UIFont systemFontOfSize:14];
    showCompany.text = @"技术支持:济南联祥网络技术有限公司";
    showCompany.numberOfLines = 0;
    showCompany.textAlignment = NSTextAlignmentCenter;
    [_setScrollView addSubview:showCompany];
    
    UILabel *showNetAdd = [[UILabel alloc] initWithFrame:CGRectMake(0, 525, KscreenWidth, 20)];
    showNetAdd.font = [UIFont systemFontOfSize:14];
    showNetAdd.text = @"网址:http://www.lianxiangnet.com";
    showNetAdd.numberOfLines = 0;
    showNetAdd.textAlignment = NSTextAlignmentCenter;
    [_setScrollView addSubview:showNetAdd];
    

    
    //显示接口
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2 -150, 545, 300, 30)];
    loginLabel.text = [NSString stringWithFormat:@"接口：%@",PHOTO_ADDRESS];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.numberOfLines = 0;
    loginLabel.font = [UIFont systemFontOfSize:14.0];
    [_setScrollView addSubview:loginLabel];
}
*/
//按钮点击事件
- (void)leaveButtonACtion{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"存储的%@",[userDefault objectForKey:@"isRemember"]);
    NSInteger j  = [[userDefault objectForKey:@"isRemember"]integerValue];
    if (j == 1) {
        
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    }
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    //
     [self logOut];
    [self presentViewController:loginVC animated:YES completion:nil];
    
    
}
//版本
- (void)banbenButtonAction:(UIButton *)button{

    NSLog(@"banben");
}
//修改密码
- (void)ChangePassWord{
    NSLog(@"mima");
    ChangePassWordView *changeVC = [[ChangePassWordView alloc] init];
    changeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeVC animated:YES];

}

- (void)logOut{
    
    [socketSingleton socketSingletonClose];
   NSString * idstring = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/loginout"];
    NSDictionary *params = @{@"":@""};
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        
        NSLog(@"推出登录销毁session");
//        [JPUSHService deleteTags:idstring completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//
//        } seq:arc4random()%100];
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:arc4random()%100];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
    
    
    
}

@end
