//
//  PayRecordTable.h
//  CBB
//
//  Created by 卡宝宝 on 13-9-10.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "BaseClientTable.h"
#import "DataModel.h"

@interface PayRecordTable : BaseClientTable<UIAlertViewDelegate>
@property(nonatomic,assign)NSInteger businessType;
@property(nonatomic,retain)NSMutableDictionary *data;
@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,assign)NSInteger page;
@end
