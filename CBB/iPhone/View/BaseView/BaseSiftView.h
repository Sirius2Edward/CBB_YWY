//
//  BaseSiftView.h
//  CBB
//
//  Created by 卡宝宝 on 13-9-16.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPPickerView.h"

@protocol CPPickerViewCellDataSource <NSObject>
- (NSInteger)numberOfItemsInPickerViewAtIndexPath:(NSIndexPath *)pickerPath;
- (NSString *)pickerViewAtIndexPath:(NSIndexPath *)pickerPath titleForItem:(NSInteger)item;
@end

@protocol CPPickerViewCellDelegate <NSObject>
- (void)pickerViewAtIndexPath:(NSIndexPath *)pickerPath didSelectItem:(NSInteger)item;
@end

@interface PickerCell : UITableViewCell<CPPickerViewDelegate, CPPickerViewDataSource>
@property (nonatomic, unsafe_unretained) id <CPPickerViewCellDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id <CPPickerViewCellDelegate> delegate;
@property (nonatomic, unsafe_unretained) CPPickerView *pickerView;
@property (nonatomic, copy) NSIndexPath *currentIndexPath;
@property (nonatomic, readonly) NSInteger selectedItem;
@property (nonatomic) BOOL showGlass;
@property (nonatomic) UIEdgeInsets peekInset;
// Handling
- (void)reloadData;
- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated;
@end

@interface SelectorCell : UITableViewCell
@property(nonatomic,retain)UIButton *button;
@end

@interface DoubleTextCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,retain)UILabel *firLabel;
@property(nonatomic,retain)UILabel *secLabel;
@property(nonatomic,retain)UITextField *firText;
@property(nonatomic,retain)UITextField *secText;
@end

#pragma mark -
@protocol changeSiftParaDelegate <NSObject>
-(void)changeSiftPara:(NSMutableDictionary *)aDic Data:(NSDictionary *)data;
@end

@interface BaseSiftView : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign)id<changeSiftParaDelegate> delegate;
-(void)submit;          //提交按钮操作
-(void)popAction;       //返回按钮操作
@end
