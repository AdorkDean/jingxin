//
//  ProductMateriaDetailVC.h
//  YiRuanTong
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "ProMaterialModel.h"
@interface ProductMateriaDetailVC : BaseViewController<UIScrollViewDelegate>
@property (nonatomic,weak)ProMaterialModel* model;
@property(nonatomic,retain) UIScrollView *dingDanScrollView; //

@end
