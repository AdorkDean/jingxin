//
//  VideoModel.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/12.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 bigthumbnail = "https://vthumb.ykimg.com/054104085B172DBD0000016BBF0B6696";
 created = "2018-06-12 10:54:37";
 description = "";
 duration = "5.47";
 id = 209;
 link = "http://v.youku.com/v_show/id_XMzY1OTcyNzgyOA==.html";
 published = "2018-06-12 10:54:38";
 state = published;
 thumbnail = "";
 title = 11;
 vid = "XMzY1OTcyNzgyOA
*/
@interface VideoModel : NSObject
@property (nonatomic,copy) NSString *bigthumbnail;
@property (nonatomic,copy) NSString *creator;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *duration;
@property (nonatomic,copy) NSString *Id;


@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *published;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *thumbnail;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *vid;
@end
