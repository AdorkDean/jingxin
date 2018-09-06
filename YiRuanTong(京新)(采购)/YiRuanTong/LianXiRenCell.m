//
//  LianXiRenCell.m
//  yiruantong
//
//  Created by 邱 德政 on 15/1/24.
//  Copyright (c) 2015年 济南联祥技术有限公司. All rights reserved.
//

#import "LianXiRenCell.h"

@implementation LianXiRenCell
{
    UIView *_timeView;
    NSString *_currentDateStr;
}

- (void)awakeFromNib {
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _currentDateStr =[dateFormatter stringFromDate:currentDate];
    
    [self.shengRiButton setTitle:_currentDateStr forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGr];
}
- (void)viewTapped:(UITapGestureRecognizer *) tapGr
{
    self.datePicker.hidden = YES;
}

- (IBAction)shengRiButtonPressed:(id)sender
{
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, KscreenHeight - _timeView.frame.size.height-64, KscreenWidth, 270)];
    _timeView.backgroundColor = [UIColor whiteColor];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, KscreenWidth, KscreenHeight-64-280-30)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(_timeView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [_timeView addSubview:_datePicker];
    [self.superview.superview.superview addSubview:_timeView];
}

- (void)closetime
{
    [_timeView removeFromSuperview];
}

//监听datePicker值发生变化
- (void)dateChange:(id) sender
{
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(250, 140, 70, 40)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [datePicker addSubview:button];
    
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    NSLog(@"日期属性  --------- %@",dateString);
    [self.shengRiButton setTitle:dateString forState:UIControlStateNormal];
    
}

@end
