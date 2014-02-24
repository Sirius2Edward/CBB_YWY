//
//  CardClientTable.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-14.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "DataModel.h"
#import "BaseClientTable.h"
#import "CYCustomMultiSelectPickerView.h"
#import "CustomPicker.h"
#import "ListButton.h"
#import "CardClientSift.h"

@interface BaseCardCell : UITableViewCell
@property(nonatomic,retain)CardClient *item;
@end

@class NewCardClientTable;
@interface NewCardClientCell : BaseCardCell<UIAlertViewDelegate,UIActionSheetDelegate>
@property(nonatomic,retain)NewCardClientTable *controller;
@end

@class DoneCardClientTable;
@interface DoneCardClientCell : BaseCardCell
@property(nonatomic,retain)DoneCardClientTable *controller;
@property(nonatomic,retain)NSDictionary *statusList;
@end

//新客户申请表
@interface NewCardClientTable : BaseClientTable<changeSiftParaDelegate>
@property(nonatomic,retain)NSMutableDictionary *data;
@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,assign)NSInteger page;
@end

//已购买的客户表
@interface DoneCardClientTable : BaseClientTable<CustomPickerDelegate,ListDelegate>
@property(nonatomic,retain)NSMutableDictionary *data;
@property(nonatomic,retain)NSMutableArray *items;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,retain)NSDictionary *zts;
@end

@interface CardClientTable : BaseClientTable
@end