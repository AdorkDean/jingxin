//
//  ArroundModel.h
//  YiRuanTong
//
//  Created by 邱 德政 on 2018/6/28.
//  Copyright © 2018年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 distance = "68.42458162465105";
 id = 245;
 latitude = "36.675595";
 longitude = "117.228472";
 name = "\U5218\U6811\U80dc";
 receiveaddr = "\U5c71\U4e1c\U7701\U6f4d\U574a\U5e02\U5bff\U5149\U53bf\U9053\U53e3\U9547\Uff08\U5c0f\U6ee1\U7269\U6d41\Uff09";
 
*/
@interface ArroundModel : NSObject
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *receiveaddr;

@end
