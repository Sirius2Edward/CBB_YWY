//
//  LoanClientSift.h
//  CBB
//
//  Created by 卡宝宝 on 13-9-26.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanClientSift : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property(nonatomic,retain)NSDictionary *city;
@property(nonatomic,retain)NSArray *usage;
@property(nonatomic,retain)NSArray *pickerData;
@property(nonatomic,retain)NSMutableDictionary *paramters;

typedef void (^block)(void);
@property(nonatomic,copy)block completion;
-(void)dismissAction;
@end


@interface NewClientSift : LoanClientSift
@end

@interface ForMyShopClientSift : LoanClientSift
@end

@interface ForMyProductClientSift : NewClientSift
@end

@interface BoughtClientSift : LoanClientSift
@property(nonatomic,retain)NSArray *status;
@end