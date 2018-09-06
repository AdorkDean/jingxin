//
//  ZhaoPianShangChuanVC.h
//  YiRuanTong
//
//  Created by 联祥 on 15/3/11.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "BaseViewController.h"
#import "AFNetworking.h"
#define NotificationTabBarHidden @"tabbarhidden"

@interface ZhaoPianShangChuanVC : BaseViewController<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
{
    UIActionSheet *myActionSheet;//下拉菜单
    NSString* filePath;//图片2进制路径
    
}

@property(strong,nonatomic)UITableView *TypetableView;

@property(strong,nonatomic)UIButton *leiXingButton;
@property(nonatomic,retain)NSMutableArray *leiXingDataArray;
@property(nonatomic,copy)NSString *nameID;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,retain)NSMutableArray *leiXingName;
@property(nonatomic,retain)NSMutableArray *leiXingID;
@property(nonatomic,retain)UITextField *mingChen2; //活动名称
@property(nonatomic,retain)UITextField *miaoShu2;  //照片描述  

@end
