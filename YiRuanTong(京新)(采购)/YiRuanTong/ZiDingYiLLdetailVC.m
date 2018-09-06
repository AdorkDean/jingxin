//
//  ZiDingYiLLdetailVC.m
//  YiRuanTong
//
//  Created by lx on 15/5/19.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "ZiDingYiLLdetailVC.h"
#import "SPDetaillModel.h"

@interface ZiDingYiLLdetailVC ()

{
    NSArray *_nameArray;
    NSMutableArray *_detailArray;
    UIView *_detailView;
    NSMutableArray *_dataArray;
}

@end

@implementation ZiDingYiLLdetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"上报详情";
    [self showBarWithName:@"删除" addBarWithName:nil];
//    self.navigationItem.rightBarButtonItem = nil;
    _nameArray = @[@"类型",@"上报人",@"审批流程",@"审批状态",@"上报时间"];
    _dataArray = [[NSMutableArray alloc] init];
    NSString *str = @"自定义审批";
    
    _detailArray = [[NSMutableArray alloc] init];
    [_detailArray addObject:_model.sptypename];
    [_detailArray addObject:_model.creator];
    [_detailArray addObject:str];
    [_detailArray addObject:_model.spnodename];
    [_detailArray addObject:_model.createtime];
    
    [self dataRequest];
    [self pageload];
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
        //横线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 40+41*i, KscreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        
        [scroller addSubview:titleLabel];
        [scroller addSubview:zhanshiLabel];
        [scroller addSubview:line];
    }
    //展示动态信息的View
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 41 * 5 , KscreenWidth, 61 * _dataArray.count)];
    _detailView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        SPDetaillModel *model = [_dataArray objectAtIndex:i];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,61 * i, 89, 60)];
        titleLabel.backgroundColor = COLOR(231, 231, 231, 1);
        titleLabel.text = model.name;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        //展示label
        UILabel *zhanshiLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 61 * i, KscreenWidth - 110, 60)];
        zhanshiLabel.textAlignment = NSTextAlignmentCenter;
        zhanshiLabel.font = [UIFont systemFontOfSize:14.0];
        zhanshiLabel.numberOfLines = 0;
        zhanshiLabel.text = model.spcontent;
        
        //横线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,60+61*i , KscreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        [_detailView addSubview:titleLabel];
        [_detailView addSubview:zhanshiLabel];
        [_detailView addSubview:line];
    }
    //竖线
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(89, 0, 1, 41*5 + _dataArray.count*61)];
    line1.backgroundColor = [UIColor grayColor];
    
    [scroller addSubview:_detailView];
    [scroller addSubview:line1];
    scroller.contentSize = CGSizeMake(KscreenWidth, 41*5+_dataArray.count * 61+10);
    [self.view addSubview:scroller];
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

-(void)addNext{
    
    [self deleteShenpi];
}
-(void)deleteShenpi
{
    NSInteger  sid = [_model.Id integerValue];
    NSString *strAdress = @"/spdefine?action=delSpSelfDefine";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",DATA_ADDRESS,strAdress];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSString *str = [NSString stringWithFormat:@"table=shenpizdy&data={\"id\":[%ld],\"key\":\"%@\",\"value\":\"%@\"}",sid,@"isValid",@"1"];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString * result = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    if ([result containsString:@"true"]) {
        [self showAlert:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([result containsString:@"false"]) {
        [self showAlert:@"删除失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
         result = [result stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [self showAlert:result];
    }
//    if (data1 != nil) {
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:nil];
//        NSLog(@"删除:%@",array);
//        for (NSDictionary *dic in array) {
//            SPDetaillModel *model = [[SPDetaillModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            [_dataArray addObject:model];
//        }
//    }
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
