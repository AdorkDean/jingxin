//
//  MyViewController.m
//  YiRuanTong
//
//  Created by apple on 17/8/4.
//  Copyright © 2017年 联祥. All rights reserved.
//

#import "MyViewController.h"
#import "SheZhiViewController.h"
#import "MyMeansViewController.h"
@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong)UITableView *myTableView;
@end

@implementation MyViewController{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:UIColorFromRGB(0x222222)}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

}
- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64-49)];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = UIColorFromRGB(0xf7f9fa);
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_myTableView];
        
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 160*MYWIDTH)];
       // headview.image = [UIImage imageNamed:@"slideshow01"];
        headview.backgroundColor = [UIColor whiteColor];
        _myTableView.tableHeaderView = headview;
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

        UIImageView *header = [[UIImageView alloc]initWithFrame:CGRectMake(15, 30*MYWIDTH, 100*MYWIDTH, 100*MYWIDTH)];
        header.image = [UIImage imageNamed:@"tubiao180"];
        header.layer.masksToBounds = YES;
        header.layer.cornerRadius = 50*MYWIDTH;
        [headview addSubview:header];
        
        UILabel *namelab = [[UILabel alloc]initWithFrame:CGRectMake(30+100*MYWIDTH, 30*MYWIDTH, 200, 100*MYWIDTH)];
        namelab.text = [NSString stringWithFormat:@"%@\n\n%@",[user objectForKey:@"name"],[user objectForKey:@"cellno"]];
        namelab.numberOfLines = 0;
        namelab.textColor = UIColorFromRGB(0x333333);
        namelab.font = [UIFont systemFontOfSize:17];
        [headview addSubview:namelab];
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self myTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
    header.backgroundColor = UIColorFromRGB(0xf7f9fa);
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
    NSArray *titleArr = @[@"企业信息",@"个人资料",@"客服热线",@"设置"];
    cell.imageView.image = [UIImage imageNamed:titleArr[indexPath.section]];
    cell.textLabel.text = titleArr[indexPath.section];
    if (indexPath.section == 2) {
        UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth-220, 10, 200, 25)];
        accountLabel.font = [UIFont systemFontOfSize:14];
        accountLabel.textColor = UIColorFromRGB(0x3cbaff);
        accountLabel.text = @"0531-88807916";
        accountLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:accountLabel];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        SheZhiViewController *shezhivc = [[SheZhiViewController alloc]init];
        shezhivc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shezhivc animated:YES];
    }else if (indexPath.section == 2){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否拨打电话" message:@"0531-88807916" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        [alert show];
        
    }else if (indexPath.section == 1){
        MyMeansViewController *mymeans = [[MyMeansViewController alloc]init];
        mymeans.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mymeans animated:YES];
    }else if (indexPath.section == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"暂无企业信息" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0531-88807916"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
