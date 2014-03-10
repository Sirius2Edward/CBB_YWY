//
//  CardHomePage.h
//  CBB
//
//  Created by 卡宝宝 on 13-10-12.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
@interface CardHomePage : UIViewController
@property(nonatomic,retain)IBOutlet UIImageView *avatar;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel;
@property(nonatomic,retain)IBOutlet UILabel *cityLabel;
@property(nonatomic,retain)IBOutlet UILabel *bankLabel;
@property(nonatomic,retain)IBOutlet UIButton *latestButton;
@property(nonatomic,retain)IBOutlet UILabel *moneyLabel;
@property(nonatomic,retain)IBOutlet UILabel *monthLabel;
@property(nonatomic,retain)IBOutlet UILabel *doneNumLabel;
@property(nonatomic,retain)IBOutlet UILabel *successNumLabel;
@property(nonatomic,retain)IBOutlet UILabel *successPercentLabel;
@property(nonatomic,retain)IBOutlet UILabel *payNumLabel;
@property(nonatomic,retain)IBOutlet TouchLabel *payLabel;
@end
