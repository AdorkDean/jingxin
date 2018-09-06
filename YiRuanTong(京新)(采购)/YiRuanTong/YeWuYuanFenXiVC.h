//
//  YeWuYuanFenXiVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/9/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"

@interface YeWuYuanFenXiVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *yeWuYuanFenXiTableView;

@property (strong, nonatomic) UILabel *m_yingHuiKuan;
@property (strong, nonatomic) UILabel *m_shiJiHuiKuan;


//
@property(nonatomic,retain)NSMutableArray *DataArray;
@property(nonatomic,retain)NSMutableArray *nameArray;
@property(nonatomic,retain)NSMutableArray *sendArray;
@property(nonatomic,retain)NSMutableArray *returnArray;

/*- (void)getSaler{
 // params:"{"nameLIKE":"李"}"
 NSString *saler = _custField.text;
 saler = [self convertNull:saler];
 NSString *urlstr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,@"/account"];
 NSDictionary *params = @{@"action":@"getPrincipals",@"table":@"ddxx",@"params":[NSString stringWithFormat:@"{\"nameLIKE\":\"%@\"}",saler]};
 [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
 NSArray *array =[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
 NSLog(@"业务员数据%@",array);
 for (NSDictionary *dic in array) {
 CustModel *model = [[CustModel alloc] init];
 [model setValuesForKeysWithDictionary:dic];
 [_dataArray addObject:model];
 }
 [self.salerTableView reloadData];
 } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
 NSLog(@"业务员名称加载失败");
 }];
 
 
 }
*/
@end
