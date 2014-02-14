//
//  BaseEditView.h
//  CBB
//
//  Created by 卡宝宝 on 13-8-22.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request_API.h"
#import "DataModel.h"
#import "CustomTextField.h"
#import "CustomPicker.h"
#import "CustomLabel.h"
#import "UIColor+TitleColor.h"
#import "NSString+Validate.h"

@interface BaseEditView : UIViewController<UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)Request_API *req;
-(void)submit;          //提交按钮操作
-(void)popAction;       //返回按钮操作
@end
