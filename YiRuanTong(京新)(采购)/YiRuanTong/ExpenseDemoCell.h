//
//  ExpenseDemoCell.h
//  仿钉钉报销demo
//
//  Created by 华腾软科 on 16/8/23.
//  Copyright © 2016年 华腾软科. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpenseDemoCell;
/**
 *  代理
 */
@protocol TextViewCellDelegate <NSObject>

- (void)textViewCell:(ExpenseDemoCell *)cell didChangeText:(NSString *)text;

-(void)Refresh:(NSInteger)index;

@end

@interface ExpenseDemoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) id<TextViewCellDelegate> delegate;

-(void)initwith:(NSDictionary *)info Index:(NSInteger)index;

@end

