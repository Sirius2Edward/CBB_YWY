//
//  CustomTextField.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-7.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPicker.h"
@interface CustomTextField : UIView<UITextFieldDelegate>
@property(nonatomic,retain)UITextField *tField;
@property(nonatomic,retain)UIImage *textDownImage;//编辑状态背景
@property(nonatomic,retain)UIImage *textOutImage;//普通状态背景
@property(nonatomic,assign)CGFloat leftOffset;//设置左边界
@property(nonatomic,assign)CGFloat rightOffset;//设置右边界
@property(nonatomic,assign)NSInteger maxLength;//最多输入位数
@end
