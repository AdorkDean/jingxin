//
//  NTChartView.h
//  DimensionalHistogram
//
//  Created by benbenxiong on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NTChartView : UIView {
	//组数据
	NSArray *chartTitle;
	//组数据
	NSArray *groupData;
    //组数据名
    NSArray *groupTitle;
    //Ｘ轴标签
    NSArray *xAxisLabel;
	
	//最大值，最小值, 列宽度, 
	float maxValue,minValue,columnWidth,maxScaleValue,maxScaleHeight,sideWidth;
	
	int chartType;
}

@property(retain, nonatomic) NSArray *chartTitle;
@property(retain, nonatomic) NSArray *groupData;
@property(retain, nonatomic) NSArray *groupTitle;
@property(retain, nonatomic) NSArray *xAxisLabel;
@property(assign) int chartType;

@end
