//
//  ProductingDetailVC.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/7/18.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "ProMaterialModel.h"
@interface ProductDetailNewVC : BaseViewController<UIScrollViewDelegate>
@property (nonatomic,weak)ProMaterialModel* model;
@property(nonatomic,retain) UIScrollView *dingDanScrollView; //
@property (strong, nonatomic) UIView * m_keHuPopView;

@end
