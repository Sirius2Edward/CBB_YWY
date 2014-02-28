//
//  LoanAdvisorView.h
//  CBB
//
//  Created by 卡宝宝 on 14-2-25.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import "BaseClientTable.h"

@interface LoanAdvisorView : BaseClientTable
@property(nonatomic,retain)NSDictionary *data;
-(void)removeCell:(UITableViewCell *)aCell;
-(void)replyWithDic:(NSDictionary *)aDic;
@end
