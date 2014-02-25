//
//  LoanAdvisorView.m
//  CBB
//
//  Created by 卡宝宝 on 14-2-25.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "LoanAdvisorView.h"

@interface LoanAdvisorView ()

@end

@implementation LoanAdvisorView
@synthesize data;
-(void)loadView
{
    [super loadView];
    self.title = @"用户咨询";
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"未回复",@"已回复"]];
    seg.frame = CGRectMake(90, 5, 110, 32);
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    seg.tintColor = [UIColor whiteColor];
    UIBarButtonItem *bItem = [[UIBarButtonItem alloc] initWithCustomView:seg];
    self.navigationItem.rightBarButtonItem=bItem;
}

@end
