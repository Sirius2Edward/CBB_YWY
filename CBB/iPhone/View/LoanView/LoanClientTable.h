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
#import "CustomPicker.h"

#pragma mark - Cell
@interface BaseLoanCell : UITableViewCell
@property(nonatomic,retain)LoanClient *item;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *amountLabel;
@property(nonatomic,retain)UILabel *adDateLabel;
@property(nonatomic,retain)UIImageView *bg;
@end

@class NewLoanClientTable;
@interface NewLoanClientCell : BaseLoanCell<UIAlertViewDelegate,UIActionSheetDelegate>
@property(nonatomic,retain)NewLoanClientTable *controller;
@end

@class DoneLoanClientTable;
@interface DoneLoanClientCell : BaseLoanCell
@property(nonatomic,retain)DoneLoanClientTable *controller;
@property(nonatomic,retain)NSString *status;
@end

@class ForMeLoanClientTable;
@interface LoanShopClientCell : BaseLoanCell<UIAlertViewDelegate>
@property(nonatomic,retain)ForMeLoanClientTable *controller;
@end
@interface LoanProductClientCell : BaseLoanCell<UIAlertViewDelegate>
@property(nonatomic,retain)ForMeLoanClientTable *controller;
@end

#pragma mark - Table
@interface LoanClientTable : BaseClientTable
@property(nonatomic,retain)NSMutableDictionary *data;
@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,assign)NSInteger page;
@end

//新客户申请表
@interface NewLoanClientTable : LoanClientTable//<changeSiftParaDelegate>
@end

//已购买的客户表
@interface DoneLoanClientTable : LoanClientTable<CustomPickerDelegate>
-(void)updateStatus:(DoneLoanClientCell *)cell;
@end

//对我申请的客户表
@interface ForMeLoanClientTable : LoanClientTable
-(void)buyForMeClient:(BaseLoanCell *)cell;
@end
