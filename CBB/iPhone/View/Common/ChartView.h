//
//  CardChartView.h
//  CBB
//
//  Created by 卡宝宝 on 13-10-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"

@interface ChartView : UIViewController<PieChartDelegate>
@property(nonatomic,retain)NSDictionary *statistics;
@property(nonatomic,assign)NSInteger businessType;
@end
