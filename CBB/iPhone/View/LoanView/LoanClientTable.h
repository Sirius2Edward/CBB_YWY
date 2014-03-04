//
//  LoanClientTable.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "BaseClientTable.h"
#import "DataModel.h"
#import "LoanClientSift.h"

@interface BaseLoanCell : UITableViewCell
@property(nonatomic,retain)LoanClient *item;
@property(nonatomic,retain)UIImageView *bg;
@end

@class NewLoanClientTable;
@interface NewLoanClientCell : BaseLoanCell<UIAlertViewDelegate,UIActionSheetDelegate>
@property(nonatomic,retain)NewLoanClientTable *controller;
@end

@class DoneLoanClientTable;
@interface DoneLoanClientCell : BaseLoanCell
@property(nonatomic,retain)DoneLoanClientTable *controller;
@end

//新客户申请表
@interface NewLoanClientTable : BaseClientTable<changeSiftParaDelegate>
@property(nonatomic,retain)NSMutableDictionary *data;
@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,assign)NSInteger page;
@end

//已购买的客户表
@interface DoneLoanClientTable : BaseClientTable
@property(nonatomic,retain)NSMutableDictionary *data;
@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,retain)NSDictionary *zts;
@end

@interface LoanClientTable : BaseClientTable
@end
