//
//  ZYKModel.h
//  YiRuanTong
//
//  Created by 联祥 on 15/6/9.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 fileid = "33cf7fa7b1e64de0b2f11e9186dda025.docx";
 fileids = "";
 filename = "\U6bcf\U5929\U60e0\U4e8c\U671f.docx";
 id = 365;
 isenable = "1         ";
 maxindex = 0;
 randomcode = "";
 tableid = 12;
 tablename = filtermanager;
*/
@interface ZYKModel : NSObject
@property(nonatomic,copy)NSString *fileid;
@property(nonatomic,copy)NSString *fileids;

@property(nonatomic,copy)NSString *filename;
@property(nonatomic,copy)NSString *Id;

@property(nonatomic,copy)NSString *isenable;
@property(nonatomic,copy)NSString *maxindex;

@property(nonatomic,copy)NSString *randomcode;
@property(nonatomic,copy)NSString *tableid;

@property(nonatomic,copy)NSString *tablename;

@end
