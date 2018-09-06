//
//  ExpenseDemoCell.m
//  仿钉钉报销demo
//
//  Created by 华腾软科 on 16/8/23.
//  Copyright © 2016年 华腾软科. All rights reserved.
//

#import "ExpenseDemoCell.h"
#import "ExpenseModel.h"

@interface ExpenseDemoCell ()<UITextViewDelegate>
{
    NSInteger choseIndex;
}
@property (weak, nonatomic) IBOutlet UITextField *ExpenseMoney;
@property (weak, nonatomic) IBOutlet UITextField *ExpenseType;
@property (weak, nonatomic) IBOutlet UITextView *ExpenseDetails;
@property (weak, nonatomic) IBOutlet UILabel *Index;
@property (weak, nonatomic) IBOutlet UIButton *delateBtn;
@end


@implementation ExpenseDemoCell

-(void)initwith:(NSMutableArray *)info Index:(NSInteger)index
{
    ExpenseModel *model=[[ExpenseModel alloc]initWithDictionary:info error:nil];
    
    self.Index.text=[NSString stringWithFormat:@"报销明细(%ld)",index];
    
    NSLog(@"%@",model.type);

    [self.delateBtn setTitle:model.type forState:UIControlStateNormal];
    
    self.ExpenseDetails.text=model.ExpenseDetails;
    
    self.delateBtn.alpha=model.aliph;
    
    choseIndex=index;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    /**
     *  textview代理
     */
    self.ExpenseDetails.delegate=self;
    
//    [self.delateBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

}

-(void)textViewDidChange:(UITextView *)textView
{
    CGSize size=[textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame=textView.frame;
    
    NSLog(@"%f",frame.size.height);
    /**
     *  改变时进行数据的更新和textview的自适应
     */
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        [self.delegate textViewCell:self didChangeText:textView.text];
    }
    /**
     *  高度的计算
     */
    frame.size.height=size.height;
    textView.frame=frame;
    self.ExpenseDetails.frame=frame;
    
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
    
//    NSLog(@"%f",size.height);
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    
    return (UITableView *)tableView;
}
- (IBAction)Delate:(id)sender {
    [self.delegate Refresh:choseIndex];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
