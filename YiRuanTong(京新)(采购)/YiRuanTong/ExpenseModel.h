//
//  ExpenseModel.h
//  仿钉钉报销demo
//
//  Created by 华腾软科 on 16/8/24.
//  Copyright © 2016年 华腾软科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ExpenseModel : JSONModel

@property (nonatomic, assign)NSInteger aliph;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *Money;
@property (nonatomic, strong)NSString *ExpenseType;
@property (nonatomic, strong)NSString *ExpenseDetails;

@end
