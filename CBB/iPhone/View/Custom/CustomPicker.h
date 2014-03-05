//
//  CustomPicker.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-15.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerDelegate <NSObject>
@required
-(void)confirmAction:(NSString *)value WithInfo:(NSDictionary *)info;
-(void)selectAction:(NSString *)value;
@end

@interface CustomPicker : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,retain)NSArray *keysInOrder;
@property(nonatomic,assign)NSInteger components;
@property(nonatomic,retain)NSString *selectItem;
@property(nonatomic,retain)NSDictionary *userInfo;
@property(nonatomic,retain)UILabel *text;
@property(nonatomic,assign)id<CustomPickerDelegate> delegate;
- (void)showPickerInView:(UIView *)view;
- (void)cancelPicker;
@end
