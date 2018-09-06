//
//  LXWriteReportTableHeadView.m
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/6.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "LXWriteReportTableHeadView.h"

@implementation LXWriteReportTableHeadView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *headerID = @"header";
    LXWriteReportTableHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[LXWriteReportTableHeadView alloc]initWithReuseIdentifier:headerID];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        //添加头(尾)视图中的控件
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(KscreenWidth-5-120, 5, 120, 20)];
        label.text = @"实时保存输入内容";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
    }
    return self;
}

@end
