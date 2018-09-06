//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"

#define UUTagLabelwidth     80

@interface UUBarChart ()
{
    UIScrollView *myScrollView;
}
@end

@implementation UUBarChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        myScrollView.bounces = NO;
        myScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;
    
    for (int i=0; i<5; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
		label.text = [NSString stringWithFormat:@"%.1f",level * i+_yValueMin];
		[self addSubview:label];
    }
	
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    NSInteger num;//限制柱状图的组数 一页最多 最少
    if (xLabels.count>=6) {
        num = 6;
    }else if (xLabels.count<=6){
        num = 6;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = myScrollView.frame.size.width/num;
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        [myScrollView addSubview:label];
        
        [_chartLabelsForX addObject:label];
    }
    
    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height);
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

-(void)strokeChart
{
    
    
	
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        if (i == 0) {
            NSArray *childAry = _yValues[i];
            for (int j=0; j<childAry.count; j++) {
                NSString *valueString = childAry[j];
                float value = [valueString floatValue];
                float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
                CGFloat firstValue = value;
                CGFloat xPosition = (UUYLabelwidth + _xLabelWidth * j  - _xLabelWidth/8*3);
                CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
                
                UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.47, UULabelHeight, _xLabelWidth * (_yValues.count==1?0.8:0.45), chartCavanHeight)];
                bar.barColor = [_colors objectAtIndex:i];
                bar.grade = grade;
                [myScrollView addSubview:bar];
                
                 [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight) index:j value:firstValue];
                
            }

        }else if ( i == 1){
            NSArray *childAry = _yValues[i];
            for (int j=0; j<childAry.count; j++) {
                NSString *valueString = childAry[j];
                float value = [valueString floatValue];
                float grade = ((float)value-_yValueMin) / ((float)_yValueMax-_yValueMin);
                CGFloat firstValue = value;
                CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/8.0
                                     + _xLabelWidth * j);
                CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
            
                
                UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.47, UULabelHeight, _xLabelWidth * (_yValues.count==1?0.8:0.45), chartCavanHeight)];
                bar.barColor = [_colors objectAtIndex:i];
                bar.grade = grade;
                [myScrollView addSubview:bar];
                
                [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight) index:j value:firstValue];
                
            }
            
        }
    }
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index value:(CGFloat)value
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
    label.center = point;
    label.font = [UIFont systemFontOfSize:8];
    label.textAlignment = NSTextAlignmentCenter;
    //label.backgroundColor = [UIColor blueColor];
    label.text = [NSString stringWithFormat:@"%d",(int)value];
    [myScrollView addSubview:label];
    
    
}



@end
