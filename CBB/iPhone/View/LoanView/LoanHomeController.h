//
//  LoanHomeController.h
//  CBB
//
//  Created by 卡宝宝 on 14-2-17.
//  Copyright (c) 2014年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface LoanHomeController : UIViewController
@property(nonatomic,retain)IBOutlet UIImageView *avatar;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel;
@property(nonatomic,retain)IBOutlet UILabel *companyLabel;
@property(nonatomic,retain)IBOutlet UILabel *moneyLabel;
@property(nonatomic,retain)IBOutlet UILabel *askLabel;
@property(nonatomic,retain)IBOutlet UILabel *matchReg;
@property(nonatomic,retain)IBOutlet UILabel *toMeReg;
@property(nonatomic,retain)IBOutlet UILabel *monthLabel;
@property(nonatomic,retain)IBOutlet UILabel *doneNumLabel;
@property(nonatomic,retain)IBOutlet UILabel *successNumLabel;
@property(nonatomic,retain)IBOutlet UILabel *successPercentLabel;
@property(nonatomic,retain)IBOutlet UILabel *buyNumLabel;
@property(nonatomic,retain)IBOutlet UILabel *payNumLabel;
@property(nonatomic,retain)IBOutlet TouchLabel *payLabel;
@end
