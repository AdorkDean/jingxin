//
//  BaoBiaoTongJiViewController.m
//  YiRuanTong
//
//  Created by 联祥 on 15/3/4.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaoBiaoTongJiViewController.h"
#import "MainViewController.h"
#import "BaoBiaoTongJiCell.h"
#import "SalePurposeVc.h"
#import "KeHuFaHuoVC.h"
#import "ChanPinFaHuoVC.h"
#import "ChanPinXiaoShouVC.h"
#import "KeHuHuiKuanTQVC.h"
#import "KeHuFaHuoDuiBiVC.h"
#import "YeWuYuanFenXiVC.h"
#import "KHCPXiaoShouVC.h"
#import "KHHuiKuanShuJuVc.h"
#import "XiaoShouFahuoVC.h"
#import "CPFahuoDuiBiVC.h"
@interface BaoBiaoTongJiViewController ()

@end

@implementation BaoBiaoTongJiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报表统计";
    //删除添加按钮
    self.navigationItem.rightBarButtonItem = nil;
    [self PageViewDidLoad1];
    
    _baoBiaoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight-64) style:UITableViewStylePlain];
    
    self.baoBiaoTableView.delegate = self;
    self.baoBiaoTableView.dataSource = self;
    [self.view addSubview:_baoBiaoTableView];
}

- (void)PageViewDidLoad1
{
    //报表统计的第一个  页面的 数据表格形式的 排列
    self.m_baoBiaoArray =@[@"产品发货排名",@"产品销售区域分析",@"客户产品销售额汇总",@"销售员发货排名",@"客户发货同期对比",@"产品发货同期对比"];
}
#pragma mark UITableView DataSource And Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_baoBiaoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"cell";
    BaoBiaoTongJiCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil)
    {
        cell =(BaoBiaoTongJiCell*)[[[NSBundle mainBundle]loadNibNamed:@"BaoBiaoTongJiCell" owner:self options:nil]firstObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.baoBiaoMingCheng.text=self.m_baoBiaoArray[indexPath.row];
    cell.iconsView.image = [UIImage imageNamed:self.m_baoBiaoArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.row ==0){
        
        ChanPinFaHuoVC *proview =[[ChanPinFaHuoVC alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:proview animated:YES];
    }else if (indexPath.row ==1){
        
        ChanPinXiaoShouVC *proAreaView =[[ChanPinXiaoShouVC alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:proAreaView animated:YES];
    }else if (indexPath.row ==2){
        //客户产品销售总额汇总11
        KHCPXiaoShouVC *khcp =[[KHCPXiaoShouVC alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:khcp animated:YES];
       
    }else if (indexPath.row ==3){
        XiaoShouFahuoVC *khcp =[[XiaoShouFahuoVC alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:khcp animated:YES];
    }else if (indexPath.row ==4){
        KeHuFaHuoDuiBiVC *khcp =[[KeHuFaHuoDuiBiVC alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:khcp animated:YES];
    }else if (indexPath.row ==5){
        CPFahuoDuiBiVC *khcp =[[CPFahuoDuiBiVC alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:khcp animated:YES];
    }

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
